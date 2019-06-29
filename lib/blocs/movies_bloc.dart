import 'dart:convert';

import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/randommovie_repository.dart';
import 'package:MEXT/data/repositories/user_lists_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesBloc extends ChangeNotifier {
  MoviesBloc();

  final _userRep = new UserListsRepository();

  bool _loading = false;
  String _error = '';

  Movie _currentMovie;
  List<Genre> _allGenres;

  String _filterWithGenres;
  String _filterWithoutGenres;
  int _filterRating;
  int _filterYear;
  int _filterVoteCount;
  bool _filterExcludeWatched;

  var movieHistory = new List<Movie>();

  List<Movie> _userWatchedMovies;
  List<Movie> _userToWatchMovies;
  List<Movie> _userFavouriteMovies;
  List<Movie> _userSuggestedMovies;

  Future<void> init(int userId) async {
    print('movies bloc initializing');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var filters = jsonDecode(_prefs.getString(kFilters) ?? '{}');

    this._filterWithGenres = filters[kWithGenres] ?? '';
    this._filterWithoutGenres = filters[kWithoutGenres] ?? '';
    this._filterRating = filters[kRating] ?? 0;
    this._filterYear = filters[kYear] ?? 0;
    this._filterVoteCount = filters[kVotes] ?? 0;
    this._filterExcludeWatched = filters[kExcludeWatched] ?? false;

    if (userId != null) await this._getUserLists(userId);
    await this._getRandomMovie();
  }

  get userWatchedMovies => _userWatchedMovies;
  get userToWatchMovies => _userToWatchMovies;
  get userFavouriteMovies => _userFavouriteMovies;
  get userSuggestedMovies => _userSuggestedMovies;

  Future<void> addUserWatchedMovie(int userId, Movie movie) async {
    final response = await _userRep.addWatched(userId, movie);
    if (response.hasError)
      throw response.error;
    else {
      this._userWatchedMovies.add(movie);
      int index = this._userToWatchMovies.indexWhere((m) => m.id == movie.id);
      if (index >= 0) this._userToWatchMovies.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> addUserToWatchMovie(int userId, Movie movie) async {
    final response = await _userRep.addToWatch(userId, movie);
    if (response.hasError)
      throw response.error;
    else {
      this._userToWatchMovies.add(movie);
      notifyListeners();
    }
  }

  Future<void> addUserFavouriteMovie(int userId, Movie movie) async {
    final response = await _userRep.addFavourites(userId, movie);
    if (response.hasError)
      throw response.error;
    else {
      this._userFavouriteMovies.add(movie);
      notifyListeners();
    }
  }

  Future<void> removeUserWatchedMovie(int userId, Movie movie) async {
    final response = await _userRep.removeWatched(userId, movie);
    if (response.hasError)
      throw response.error;
    else {
      this._userWatchedMovies.remove(movie);
      notifyListeners();
    }
  }

  Future<void> removeUserToWatchMovie(int userId, Movie movie) async {
    final response = await _userRep.removeToWatch(userId, movie);
    if (response.hasError)
      throw response.error;
    else {
      this._userToWatchMovies.remove(movie);
      notifyListeners();
    }
  }

  Future<void> removeUserFavouriteMovie(int userId, Movie movie) async {
    final response = await _userRep.removeFavourites(userId, movie);
    if (response.hasError)
      throw response.error;
    else {
      this._userFavouriteMovies.remove(movie);
      notifyListeners();
    }
  }

  Future<void> getUserSuggestedMovies(int userId) async {
    final response = await _userRep.getSuggested(userId);
    if (response.hasError) {
      this._error = response.error;
      this._userSuggestedMovies = [];
    } else {
      this._error = '';
      this._userSuggestedMovies = response.list;
    }
    notifyListeners();
  }

  bool get loading => _loading;

  String get error => _error;

  Movie get currentMovie => _currentMovie;

  List<Genre> get allGenres => _allGenres;

  set allGenres(List<Genre> genres) {
    _allGenres = genres;
    notifyListeners();
  }

  String get filterWithGenres => _filterWithGenres;

  set filterWithGenres(String genres) {
    _filterWithGenres = genres;
    notifyListeners();
  }

  String get filterWithoutGenres => _filterWithoutGenres;

  set filterWithoutGenres(String genres) {
    _filterWithoutGenres = genres;
    notifyListeners();
  }

  int get filterRating => _filterRating;

  set filterRating(int rating) {
    if (rating < 0 || rating > 10) rating = 0;
    _filterRating = rating;
    notifyListeners();
  }

  int get filterYear => _filterYear;

  set filterYear(int year) {
    if (year < 0 || year > DateTime.now().year) year = 0;
    _filterYear = year;
    notifyListeners();
  }

  int get filterVoteCount => _filterVoteCount;

  set filterVoteCount(int voteCount) {
    if (voteCount < 0) voteCount = 0;
    _filterVoteCount = voteCount;
    notifyListeners();
  }

  bool get filterExcludeWatched => _filterExcludeWatched;

  set filterExcludeWatched(bool excludeWatch) {
    _filterExcludeWatched = excludeWatch;
    notifyListeners();
  }

  Future<void> getRandomMovie() async {
    _loading = true;
    notifyListeners();

    await this._getRandomMovie();

    _loading = false;
    notifyListeners();
  }

  Future<void> _getRandomMovie() async {
    var rndMovie = new RandomMovieRepository(
        withGenres: this._filterWithGenres,
        withoutGenres: this._filterWithoutGenres,
        rating: this._filterRating,
        year: this._filterYear,
        voteCount: this._filterVoteCount,
        excludeWatched: this._filterExcludeWatched);

    var response = await rndMovie.getMovieAndGenres();
    if (response.hasError) {
      _error = response.error;
    } else {
      _error = '';
      this._currentMovie = response.movie;
      this.movieHistory.add(response.movie);
    }
  }

  Future<void> getUserLists(int userId) async {
    _loading = true;
    notifyListeners();

    await this._getUserLists(userId);

    _loading = false;
    notifyListeners();
  }

  Future<void> _getUserLists(int userId) async {
    final response = await _userRep.getWatched(userId);
    if (response.hasError)
      _error = response.error;
    else {
      this._userWatchedMovies = response.list;
    }

    final towatch = await _userRep.getToWatch(userId);
    if (towatch.hasError)
      _error = towatch.error;
    else {
      this._userToWatchMovies = towatch.list;
    }

    final favourites = await _userRep.getFavourites(userId);
    if (favourites.hasError)
      _error = favourites.error;
    else {
      this._userFavouriteMovies = favourites.list;
    }
  }

  clearUserLists() {
    _userFavouriteMovies = null;
    _userToWatchMovies = null;
    _userWatchedMovies = null;
    notifyListeners();
  }
}

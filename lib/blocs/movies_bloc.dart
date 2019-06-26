import 'dart:convert';

import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/randommovie_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesBloc extends ChangeNotifier {
  MoviesBloc();

  bool _loading;
  String _error;

  Movie _currentMovie;
  List<Genre> _allGenres;

  String _filterWithGenres;
  String _filterWithoutGenres;
  int _filterRating;
  int _filterYear;
  int _filterVoteCount;
  bool _filterExcludeWatched;

  var movieHistory = new List<Movie>();

  List<Movie> userWatchedMovies;
  List<Movie> userToWatchMovies;
  List<Movie> userFavouriteMovies;

  Future<void> init() async {
    print('movies bloc initializing');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var filters = jsonDecode(_prefs.getString(kFilters) ?? '{}');

    this._filterWithGenres = filters[kWithGenres] ?? '';
    this._filterWithoutGenres = filters[kWithoutGenres] ?? '';
    this._filterRating = filters[kRating] ?? 0;
    this._filterYear = filters[kYear] ?? 0;
    this._filterVoteCount = filters[kVotes] ?? 0;
    this._filterExcludeWatched = filters[kExcludeWatched] ?? false;
  }

  bool get loading => _loading;

  String get error => _error;

  Movie get currentMovie => _currentMovie;

  set currentMovie(Movie movie) {
    _currentMovie = movie;
    notifyListeners();
  }

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

  Future<Movie> getRandomMovie() async {
    _loading = true;

    Movie m;

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
      m = null;
    } else {
      _error = '';
      this._currentMovie = response.movie;
      this.movieHistory.add(response.movie);
      m = response.movie;
    }

    _loading = false;

    return m;
  }

  clearUserLists() {
    userFavouriteMovies = null;
    userToWatchMovies = null;
    userWatchedMovies = null;
    notifyListeners();
  }
}

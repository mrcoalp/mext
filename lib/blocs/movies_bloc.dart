import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:flutter/material.dart';

class MoviesBloc extends ChangeNotifier {
  Movie _currentMovie;
  List<Genre> _allGenres;

  String _filterWithGenres = '';
  String _filterWithoutGenres = '';
  int _filterRating = 0;
  int _filterYear = 0;
  int _filterVoteCount = 0;
  bool _filterExcludeWatched = false;

  var movieHistory = new List<Movie>();

  List<Movie> userWatchedMovies;
  List<Movie> userToWatchMovies;
  List<Movie> userFavouriteMovies;

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

  clearUserLists() {
    userFavouriteMovies = null;
    userToWatchMovies = null;
    userWatchedMovies = null;
    notifyListeners();
  }
}

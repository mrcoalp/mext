import 'package:MEXT/data/models/movie.dart';
import 'package:flutter/material.dart';

class MoviesBloc extends ChangeNotifier {
  Movie _currentMovie;
  List<String> _currentGenres;

  get currentMovie => _currentMovie;

  set currentMovie(Movie movie) {
    this._currentMovie = movie;
    notifyListeners();
  }

  get currentGenres => _currentGenres;

  set currentGenres(List<String> genres) {
    this._currentGenres = genres;
    notifyListeners();
  }
}

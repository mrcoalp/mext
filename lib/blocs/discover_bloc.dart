import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/movie_lists_repository.dart';
import 'package:flutter/material.dart';

class DiscoverBloc extends ChangeNotifier {
  DiscoverBloc();

  List<Movie> _trending, _nowPlaying, _popular, _upcoming;
  String _error = '';

  List<Movie> get trending => _trending;
  List<Movie> get nowPlaying => _nowPlaying;
  List<Movie> get popular => _popular;
  List<Movie> get upcoming => _upcoming;

  String get error => _error;

  final _movieListsRepository = new MovieListsRepository();

  Future<List<Movie>> getTrending() async {
    final response = await _movieListsRepository.getTrending();
    if (response.hasError) {
      _error = response.error;
      _trending = [];
    } else {
      _error = '';
      _trending = response.list;
    }

    return _trending;
  }

  Future<List<Movie>> getNowPlaying() async {
    final response = await _movieListsRepository.getNowPlaying();
    if (response.hasError) {
      _error = response.error;
      _nowPlaying = [];
    } else {
      _error = '';
      _nowPlaying = response.list;
    }

    return _nowPlaying;
  }

  Future<List<Movie>> getPopular() async {
    final response = await _movieListsRepository.getPopular();
    if (response.hasError) {
      _error = response.error;
      _popular = [];
    } else {
      _error = '';
      _popular = response.list;
    }

    return _popular;
  }

  Future<List<Movie>> getUpcoming() async {
    final response = await _movieListsRepository.getUpcoming();
    if (response.hasError) {
      _error = response.error;
      _upcoming = [];
    } else {
      _error = '';
      _upcoming = response.list;
    }

    return _upcoming;
  }

  Future<void> getMovieLists() async {
    var response = await _movieListsRepository.getTrending();
    if (response.hasError) {
      _error = response.error;
      _trending = [];
    } else {
      _error = '';
      _trending = response.list;
    }

    response = await _movieListsRepository.getNowPlaying();
    if (response.hasError) {
      _error = response.error;
      _nowPlaying = [];
    } else {
      _error = '';
      _nowPlaying = response.list;
    }

    response = await _movieListsRepository.getPopular();
    if (response.hasError) {
      _error = response.error;
      _popular = [];
    } else {
      _error = '';
      _popular = response.list;
    }

    response = await _movieListsRepository.getUpcoming();
    if (response.hasError) {
      _error = response.error;
      _upcoming = [];
    } else {
      _error = '';
      _upcoming = response.list;
    }

    notifyListeners();
  }
}

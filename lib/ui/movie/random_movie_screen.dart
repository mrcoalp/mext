import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/repositories/randommovie_repository.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/user_lists_repository.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/movie/filter_screen.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
import 'package:MEXT/ui/movie/movie_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RandomMovieScreen extends StatefulWidget {
  @override
  _RandomMovieScreenState createState() => _RandomMovieScreenState();
}

class _RandomMovieScreenState extends State<RandomMovieScreen> {
  Movie _movie;
  String _genresString = '';
  List<Movie> _watched = [];
  final _userRep = new UserListsRepository();

  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);

    if (_moviesBloc.currentMovie == null && _error == '')
      this._getRandomMovie(_moviesBloc);
    else {
      _movie = _moviesBloc.currentMovie;
      _genresString = '';
      for (Genre g in _movie.genres)
        _genresString += _genresString != '' ? ', ${g.name}' : g.name;
    }

    if (_moviesBloc.userWatchedMovies == null &&
        _error == '' &&
        _authBloc.userId != null)
      this._getWatchedMovies(_authBloc.userId, _authBloc.token, _moviesBloc);
    else {
      _watched = _moviesBloc.userWatchedMovies == null
          ? []
          : _moviesBloc.userWatchedMovies;
    }

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            mini: true,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).accentColor,
            child: Icon(
              FontAwesomeIcons.history,
              size: 16,
            ),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MovieHistoryScreen())),
          ),
          SizedBox(height: 5),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).accentColor,
            mini: true,
            child: Icon(
              FontAwesomeIcons.filter,
              size: 16,
            ),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FilterScreen())),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: null,
            child: Icon(
              FontAwesomeIcons.random,
              size: 16,
            ),
            onPressed: () => _getRandomMovie(_moviesBloc),
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).accentColor),
              ),
            )
          : _error != ''
              ? CustomErrorWidget(error: _error)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _movie.poster_path != null
                        ? Hero(
                            tag: _movie.id,
                            child: Image.network(
                              '$kTMDBimgPath${_movie.poster_path}',
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              'No Movie Poster',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.9),
                              Theme.of(context).primaryColor.withOpacity(0.6),
                              Theme.of(context).primaryColor.withOpacity(0.3),
                              Colors.transparent
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 60, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _movie.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      'Rating: ${_movie.vote_average.toString()}'),
                                  SizedBox(width: 5),
                                  _ratingStars(_movie.vote_average),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                  '${_movie.release_date != '' ? _movie.release_date.replaceRange(4, _movie.release_date.length, '') : ''}'),
                              SizedBox(height: 5),
                              Text(_genresString),
                              SizedBox(height: 5),
                              Material(
                                elevation: 3,
                                shadowColor: Theme.of(context).accentColor,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      child: Text(
                                        'More Info',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailsScreen(_movie))),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    _watched.contains(_movie)
                        ? Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 11, 9),
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
    );
  }

  Widget _ratingStars(double rating) {
    final double halfRating = rating.roundToDouble() / 2;
    var stars = new List<Widget>(5);

    for (int i = 0; i < 5; i++) {
      if (halfRating <= i)
        stars[i] = Icon(
          Icons.star_border,
          size: 16,
        );
      else if (halfRating > i && halfRating < i + 1)
        stars[i] = Icon(
          Icons.star_half,
          size: 16,
        );
      else
        stars[i] = Icon(
          Icons.star,
          size: 16,
        );
    }

    return Row(
      children: stars,
    );
  }

  Future<void> _getRandomMovie(MoviesBloc mb) async {
    setState(() {
      _loading = true;
    });

    var rndMovie = new RandomMovieRepository(
        withGenres: mb.filterWithGenres,
        withoutGenres: mb.filterWithoutGenres,
        rating: mb.filterRating,
        year: mb.filterYear,
        voteCount: mb.filterVoteCount,
        excludeWatched: mb.filterExcludeWatched);

    var response = await rndMovie.getMovieAndGenres();
    if (response.hasError) {
      _error = response.error;
    } else {
      _error = '';
      this._movie = response.movie;
      mb.currentMovie = this._movie;
      mb.movieHistory.add(_movie);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _getWatchedMovies(
      int userId, String token, MoviesBloc mb) async {
    setState(() => _loading = true);

    final response = await _userRep.getWatched(userId, token);
    if (response.hasError)
      _error = response.error;
    else {
      _error = '';
      _watched = response.watched;
      mb.userWatchedMovies = response.watched;
    }

    setState(() => _loading = false);
  }
}

import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/movie/filter_screen.dart';
import 'package:MEXT/ui/movie/movie_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RandomMovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);

    List<Movie> _watched = _moviesBloc.userWatchedMovies ?? [];
    Movie _movie = _moviesBloc.currentMovie;
    String _genresString = '';

    if (_movie != null)
      for (Genre g in _movie.genres)
        _genresString += _genresString != '' ? ', ${g.name}' : g.name;

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
            onPressed: () => _moviesBloc.getRandomMovie(),
          ),
        ],
      ),
      body: _moviesBloc.loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).accentColor),
              ),
            )
          : _moviesBloc.error != ''
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomErrorWidget(error: _moviesBloc.error)
                  ],
                )
              : _movie == null
                  ? Center(
                      child: Container(
                        child: Text(
                          'No Movie Loaded... :\'(\n\nTry to hit that random button!!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : MEXTMovie(
                      movie: _movie,
                      genresString: _genresString,
                      watched: _watched,
                    ),
    );
  }
}

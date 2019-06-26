import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/movie/filter_screen.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
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
              ? Center(child: CustomErrorWidget(error: _moviesBloc.error))
              : _movie == null
                  ? Container(
                      child: Text('falta movie'),
                    )
                  : MEXTMovie(
                      movie: _movie,
                      genresString: _genresString,
                      watched: _watched,
                    ),
    );
  }
}

class MEXTMovie extends StatelessWidget {
  final Movie movie;
  final String genresString;
  final List<Movie> watched;

  MEXTMovie(
      {@required this.movie,
      @required this.genresString,
      @required this.watched});

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        movie.poster_path != null
            ? Hero(
                tag: movie.id,
                child: Image.network(
                  '$kTMDBimgPath${movie.poster_path}',
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
                    movie.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Rating: ${movie.vote_average.toString()}'),
                      SizedBox(width: 5),
                      _ratingStars(movie.vote_average),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                      '${movie.release_date != '' ? movie.release_date.replaceRange(4, movie.release_date.length, '') : ''}'),
                  SizedBox(height: 5),
                  Text(genresString),
                  SizedBox(height: 5),
                  Material(
                    elevation: 3,
                    shadowColor: Theme.of(context).accentColor,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
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
                                      MovieDetailsScreen(movie))),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        watched.indexWhere((m) => m.id == movie.id) >= 0
            ? Positioned(
                right: 10,
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
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
    );
  }
}

import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/repositories/randommovie_repository.dart';
import 'package:MEXT/data/models/movie.dart';
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
  var _genres = new List<String>();

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

    if (_moviesBloc.currentMovie == null)
      this._getRandomMovie(_moviesBloc);
    else {
      _movie = _moviesBloc.currentMovie;
      _genres = _moviesBloc.currentGenres;
    }

    String _genresString = '';
    for (String g in _genres) _genresString += _genresString != '' ? ', $g' : g;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                        : Container(),
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
                            colors:
                                Theme.of(context).brightness == Brightness.light
                                    ? [
                                        Colors.white,
                                        Colors.white70,
                                        Colors.white54,
                                        Colors.transparent
                                      ]
                                    : [
                                        Colors.black,
                                        Colors.black87,
                                        Colors.black54,
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
                                children: <Widget>[
                                  Text(
                                      'Rating: ${_movie.vote_average.toString()}'),
                                  SizedBox(width: 5),
                                  _ratingStars(_movie.vote_average),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                  '${_movie.release_date.replaceRange(4, _movie.release_date.length, '')}'),
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
                    )
                  ],
                ),
      //  ListView(
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: <Widget>[
      //           Container(
      //             width: MediaQuery.of(context).size.width / 3,
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: _movie.poster_path != null
      //                   ? Image.network(
      //                       '$kTMDBimgPath${_movie.poster_path}')
      //                   : Container(),
      //             ),
      //           ),
      //           Container(
      //             width: (MediaQuery.of(context).size.width / 3) * 2,
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   Text(
      //                     _movie.title,
      //                     style: TextStyle(fontWeight: FontWeight.bold),
      //                   ),
      //                   SizedBox(height: 10),
      //                   Text(
      //                       'Rating: ${_movie.vote_average.toString()}'),
      //                   Icon(FontAwesomeIcons.starHalfAlt),
      //                   SizedBox(height: 5),
      //                   Text('Release Date: ${_movie.release_date}'),
      //                   SizedBox(height: 5),
      //                   for (String g in _genres) Text(g),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text(
      //           _movie.overview,
      //           textAlign: TextAlign.justify,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 70,
      //       ),
      //     ],
      //   ),
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
      _genres = response.genres;
      mb.currentMovie = this._movie;
      mb.currentGenres = _genres;
      mb.movieHistory.add(_movie);
    }

    setState(() {
      _loading = false;
    });
  }
}

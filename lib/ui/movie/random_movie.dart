import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/http/api_randommovie.dart';
import 'package:MEXT/data/models/movie.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).accentColor,
            mini: true,
            child: Icon(
              FontAwesomeIcons.filter,
              size: 16,
            ),
            onPressed: null,
          ),
          SizedBox(width: 10),
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
          : ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                            'http://image.tmdb.org/t/p/w500${_movie.poster_path}'),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width / 3) * 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _movie.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('Rating: ${_movie.vote_average.toString()}'),
                            Icon(FontAwesomeIcons.starHalfAlt),
                            SizedBox(height: 5),
                            Text('Release Date: ${_movie.release_date}'),
                            SizedBox(height: 5),
                            for (String g in _genres) Text(g),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _movie.overview,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 70,
                )
              ],
            ),
    );
  }

  Future<void> _getRandomMovie(MoviesBloc mb) async {
    setState(() {
      _loading = true;
    });

    var rndMovie = new APIRandomMovie();

    var response = await rndMovie.getMovieAndGenres();
    this._movie = Movie.fromJson(response['movie']);
    print(this._movie.toJson());

    _genres = [];
    for (String g in response['genres']) _genres.add(g);

    mb.currentMovie = this._movie;
    mb.currentGenres = _genres;

    setState(() {
      _loading = false;
    });
  }
}

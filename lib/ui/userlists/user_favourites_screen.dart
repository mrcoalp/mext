import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteMoviesScreen extends StatefulWidget {
  @override
  _FavouriteMoviesScreenState createState() => _FavouriteMoviesScreenState();
}

class _FavouriteMoviesScreenState extends State<FavouriteMoviesScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final MoviesBloc _movies = Provider.of<MoviesBloc>(context);
    final AuthBloc _auth = Provider.of<AuthBloc>(context);

    List<Movie> _favourites = _movies.userFavouriteMovies ?? [];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _loading = true);
          await _movies.getUserLists(_auth.userId);
          setState(() => _loading = false);
        },
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                ),
              )
            : _auth.userId == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You must be logged in to access your movie lists',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : ListView(
                    children: <Widget>[
                      for (Movie m in _favourites) MovieCard(movie: m),
                      _favourites.isEmpty
                          ? Center(
                              child: Text('No movies added to favourites...'))
                          : Container()
                    ],
                  ),
      ),
    );
  }
}

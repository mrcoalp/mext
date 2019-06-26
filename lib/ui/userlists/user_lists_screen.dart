import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Screen { WATCHED, TOWATCH }

class UserListsScreen extends StatefulWidget {
  @override
  _UserListsScreenState createState() => _UserListsScreenState();
}

class _UserListsScreenState extends State<UserListsScreen> {
  List<Movie> _watched = [], _toWatch = [];
  var _screen = Screen.WATCHED;

  void _changeScreen(Screen s) {
    _screen = s;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);

    this._watched = _moviesBloc.userWatchedMovies ?? [];
    this._toWatch = _moviesBloc.userToWatchMovies ?? [];

    bool _loading = _moviesBloc.loading;
    String _error = _moviesBloc.error;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: null,
        // actions: <Widget>[
        //   _loading
        //       ? Center(
        //           child: CircularProgressIndicator(
        //           valueColor:
        //               AlwaysStoppedAnimation(Theme.of(context).accentColor),
        //         ))
        //       : IconButton(
        //           icon: Icon(Icons.refresh),
        //           onPressed: () => _authBloc.userId != null
        //               ? _moviesBloc.getUserLists(_authBloc.userId)
        //               : null,
        //         )
        // ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Text('Watched'),
              onPressed: () => _changeScreen(Screen.WATCHED),
              textColor: Theme.of(context).accentColor,
              color: _screen == Screen.WATCHED
                  ? Theme.of(context).textTheme.body1.color.withOpacity(0.07)
                  : Colors.transparent,
            ),
            FlatButton(
              child: Text('To Watch'),
              onPressed: () => _changeScreen(Screen.TOWATCH),
              textColor: Theme.of(context).accentColor,
              color: _screen == Screen.TOWATCH
                  ? Theme.of(context).textTheme.body1.color.withOpacity(0.07)
                  : Colors.transparent,
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _authBloc.userId != null
            ? _moviesBloc.getUserLists(_authBloc.userId)
            : null,
        child: _authBloc.userId != null
            ? _loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  )
                : _error == ''
                    ? _screen == Screen.WATCHED
                        ? ListView(
                            children: <Widget>[
                              for (Movie m in _watched) MovieCard(movie: m),
                            ],
                          )
                        : ListView(
                            children: <Widget>[
                              for (Movie m in _toWatch) MovieCard(movie: m),
                            ],
                          )
                    : CustomErrorWidget(
                        error: _error,
                      )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You must be logged in to access your movie lists',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),
    );
  }
}

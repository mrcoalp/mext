import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/user_lists_repository.dart';
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
  final _userRep = new UserListsRepository();
  bool _loading = false;
  String _error = '';
  var _screen = Screen.WATCHED;

  void _changeScreen(Screen s) {
    _screen = s;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);

    try {
      _authBloc.refreshTokens();
    } catch (e) {
      print(e.toString());
    }

    if (_moviesBloc.userWatchedMovies == null &&
        _error == '' &&
        _authBloc.userId != null)
      this._getWatchedMovies(_authBloc.userId, _authBloc.token, _moviesBloc);
    else {
      _watched = _moviesBloc.userWatchedMovies ?? [];
    }

    if (_moviesBloc.userToWatchMovies == null &&
        _error == '' &&
        _authBloc.userId != null)
      this._getToWatchMovies(_authBloc.userId, _authBloc.token, _moviesBloc);
    else {
      _toWatch = _moviesBloc.userToWatchMovies ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          _loading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                ))
              : IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _getWatchedMovies(
                        _authBloc.userId, _authBloc.token, _moviesBloc);
                    _getToWatchMovies(
                        _authBloc.userId, _authBloc.token, _moviesBloc);
                  },
                )
        ],
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
      body: _authBloc.userId != null
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
    );
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

  Future<void> _getToWatchMovies(
      int userId, String token, MoviesBloc mb) async {
    setState(() => _loading = true);

    final response = await _userRep.getToWatch(userId, token);
    if (response.hasError)
      _error = response.error;
    else {
      _error = '';
      _toWatch = response.towatch;
      mb.userToWatchMovies = response.towatch;
    }

    setState(() => _loading = false);
  }
}

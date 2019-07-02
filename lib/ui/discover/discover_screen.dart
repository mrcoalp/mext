import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/discover_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool _loading = true;
  List<Movie> _suggested, _trending, _nowPlaying, _popular, _upcoming;

  Future<void> _checkLists(DiscoverBloc db, MoviesBloc mb, int userId) async {
    if (db.trending == null &&
        db.nowPlaying == null &&
        db.popular == null &&
        db.upcoming == null) {
      await db.getMovieLists();
    }
    if (userId != null && mb.userSuggestedMovies == null) {
      await mb.getUserSuggestedMovies(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DiscoverBloc _discoverBloc = Provider.of<DiscoverBloc>(context);
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);

    _suggested = _moviesBloc.userSuggestedMovies ?? [];
    _trending = _discoverBloc.trending ?? [];
    _nowPlaying = _discoverBloc.nowPlaying ?? [];
    _popular = _discoverBloc.popular ?? [];
    _upcoming = _discoverBloc.upcoming ?? [];
    _loading = _discoverBloc.loading;

    this._checkLists(_discoverBloc, _moviesBloc, _authBloc.userId);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Text(''),
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  setState(() => _loading = true);
                  await _moviesBloc.getUserSuggestedMovies(_authBloc.userId);
                  setState(() => _loading = false);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen())),
              ),
            ],
          ),
          _discoverBloc.error != ''
              ? SliverFillRemaining(
                  child: CustomErrorWidget(
                    error: _discoverBloc.error,
                  ),
                )
              : SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      _loading
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).accentColor),
                              ),
                            )
                          : Container(),
                      if (_suggested.isNotEmpty && _authBloc.userId != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                          child: Text(
                            'Made for you, ${_authBloc.user.username}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      if (_suggested.isNotEmpty && _authBloc.userId != null)
                        Container(
                          height: 150,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (Movie m in _suggested)
                                MoviePosterNoAnimation(m),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                        child: Text(
                          'Trending',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      if (_trending.isNotEmpty)
                        Container(
                          height: 150,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (Movie m in _trending)
                                MoviePosterNoAnimation(m),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                        child: Text(
                          'Now playing on theaters',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      if (_nowPlaying.isNotEmpty)
                        Container(
                          height: 150,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (Movie m in _nowPlaying)
                                MoviePosterNoAnimation(m),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                        child: Text(
                          'Popular Movies',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      if (_popular.isNotEmpty)
                        Container(
                          height: 150,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (Movie m in _popular)
                                MoviePosterNoAnimation(m),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                        child: Text(
                          'Upcoming Movies',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      if (_upcoming.isNotEmpty)
                        Container(
                          height: 150,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (Movie m in _upcoming)
                                MoviePosterNoAnimation(m),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

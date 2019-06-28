import 'package:MEXT/blocs/discover_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/drawer/drawer.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool _loading = true;
  List<Movie> _trending, _nowPlaying, _popular, _upcoming;

  Future<void> _checkLists(DiscoverBloc db) async {
    if (db.trending == null &&
        db.nowPlaying == null &&
        db.popular == null &&
        db.upcoming == null) {
      setState(() => _loading = true);
      await db.getMovieLists();
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DiscoverBloc _discoverBloc = Provider.of<DiscoverBloc>(context);

    _trending = _discoverBloc.trending ?? [];
    _nowPlaying = _discoverBloc.nowPlaying ?? [];
    _popular = _discoverBloc.popular ?? [];
    _upcoming = _discoverBloc.upcoming ?? [];

    this._checkLists(_discoverBloc);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Text(''),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.cog),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DrawerMEXT())),
              ),
            ],
          ),
          _loading
              ? SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  ),
                )
              : _discoverBloc.error != ''
                  ? SliverFillRemaining(
                      child: CustomErrorWidget(
                        error: _discoverBloc.error,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                            child: Text(
                              'Trending',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          if (_trending.length > 0)
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
                          if (_nowPlaying.length > 0)
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
                          if (_popular.length > 0)
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
                          if (_upcoming.length > 0)
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

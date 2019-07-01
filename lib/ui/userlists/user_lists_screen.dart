import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/auth/login_register_screen.dart';
import 'package:MEXT/ui/drawer/drawer.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum Screen { WATCHED, TOWATCH, FAVOURITES }

class UserListsScreen extends StatefulWidget {
  @override
  _UserListsScreenState createState() => _UserListsScreenState();
}

class _UserListsScreenState extends State<UserListsScreen>
    with SingleTickerProviderStateMixin {
  List<Movie> _watched = [], _toWatch = [], _favourites = [];
  // var _screen = Screen.WATCHED;

  // void _changeScreen(Screen s) {
  //   _screen = s;
  //   setState(() {});
  // }

  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);

    this._watched = _moviesBloc.userWatchedMovies ?? [];
    this._toWatch = _moviesBloc.userToWatchMovies ?? [];
    this._favourites = _moviesBloc.userFavouriteMovies ?? [];

    bool _loading = _moviesBloc.loading;
    String _error = _moviesBloc.error;

    // Widget _show;

    // switch (_screen) {
    //   case Screen.WATCHED:
    //     _show = WatchedList(watched: _watched);

    //     break;
    //   case Screen.TOWATCH:
    //     _show = ToWatchList(toWatch: _toWatch);

    //     break;
    //   case Screen.FAVOURITES:
    //     _show = FavouritesList(favourites: _favourites);

    //     break;
    //   default:
    //     break;
    // }

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   centerTitle: true,
      //   leading: null,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       FlatButton(
      //         child: Text('Watched'),
      //         onPressed: () => _changeScreen(Screen.WATCHED),
      //         textColor: Theme.of(context).accentColor,
      //         color: _screen == Screen.WATCHED
      //             ? Theme.of(context).textTheme.body1.color.withOpacity(0.07)
      //             : Colors.transparent,
      //       ),
      //       FlatButton(
      //         child: Text('To Watch'),
      //         onPressed: () => _changeScreen(Screen.TOWATCH),
      //         textColor: Theme.of(context).accentColor,
      //         color: _screen == Screen.TOWATCH
      //             ? Theme.of(context).textTheme.body1.color.withOpacity(0.07)
      //             : Colors.transparent,
      //       ),
      //       FlatButton(
      //         child: Text('Favourites'),
      //         onPressed: () => _changeScreen(Screen.FAVOURITES),
      //         textColor: Theme.of(context).accentColor,
      //         color: _screen == Screen.FAVOURITES
      //             ? Theme.of(context).textTheme.body1.color.withOpacity(0.07)
      //             : Colors.transparent,
      //       )
      //     ],
      //   ),
      // ),
      body: _authBloc.userId != null
          ? _loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  ),
                )
              : _error == ''
                  ? NestedScrollView(
                      controller: _scrollViewController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            title: Text(_authBloc.user?.username ?? 'MEXT'),
                            pinned: true,
                            floating: true,
                            forceElevated: innerBoxIsScrolled,
                            automaticallyImplyLeading: false,
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: () => _authBloc.userId != null
                                    ? _moviesBloc.getUserLists(_authBloc.userId)
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => DrawerMEXT())),
                              ),
                            ],
                            bottom: TabBar(
                              tabs: <Tab>[
                                Tab(
                                  icon: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 16,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    FontAwesomeIcons.clock,
                                    size: 16,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    FontAwesomeIcons.heart,
                                    size: 16,
                                  ),
                                ),
                              ],
                              controller: _tabController,
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: <Widget>[
                          RefreshIndicator(
                              onRefresh: () => _authBloc.userId != null
                                  ? _moviesBloc.getUserLists(_authBloc.userId)
                                  : null,
                              child: WatchedList(watched: _watched)),
                          ToWatchList(toWatch: _toWatch),
                          FavouritesList(favourites: _favourites),
                        ],
                        controller: _tabController,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomErrorWidget(
                          error: _error,
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () => _authBloc.userId != null
                              ? _moviesBloc.getUserLists(_authBloc.userId)
                              : null,
                        )
                      ],
                    )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'You must be logged in to access your movie lists',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => LoginRegisterScreen())),
                  )
                ],
              ),
            ),
    );
  }
}

class WatchedList extends StatelessWidget {
  final List<Movie> watched;

  WatchedList({this.watched});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (Movie m in watched) MovieCard(movie: m),
        if (watched.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('No movies watched...'),
            ),
          )
      ],
    );
  }
}

class ToWatchList extends StatelessWidget {
  final List<Movie> toWatch;

  ToWatchList({this.toWatch});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (Movie m in toWatch) MovieCard(movie: m),
        if (toWatch.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('No movies saved to watch later...'),
            ),
          )
      ],
    );
  }
}

class FavouritesList extends StatelessWidget {
  final List<Movie> favourites;

  FavouritesList({this.favourites});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (Movie m in favourites) MovieCard(movie: m),
        if (favourites.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('No movie marked as favourite...'),
            ),
          )
      ],
    );
  }
}

import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/movie_info.dart';
import 'package:MEXT/data/repositories/movie_details_repository.dart';
import 'package:MEXT/data/repositories/user_lists_repository.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

enum UserList { Watched, ToWatch, Favourites }

class MovieDetailsScreen extends StatefulWidget {
  final Movie _movie;

  MovieDetailsScreen(this._movie);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _movieDetails = const MovieDetailsRepository();
  final _userListsRep = const UserListsRepository();
  bool _loadingMoreInfo = false;
  bool _loadingSimilar = false;
  String _error = '';
  List<String> _trailers;
  MovieInfo _movieInfo;
  List<Movie> _similar;
  List<Movie> _watched, _towatch, favourites;

  @override
  void initState() {
    super.initState();
    this._getDetails(widget._movie.id);
    this._getSimilar(widget._movie.id);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);

    // try {
    //   _authBloc.refreshTokens();
    // } catch (e) {
    //   print(e.toString());
    // }

    _watched = _moviesBloc.userWatchedMovies ?? [];
    _towatch = _moviesBloc.userToWatchMovies ?? [];

    String _genresString = '';
    for (Genre g in widget._movie.genres)
      _genresString += _genresString != '' ? ', ${g.name}' : g.name;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          MovieDetailsAppBar(movie: widget._movie),
          SliverPadding(
            padding: const EdgeInsets.all(15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Text(
                    '${widget._movie.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Rating: ${widget._movie.vote_average.toString()}'),
                      SizedBox(width: 5),
                      _ratingStars(widget._movie.vote_average),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(_genresString),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.eye,
                          color: _watched.indexWhere(
                                      (m) => m.id == widget._movie.id) >=
                                  0
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.body1.color,
                        ),
                        onPressed: () => _watched.indexWhere(
                                    (m) => m.id == widget._movie.id) >=
                                0
                            ? _removeFromList(
                                UserList.Watched,
                                _authBloc.userId,
                                _authBloc.token,
                                widget._movie,
                                _moviesBloc)
                            : _addToList(UserList.Watched, _authBloc.userId,
                                _authBloc.token, widget._movie, _moviesBloc),
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.film,
                          color: _towatch.indexWhere(
                                      (m) => m.id == widget._movie.id) >=
                                  0
                              ? Theme.of(context).accentColor
                              : Theme.of(context).textTheme.body1.color,
                        ),
                        onPressed: () => _towatch.indexWhere(
                                    (m) => m.id == widget._movie.id) >=
                                0
                            ? _removeFromList(
                                UserList.ToWatch,
                                _authBloc.userId,
                                _authBloc.token,
                                widget._movie,
                                _moviesBloc)
                            : _addToList(UserList.ToWatch, _authBloc.userId,
                                _authBloc.token, widget._movie, _moviesBloc),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.heart),
                        onPressed: null,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text('${widget._movie.release_date}'),
                  SizedBox(height: 5),
                  Text('Vote Count: ${widget._movie.vote_count}'),
                  SizedBox(height: 5),
                  Text('Original Title: ${widget._movie.original_title}'),
                  SizedBox(height: 5),
                  Text('Original Language: ${widget._movie.original_language}'),
                  SizedBox(height: 20),
                  Text(
                    widget._movie.overview,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  _loadingMoreInfo || _loadingSimilar
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).accentColor),
                          ),
                        )
                      : _error != ''
                          ? CustomErrorWidget(error: _error)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Runtime: ${_movieInfo.runtime} mins'),
                                SizedBox(height: 20),
                                for (String t in _trailers)
                                  TrailerThumbnail(
                                    t,
                                    () async {
                                      await _launchURL(
                                          'https://www.youtube.com/watch?v=$t');
                                    },
                                  ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    _movieInfo.tagline ?? '',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _movieInfo.tagline != ''
                                    ? SizedBox(height: 10)
                                    : Container(),
                                Row(
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.amber,
                                      child: Text('IMDB'),
                                      onPressed: () => _launchURL(
                                          'https://www.imdb.com/title/${_movieInfo.imdb_id}'),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () => Share.share(
                                          'Check out this movie I discovered on MEXT!: https://www.imdb.com/title/${_movieInfo.imdb_id}'),
                                    )
                                  ],
                                ),
                                SizedBox(height: 30),
                                _similar.length > 0
                                    ? Text(
                                        'Similar Movies',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(),
                                _similar.length > 0
                                    ? Container(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: <Widget>[
                                            for (Movie m in _similar)
                                              MoviePoster(m),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                ],
              ),
            ),
          )
        ],
      ),
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

  Future<void> _getDetails(int id) async {
    setState(() {
      _loadingMoreInfo = true;
    });

    var trailers = await _movieDetails.getTrailers(id);
    if (trailers.hasError)
      _error = trailers.error;
    else {
      _error = '';
      _trailers = trailers.trailers;
    }

    var info = await _movieDetails.getMoreInfo(id);
    if (info.hasError)
      _error = info.error;
    else {
      _error = '';
      _movieInfo = info.movieInfo;
    }

    setState(() {
      _loadingMoreInfo = false;
    });
  }

  Future<void> _getSimilar(int id) async {
    setState(() => _loadingSimilar = true);

    var similar = await _movieDetails.getSimilar(id);
    if (similar.hasError)
      _error = similar.error;
    else {
      _error = '';
      _similar = similar.similar;
    }

    setState(() => _loadingSimilar = false);
  }

  Future<void> _addToList(
      UserList list, int id, String token, Movie movie, MoviesBloc mb) async {
    Function add, addToBloc;
    String alertTitle, alertContent, toastMsg;

    if (id != null) {
      switch (list) {
        case UserList.Watched:
          {
            add = _userListsRep.addWatched;
            addToBloc = mb.userWatchedMovies.add;
            alertTitle = 'Add to watched list?';
            alertContent = 'Add \'${movie.title}\' to watched movies list?';
            toastMsg = '${movie.title} added to watched list';
            break;
          }
        case UserList.ToWatch:
          {
            add = _userListsRep.addToWatch;
            addToBloc = mb.userToWatchMovies.add;
            alertTitle = 'Save to watch later?';
            alertContent = 'Save \'${movie.title}\' to watch later?';
            toastMsg = '${movie.title} saved to watch later';
            break;
          }

        default:
          break;
      }

      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(alertTitle),
              content: Text(alertContent),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () async {
                    final response = await add(id, token, movie);
                    if (response.hasError) {
                      Navigator.of(context).pop();

                      setState(() {});

                      Flushbar(
                        message: '${response.error}',
                        duration: Duration(seconds: 2),
                      )..show(context);
                    } else {
                      _error = '';
                      addToBloc(widget._movie);

                      Navigator.of(context).pop();

                      setState(() {});

                      Flushbar(
                        message: toastMsg,
                        duration: Duration(seconds: 2),
                      )..show(context);
                    }
                  },
                )
              ],
            );
          });
    } else
      _showDialogNotLoggedIn();
  }

  Future<void> _removeFromList(
      UserList list, int id, String token, Movie movie, MoviesBloc mb) async {
    Function remove, removeFromBloc;
    String alertTitle, alertContent, toastMsg;

    if (id != null) {
      switch (list) {
        case UserList.Watched:
          {
            remove = _userListsRep.removeWatched;
            removeFromBloc = mb.userWatchedMovies.remove;
            alertTitle = 'Remove from watched list?';
            alertContent =
                'Remove \'${movie.title}\' from watched movies list?';
            toastMsg = '${movie.title} removed from watched list';
            break;
          }
        case UserList.ToWatch:
          {
            remove = _userListsRep.removeToWatch;
            removeFromBloc = mb.userToWatchMovies.remove;
            alertTitle = 'Remove from watch later?';
            alertContent = 'Remove \'${movie.title}\' from watch later?';
            toastMsg = '${movie.title} removed from watch later';
            break;
          }

        default:
          break;
      }

      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(alertTitle),
              content: Text(alertContent),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () async {
                    final response = await remove(id, token, movie);
                    if (response.hasError) {
                      Navigator.of(context).pop();

                      setState(() {});

                      Flushbar(
                        message: '${response.error}',
                        duration: Duration(seconds: 2),
                      )..show(context);
                    } else {
                      _error = '';
                      removeFromBloc(widget._movie);

                      Navigator.of(context).pop();

                      setState(() {});

                      Flushbar(
                        message: toastMsg,
                        duration: Duration(seconds: 2),
                      )..show(context);
                    }
                  },
                )
              ],
            );
          });
    } else
      _showDialogNotLoggedIn();
  }

  void _showDialogNotLoggedIn() => showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text('You must be logged in to save lists'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

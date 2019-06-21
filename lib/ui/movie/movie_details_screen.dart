import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/movie_info.dart';
import 'package:MEXT/data/repositories/movie_details_repository.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie _movie;

  MovieDetailsScreen(this._movie);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _movieDetails = const MovieDetailsRepository();
  bool _loadingMoreInfo = false;
  bool _loadingSimilar = false;
  String _error = '';
  List<String> _trailers;
  MovieInfo _movieInfo;
  List<Movie> _similar;

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
                                RaisedButton(
                                  color: Colors.amber,
                                  child: Text('IMDB'),
                                  onPressed: () => _launchURL(
                                      'https://www.imdb.com/title/${_movieInfo.imdb_id}'),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
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

      print(_similar);
    }

    setState(() => _loadingSimilar = false);
  }
}

class MovieDetailsAppBar extends StatelessWidget {
  final Movie movie;

  MovieDetailsAppBar({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      expandedHeight: (MediaQuery.of(context).size.height / 3) * 2.5,
      floating: false,
      pinned: true,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).primaryTextTheme.body1.color,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // title: ConstrainedBox(
        //   constraints: BoxConstraints(
        //     maxWidth: MediaQuery.of(context).size.width - 192,
        //   ),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).brightness == Brightness.light
        //           ? Colors.white70
        //           : Colors.black87,
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        //       child: Text(
        //         movie.title,
        //         textScaleFactor: .8,
        //       ),
        //     ),
        //   ),
        // ),
        background: movie.poster_path != null
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
      ),
    );
  }
}

class TrailerThumbnail extends StatelessWidget {
  final String videoID;
  final Function onTap;

  TrailerThumbnail(this.videoID, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 5,
          color: Colors.transparent,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white70,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://img.youtube.com/vi/$videoID/0.jpg'),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final Movie movie;

  MoviePoster(this.movie);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie))),
        child: Material(
          elevation: 5,
          color: Colors.transparent,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage('$kTMDBimgPath${movie.poster_path}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

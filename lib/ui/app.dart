import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: ListTile(
          leading: movie.poster_path != null
              ? Hero(
                  tag: movie.id,
                  child: Image.network('$sTMDBimgPath${movie.poster_path}'),
                )
              : SizedBox(),
          title: Text(
            movie.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  '${movie.release_date != '' ? movie.release_date.replaceRange(4, movie.release_date.length, '') : ''}, ${movie.vote_average}'),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.star,
                size: 12,
              ),
            ],
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie))),
        ),
      ),
    );
  }
}

class MovieDetailsAppBar extends StatelessWidget {
  final Movie movie;

  MovieDetailsAppBar({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      expandedHeight: (MediaQuery.of(context).size.height / 3) * 2.5,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      // leading: CircleAvatar(
      //   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      //   child: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.of(context).pop(),
      //     color: Theme.of(context).primaryTextTheme.body1.color,
      //   ),
      // ),
      // actions: <Widget>[
      //   CircleAvatar(
      //     backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      //     child: IconButton(
      //       icon: Icon(Icons.home),
      //       onPressed: () => Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (context) => MovieTabs())),
      //       color: Theme.of(context).primaryTextTheme.body1.color,
      //     ),
      //   ),
      // ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: movie.poster_path != null
            ? Hero(
                tag: movie.id,
                child: Image.network(
                  '$sTMDBimgPath${movie.poster_path}',
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
                  borderRadius: BorderRadius.circular(10),
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
            child: Hero(
              tag: movie.id,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage('$sTMDBimgPath${movie.poster_path}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MoviePosterNoAnimation extends StatelessWidget {
  final Movie movie;

  MoviePosterNoAnimation(this.movie);

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
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage('$sTMDBimgPath${movie.poster_path}'),
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

class MEXTMovie extends StatelessWidget {
  final Movie movie;
  final String genresString;
  final List<Movie> watched;

  MEXTMovie(
      {@required this.movie,
      @required this.genresString,
      @required this.watched});

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        movie.poster_path != null
            ? Hero(
                tag: movie.id,
                child: Image.network(
                  '$sTMDBimgPath${movie.poster_path}',
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
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.9),
                  Theme.of(context).primaryColor.withOpacity(0.6),
                  Theme.of(context).primaryColor.withOpacity(0.3),
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
                    movie.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Rating: ${movie.vote_average.toString()}'),
                      SizedBox(width: 5),
                      _ratingStars(movie.vote_average),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                      '${movie.release_date != '' ? movie.release_date.replaceRange(4, movie.release_date.length, '') : ''}'),
                  SizedBox(height: 5),
                  Text(genresString),
                  SizedBox(height: 5),
                  Material(
                    elevation: 3,
                    shadowColor: Theme.of(context).accentColor,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          child: Text(
                            'More Info',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailsScreen(movie))),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        watched.indexWhere((m) => m.id == movie.id) >= 0
            ? Positioned(
                right: 10,
                top: 10,
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 11, 9),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.eye,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

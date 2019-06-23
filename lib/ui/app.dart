import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:flutter/material.dart';

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
                  child: Image.network('$kTMDBimgPath${movie.poster_path}'),
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
      backgroundColor: Theme.of(context).primaryColor,
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
      actions: <Widget>[
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
          child: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MovieTabs())),
            color: Theme.of(context).primaryTextTheme.body1.color,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
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
            child: Hero(
              tag: movie.id,
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
      ),
    );
  }
}

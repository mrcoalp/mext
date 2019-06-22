import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
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

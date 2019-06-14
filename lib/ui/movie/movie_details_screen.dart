import 'package:MEXT/data/models/movie.dart';
import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie _movie;

  MovieDetailsScreen(this._movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: (MediaQuery.of(context).size.height / 3) * 2.5,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(_movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: Hero(
                tag: _movie.id,
                child: Image.network(
                  'http://image.tmdb.org/t/p/w500${_movie.poster_path}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Text(_movie.overview),
            ]),
          )
        ],
      ),
    );
  }
}

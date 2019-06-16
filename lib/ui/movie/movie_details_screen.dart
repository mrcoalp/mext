import 'package:MEXT/constants.dart';
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
            backgroundColor: Colors.white,
            expandedHeight: (MediaQuery.of(context).size.height / 3) * 2.5,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                decoration: BoxDecoration(color: Colors.white70),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(_movie.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      )),
                ),
              ),
              background: Hero(
                tag: _movie.id,
                child: Image.network(
                  '$kTMDBimgPath${_movie.poster_path}',
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

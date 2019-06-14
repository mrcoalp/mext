import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('History'),
            backgroundColor: Theme.of(context).accentColor,
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: _movieHistoryList(_moviesBloc),
          )
        ],
      ),
    );
  }

  SliverChildBuilderDelegate _movieHistoryList(MoviesBloc mb) {
    return SliverChildBuilderDelegate(
      (context, index) {
        Movie m = mb.movieHistory[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: ListTile(
              leading: m.poster_path != null
                  ? Hero(
                      tag: m.id,
                      child: Image.network(
                          'http://image.tmdb.org/t/p/w500${m.poster_path}'),
                    )
                  : Container(),
              title: Text(
                m.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Release Date: ${m.release_date}'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(m))),
            ),
          ),
        );
      },
      childCount: mb.movieHistory.length,
    );
  }
}

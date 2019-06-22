import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieHistoryScreen extends StatefulWidget {
  @override
  _MovieHistoryScreenState createState() => _MovieHistoryScreenState();
}

class _MovieHistoryScreenState extends State<MovieHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);
    final List<Movie> _history = _moviesBloc.movieHistory;
    Size _size = new Size(
        MediaQuery.of(context).size.width, AppBar().preferredSize.height);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('History'),
            floating: true,
            snap: true,
            bottom: PreferredSize(
              preferredSize: _size,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    AppBarButton(
                      text: 'Rating',
                      onPressed: () => _oderByRating(_moviesBloc),
                    ),
                    AppBarButton(
                      text: 'Year',
                      onPressed: () => _oderByYear(_moviesBloc),
                    ),
                    AppBarButton(
                      text: 'Name',
                      onPressed: () => _oderByName(_moviesBloc),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: _movieHistoryList(_history),
          )
        ],
      ),
    );
  }

  SliverChildBuilderDelegate _movieHistoryList(List<Movie> history) {
    return SliverChildBuilderDelegate(
      (context, index) {
        Movie m = history[index];

        return MovieCard(
          movie: m,
        );
      },
      childCount: history.length,
    );
  }

  _oderByYear(MoviesBloc mb) {
    List<Movie> movies = mb.movieHistory;
    movies.sort((a, b) {
      var dateOfa = a.release_date == '' ? '1111-01-01' : a.release_date;
      var dateOfb = b.release_date == '' ? '1111-01-01' : b.release_date;
      return DateTime.parse(dateOfb).compareTo(DateTime.parse(dateOfa));
    });
    mb.movieHistory = movies;
    setState(() {});
  }

  _oderByRating(MoviesBloc mb) {
    List<Movie> movies = mb.movieHistory;
    movies.sort((a, b) => a.vote_average < b.vote_average ? 1 : 0);
    mb.movieHistory = movies;
    setState(() {});
  }

  _oderByName(MoviesBloc mb) {
    List<Movie> movies = mb.movieHistory;
    movies.sort((a, b) => a.title.compareTo(b.title));
    mb.movieHistory = movies;
    setState(() {});
  }
}

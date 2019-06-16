import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
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
    Size _size = new Size(MediaQuery.of(context).size.width, 60);

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('History'),
            backgroundColor: Theme.of(context).accentColor,
            floating: true,
            snap: true,
            bottom: PreferredSize(
              preferredSize: _size,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    Text('Order By'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        AppBarButtons(
                          text: 'Rating',
                          onPressed: () => _oderByRating(_moviesBloc),
                        ),
                        AppBarButtons(
                          text: 'Year',
                          onPressed: () => _oderByYear(_moviesBloc),
                        ),
                        AppBarButtons(
                          text: 'Name',
                          onPressed: () => _oderByName(_moviesBloc),
                        )
                      ],
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

        return Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: ListTile(
              leading: m.poster_path != null
                  ? Hero(
                      tag: m.id,
                      child: Image.network('$kTMDBimgPath${m.poster_path}'),
                    )
                  : Container(),
              title: Text(
                m.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      '${m.release_date.replaceRange(4, m.release_date.length, '')}, ${m.vote_average}'),
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
                  builder: (context) => MovieDetailsScreen(m))),
            ),
          ),
        );
      },
      childCount: history.length,
    );
  }

  _oderByYear(MoviesBloc mb) {
    List<Movie> movies = mb.movieHistory;
    movies.sort((a, b) => DateTime.parse(b.release_date)
        .compareTo(DateTime.parse(a.release_date)));
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

class AppBarButtons extends StatelessWidget {
  final Function onPressed;
  final String text;
  AppBarButtons({@required this.onPressed, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 3) - 16,
      child: RaisedButton(
        elevation: 5,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

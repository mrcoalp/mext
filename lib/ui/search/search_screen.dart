import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/search_repository.dart';
import 'package:MEXT/ui/app.dart';
import 'package:MEXT/ui/buttons.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchRepository = new SearchRepository();
  var _searchCtrl = new TextEditingController();
  String _error = '';
  bool _loading = false;
  var _movies = new List<Movie>();
  int _page = 1;
  int _totalPages = 1;

  Future<void> _searchMovies(String query, int page) async {
    _movies = [];
    setState(() => _loading = true);

    final response = await _searchRepository.search(query, page);
    if (response.hasError)
      _error = response.error;
    else {
      _error = '';
      _movies = response.movies;
      _page = response.page;
      _totalPages = response.totalPages;
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final _search = TextField(
      // autofocus: true,
      controller: _searchCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'search',
      ),
      onSubmitted: (value) {
        _searchMovies(value, 1);
      },
    );

    Size _size = new Size(
        MediaQuery.of(context).size.width, AppBar().preferredSize.height);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            title: _search,
            actions: <Widget>[
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).accentColor),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _searchMovies(_searchCtrl.text, 1);
                      },
                    )
            ],
            bottom: PreferredSize(
              preferredSize: _size,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    AppBarButton(
                      text: 'Rating',
                      onPressed: () => _oderByRating(),
                    ),
                    AppBarButton(
                      text: 'Year',
                      onPressed: () => _oderByYear(),
                    ),
                    AppBarButton(
                      text: 'Name',
                      onPressed: () => _oderByName(),
                    )
                  ],
                ),
              ),
            ),
          ),
          _loading
              ? SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).accentColor)),
                  ),
                )
              : _error == ''
                  ? SliverList(delegate: _results())
                  : SliverToBoxAdapter(
                      child: CustomErrorWidget(
                        error: _error,
                      ),
                    ),
          SliverToBoxAdapter(
            child: _movies.length > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text('prev.'),
                        onPressed: _page > 1
                            ? () => _searchMovies(_searchCtrl.text, _page - 1)
                            : null,
                        textColor: Theme.of(context).accentColor,
                      ),
                      FlatButton(
                        child: Text('next'),
                        onPressed: _page < _totalPages
                            ? () => _searchMovies(_searchCtrl.text, _page + 1)
                            : null,
                        textColor: Theme.of(context).accentColor,
                      )
                    ],
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  _oderByYear() {
    _movies.sort((a, b) {
      var dateOfa = a.release_date == '' ? '1111-01-01' : a.release_date;
      var dateOfb = b.release_date == '' ? '1111-01-01' : b.release_date;
      return DateTime.parse(dateOfb).compareTo(DateTime.parse(dateOfa));
    });
    setState(() {});
  }

  _oderByRating() {
    _movies.sort((a, b) => a.vote_average < b.vote_average ? 1 : 0);
    setState(() {});
  }

  _oderByName() {
    _movies.sort((a, b) => a.title.compareTo(b.title));
    setState(() {});
  }

  SliverChildBuilderDelegate _results() {
    return SliverChildBuilderDelegate(
      (context, index) {
        Movie m = _movies[index];

        return MovieCard(
          movie: m,
        );
      },
      childCount: _movies.length,
    );
  }
}

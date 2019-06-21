import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/repositories/search_repository.dart';
import 'package:MEXT/ui/movie/movie_details_screen.dart';
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

  Future<void> _searchMovies(String query) async {
    setState(() => _loading = true);

    final response = await _searchRepository.search(query, 1);
    if (response.hasError)
      _error = response.error;
    else {
      _movies = response.movies;
      _page = response.page;
      _totalPages = response.totalPages;
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final _search = TextField(
      autofocus: true,
      controller: _searchCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'search',
      ),
      onSubmitted: (value) {
        _searchMovies(value);
      },
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
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
                        _searchMovies(_searchCtrl.text);
                      },
                    )
            ],
          ),
          SliverList(
            delegate: _results(),
          )
        ],
      ),
    );
  }

  SliverChildBuilderDelegate _results() {
    return SliverChildBuilderDelegate(
      (context, index) {
        Movie m = _movies[index];

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
      childCount: _movies.length,
    );
  }
}

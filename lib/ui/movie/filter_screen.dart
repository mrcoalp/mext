import 'dart:convert';

import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/ui/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // final _genresRepository = new GenresRepository();

  var _allGenres = new List<Genre>();
  var _withGenres = new GenresList();
  var _withoutGenres = new GenresList();

  List<Widget> _withGenresWidget = [];
  List<Widget> _withoutGenresWidget = [];

  int _rating = 0;
  int _year = 0;
  int _voteCount = 0;
  bool _excludeWatched = false;

  var _ratingCtrl = new TextEditingController();
  var _yearCtrl = new TextEditingController();
  var _voteCountCtrl = new TextEditingController();

  // bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MoviesBloc _moviesBloc = Provider.of<MoviesBloc>(context);
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);

    print('filter screen');

    _allGenres = [];
    for (var g in lGenres) _allGenres.add(new Genre.fromJson(g));
    _allGenres.sort((a, b) => a.name.compareTo(b.name));
    _withGenres.genres = _moviesBloc.filterWithGenres != ''
        ? _moviesBloc.filterWithGenres?.split(',') ?? []
        : [];
    _withoutGenres.genres = _moviesBloc.filterWithoutGenres != ''
        ? _moviesBloc.filterWithoutGenres?.split(',') ?? []
        : [];
    _rating = _moviesBloc.filterRating;
    if (_ratingCtrl.text == '') _ratingCtrl.text = _rating.toString();
    _year = _moviesBloc.filterYear;
    if (_yearCtrl.text == '') _yearCtrl.text = _year.toString();
    _voteCount = _moviesBloc.filterVoteCount;
    if (_voteCountCtrl.text == '') _voteCountCtrl.text = _voteCount.toString();
    _excludeWatched = _moviesBloc.filterExcludeWatched;
    _handleGenresLists(_moviesBloc);

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Options'),
        elevation: 0,
      ),
      floatingActionButton: RaisedButton(
        child: Text('Update Filters'),
        onPressed: () async {
          var filters = {
            kWithGenres: _moviesBloc.filterWithGenres,
            kWithoutGenres: _moviesBloc.filterWithoutGenres,
            kRating: _moviesBloc.filterRating,
            kYear: _moviesBloc.filterYear,
            kVotes: _moviesBloc.filterVoteCount,
            kExcludeWatched: _moviesBloc.filterExcludeWatched
          };

          String save = jsonEncode(filters);

          SharedPreferences _prefs = await SharedPreferences.getInstance();
          await _prefs.setString(kFilters, save);

          Navigator.of(context).pop();
        },
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'With Genres (scroll horizontally)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ..._withGenresWidget,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Exclude Genres (scroll horizontally)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ..._withoutGenresWidget,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Minimum Rating ($_rating)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Slider(
                  min: 0,
                  max: 8,
                  divisions: 8,
                  label: '$_rating',
                  activeColor: Theme.of(context).accentColor,
                  inactiveColor: Theme.of(context).accentColor.withOpacity(0.2),
                  value: _rating.toDouble(),
                  onChanged: (value) {
                    _moviesBloc.filterRating = value.toInt();
                    _rating = _moviesBloc.filterRating;
                  },
                ),
                // child: TextField(
                //   keyboardType: TextInputType.number,
                //   cursorColor: Colors.teal,
                //   decoration: InputDecoration(
                //     hintText: 'Insert Rating',
                //   ),
                //   onChanged: (value) {
                //     _moviesBloc.filterRating = int.parse(value);
                //     _rating = _moviesBloc.filterRating;
                //   },
                //   controller: _ratingCtrl,
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Minimum Year',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    hintText: 'Insert Year',
                  ),
                  onChanged: (value) {
                    _moviesBloc.filterYear = int.parse(value);
                    _year = _moviesBloc.filterYear;
                  },
                  controller: _yearCtrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'Minimum Votes (for rating)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    hintText: 'Insert Vote Count',
                  ),
                  onChanged: (value) {
                    _moviesBloc.filterVoteCount = int.parse(value);
                    _voteCount = _moviesBloc.filterVoteCount;
                  },
                  controller: _voteCountCtrl,
                ),
              ),
              _authBloc.userId != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SwitchListTile(
                        value: _excludeWatched,
                        onChanged: (value) {
                          _moviesBloc.filterExcludeWatched = value;
                          _excludeWatched = _moviesBloc.filterExcludeWatched;
                          setState(() {});
                        },
                        title: Text(
                          'Exclude Watched',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 70,
              )
            ],
          )),
    );
  }

  void _handleGenresLists(MoviesBloc mb) {
    _withGenresWidget = [];
    _withoutGenresWidget = [];

    for (Genre g in _allGenres) {
      _withGenresWidget.add(
        _withGenres.contains(g.id)
            ? GenreSelectedButton(
                genre: g.name,
                unselectFunc: () {
                  _withGenres.remove(g.id);
                  mb.filterWithGenres = _withGenres.genres.join(',');

                  _handleGenresLists(mb);
                  setState(() {});
                },
              )
            : GenreUnselectedButton(
                genre: g.name,
                selectFunc: () {
                  _withGenres.add(g.id);
                  if (_withoutGenres.contains(g.id))
                    _withoutGenres.remove(g.id);
                  mb.filterWithGenres = _withGenres.genres.join(',');
                  mb.filterWithoutGenres = _withoutGenres.genres.join(',');

                  _handleGenresLists(mb);
                  setState(() {});
                },
              ),
      );

      _withoutGenresWidget.add(
        _withoutGenres.contains(g.id)
            ? GenreSelectedButton(
                genre: g.name,
                unselectFunc: () {
                  _withoutGenres.remove(g.id);
                  mb.filterWithoutGenres = _withoutGenres.genres.join(',');

                  _handleGenresLists(mb);
                  setState(() {});
                },
              )
            : GenreUnselectedButton(
                genre: g.name,
                selectFunc: () {
                  _withoutGenres.add(g.id);
                  if (_withGenres.contains(g.id)) _withGenres.remove(g.id);
                  mb.filterWithoutGenres = _withoutGenres.genres.join(',');
                  mb.filterWithGenres = _withGenres.genres.join(',');

                  _handleGenresLists(mb);
                  setState(() {});
                },
              ),
      );
    }
  }
}

class GenresList {
  var genres = new List<String>();

  void add(int id) {
    this.genres.add(id.toString());
  }

  void remove(int id) {
    this.genres.removeWhere((item) => item == id.toString());
  }

  bool contains(int id) {
    return this.genres.contains(id.toString());
  }
}

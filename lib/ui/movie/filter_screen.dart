import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // final _genresRepository = new GenresRepository();

  List<Genre> _allGenres = [];
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

    for (var g in kgenres) _allGenres.add(new Genre.fromJson(g));
    _withGenres.genres = _moviesBloc.filterWithGenres != ''
        ? _moviesBloc.filterWithGenres.split(',')
        : [];
    _withoutGenres.genres = _moviesBloc.filterWithoutGenres != ''
        ? _moviesBloc.filterWithoutGenres.split(',')
        : [];
    _rating = _moviesBloc.filterRating;
    if (_ratingCtrl.text == '') _ratingCtrl.text = _rating.toString();
    _year = _moviesBloc.filterYear;
    if (_yearCtrl.text == '') _yearCtrl.text = _year.toString();
    _voteCount = _moviesBloc.filterVoteCount;
    if (_voteCountCtrl.text == '') _voteCountCtrl.text = _voteCount.toString();
    _excludeWatched = _moviesBloc.filterExcludeWatched;
    _handleGenresLists(_moviesBloc);

    // if (_moviesBloc.allGenres == null)
    //   _getGenres(_moviesBloc);
    // else {
    //   _allGenres = _moviesBloc.allGenres;
    //   _withGenres.genres = _moviesBloc.filterWithGenres != ''
    //       ? _moviesBloc.filterWithGenres.split(',')
    //       : [];
    //   _withoutGenres.genres = _moviesBloc.filterWithoutGenres != ''
    //       ? _moviesBloc.filterWithoutGenres.split(',')
    //       : [];
    //   _rating = _moviesBloc.filterRating;
    //   if (_ratingCtrl.text == '') _ratingCtrl.text = _rating.toString();
    //   _year = _moviesBloc.filterYear;
    //   if (_yearCtrl.text == '') _yearCtrl.text = _year.toString();
    //   _voteCount = _moviesBloc.filterVoteCount;
    //   if (_voteCountCtrl.text == '')
    //     _voteCountCtrl.text = _voteCount.toString();
    //   _excludeWatched = _moviesBloc.filterExcludeWatched;
    //   _handleGenresLists(_moviesBloc);
    // }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Filter Options'),
        elevation: 0,
      ),
      floatingActionButton: RaisedButton(
        color: Theme.of(context).accentColor,
        textColor: Theme.of(context).primaryColor,
        child: Text('Update Filters'),
        onPressed: () => Navigator.of(context).pop(),
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
              // _loading
              //     ? Center(
              //         child: CircularProgressIndicator(
              //           valueColor: AlwaysStoppedAnimation(
              //               Theme.of(context).primaryColor),
              //         ),
              //       ):
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
                  'Without Genres (scroll horizontally)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // _loading
              //     ? Center(
              //         child: CircularProgressIndicator(
              //           valueColor: AlwaysStoppedAnimation(
              //               Theme.of(context).primaryColor),
              //         ),
              //       ):
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
                  'Minimum Rating (0-10)',
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
                    hintText: 'Insert Rating',
                  ),
                  onChanged: (value) {
                    _moviesBloc.filterRating = int.parse(value);
                    _rating = _moviesBloc.filterRating;
                  },
                  controller: _ratingCtrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
              Padding(
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
              ),
              SizedBox(
                height: 70,
              )
            ],
          )),
    );
  }

  // Future<void> _getGenres(MoviesBloc mb) async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   _allGenres = await _genresRepository.loadFromTMDB();
  //   mb.allGenres = _allGenres;

  //   _handleGenresLists(mb);

  //   setState(() {
  //     _loading = false;
  //   });
  // }

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
                  mb.filterWithGenres = _withGenres.genres.join(',');

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
                  mb.filterWithoutGenres = _withoutGenres.genres.join(',');

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

class GenreUnselectedButton extends StatelessWidget {
  final String genre;
  final Function selectFunc;

  GenreUnselectedButton({@required this.genre, @required this.selectFunc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text(genre),
        onPressed: selectFunc,
      ),
    );
  }
}

class GenreSelectedButton extends StatelessWidget {
  final String genre;
  final Function unselectFunc;

  GenreSelectedButton({@required this.genre, @required this.unselectFunc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        textColor: Theme.of(context).primaryColor,
        child: Text(genre),
        onPressed: unselectFunc,
      ),
    );
  }
}

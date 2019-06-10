import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomMovieScreen extends StatefulWidget {
  @override
  _RandomMovieScreenState createState() => _RandomMovieScreenState();
}

class _RandomMovieScreenState extends State<RandomMovieScreen> {
  var _movie;

  @override
  void initState() {
    super.initState();
    this.getRandomMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("MEXT"),
            centerTitle: true,
          ),
        ],
      ),
    );
  }

  Future<void> getRandomMovie() async {
    var response = await http.get("http://localhost:53960/api/randommovie");
    this._movie = response.body;
    print(this._movie);
  }
}

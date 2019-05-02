import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Movie m = new Movie();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('home'),
          centerTitle: true,
        ),
        SliverFillRemaining(
          child: Center(
            child: RaisedButton(
              child: Text('as'),
              onPressed: () {
                print(m.getRandomMovieId());
              },
            ),
          ),
        )
      ],
    );
  }
}

class Movie {
  String _pad(int number, int length) {
    String str = '$number';

    while (str.length < length) {
      str = '0' + str;
    }

    return str;
  }

  String getRandomMovieId() {
    math.Random r = new math.Random();
    double temp = (r.nextDouble() * 2155529) + 1;
    String id = 'tt${_pad(temp.floor(), 7)}';

    return id;
  }
}

import 'package:flutter/material.dart';
import 'package:MEXT/ui/movie_tabs.dart';

void main() => runApp(MEXT());

class MEXT extends StatefulWidget {
  @override
  _MEXTState createState() => _MEXTState();
}

class _MEXTState extends State<MEXT> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.teal,
      ),
      home: MovieTabs(),
    );
  }
}

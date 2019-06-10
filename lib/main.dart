import 'package:flutter/material.dart';
import 'package:next_movie/ui/tabs.dart';

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
        primarySwatch: Colors.white,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MEXTTabs(),
    );
  }
}

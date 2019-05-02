import 'package:flutter/material.dart';
import 'package:next_movie/ui/home/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Navigation(),
    );
  }
}

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        bottomNavigationBar: Container(
          color: Theme.of(context).accentColor,
          child: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(
                  FontAwesomeIcons.random,
                  size: 20,
                ),
              ),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.save)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            Icon(Icons.search),
            Icon(Icons.save),
          ],
        ),
      ),
    );
  }
}

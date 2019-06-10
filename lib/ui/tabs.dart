import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MEXT/ui/random_movie.dart';

class MEXTTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(
                FontAwesomeIcons.random,
                size: 16,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.user,
                size: 16,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.cog,
                size: 16,
              ),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            RandomMovieScreen(),
            Icon(FontAwesomeIcons.user),
            Icon(FontAwesomeIcons.cog),
          ],
        ),
      ),
    );
  }
}

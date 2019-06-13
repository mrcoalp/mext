import 'package:MEXT/ui/movie_tabs.dart';
import 'package:MEXT/ui/tv_tabs.dart';
import 'package:flutter/material.dart';

class DrawerMEXT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('Movies'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MovieTabs()));
            },
          ),
          ListTile(
            title: Text('TV Shows'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TVTabs()));
            },
          ),
        ],
      ),
    );
  }
}

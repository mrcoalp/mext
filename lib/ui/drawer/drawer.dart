import 'package:MEXT/ui/auth/login_register_screen.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:MEXT/ui/tv_tabs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.user,
                color: Theme.of(context).accentColor,
                size: 16,
              ),
            ),
            title: Text('Login / Register'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginRegisterScreen()));
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.film,
                color: Theme.of(context).accentColor,
                size: 16,
              ),
            ),
            title: Text('Movies'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MovieTabs()));
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.tv,
                color: Theme.of(context).accentColor,
                size: 16,
              ),
            ),
            title: Text('TV Shows'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TVTabs()));
            },
          ),
        ],
      ),
    );
  }
}

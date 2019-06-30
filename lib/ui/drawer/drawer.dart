import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/ui/about/about.dart';
import 'package:MEXT/ui/auth/login_register_screen.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:MEXT/ui/profile/profile.dart';
import 'package:MEXT/ui/tv_tabs.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerMEXT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _auth = Provider.of<AuthBloc>(context);
    final MoviesBloc _movies = Provider.of<MoviesBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('MEXT'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // SafeArea(
          //   child: DrawerHeader(
          //     padding: const EdgeInsets.all(30),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assets/img/mext_logo_NB.png'),
          //           fit: BoxFit.contain,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.user,
                color: Theme.of(context).accentColor,
                size: 16,
              ),
            ),
            title: Text(_auth.userId == null ? 'Login / Register' : 'Profile'),
            onTap: () {
              // Navigator.pop(context);

              if (_auth.userId == null)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginRegisterScreen()));
              else
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
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
              // Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MovieTabs()));
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
            title: Text('TV Shows (coming soon...)'),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => TVTabs()));
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.info,
                color: Theme.of(context).accentColor,
                size: 16,
              ),
            ),
            title: Text('About'),
            onTap: () {
              // Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
          _auth.userId != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text('Logout'),
                      onPressed: () async {
                        await _auth.logout();
                        _movies.clearUserLists();

                        Navigator.of(context).pop();

                        Flushbar(
                          message: 'Logged out',
                          duration: Duration(seconds: 2),
                        )..show(context);
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

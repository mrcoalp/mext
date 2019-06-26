import 'package:MEXT/ui/drawer/drawer.dart';
import 'package:MEXT/ui/search/search_screen.dart';
import 'package:MEXT/ui/userlists/user_favourites_screen.dart';
import 'package:MEXT/ui/userlists/user_lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MEXT/ui/movie/random_movie_screen.dart';

class MovieTabs extends StatelessWidget {
  // Future<bool> _exitApp(BuildContext context) {
  //   return showDialog(
  //         context: context,
  //         builder: (bc) {
  //           return AlertDialog(
  //             title: Text('Exit?'),
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () => Navigator.of(context).pop(false),
  //                   child: Text(
  //                     'NO',
  //                   )),
  //               FlatButton(
  //                 onPressed: () => Navigator.of(context).pop(true),
  //                 child: Text('YES'),
  //               ),
  //             ],
  //           );
  //         },
  //       ) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Movies'),
          centerTitle: true,
        ),
        drawer: DrawerMEXT(),
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
                FontAwesomeIcons.search,
                size: 16,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.film,
                size: 16,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 16,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            RandomMovieScreen(),
            SearchScreen(),
            UserListsScreen(),
            FavouriteMoviesScreen(),
          ],
        ),
      ),
    );
  }
}

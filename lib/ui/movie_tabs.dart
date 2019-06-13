import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/ui/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MEXT/ui/movie/random_movie.dart';
import 'package:provider/provider.dart';

class MovieTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MoviesBloc>(
      builder: (_) => MoviesBloc(),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
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
              Tab(
                icon: Icon(
                  FontAwesomeIcons.user,
                  size: 16,
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              RandomMovieScreen(),
              Icon(FontAwesomeIcons.film),
              Icon(FontAwesomeIcons.heart),
              Icon(FontAwesomeIcons.user),
            ],
          ),
        ),
      ),
    );
  }
}

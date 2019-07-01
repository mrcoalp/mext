import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _auth = Provider.of<AuthBloc>(context);
    final MoviesBloc _movies = Provider.of<MoviesBloc>(context);

    print('splash screen');

    _auth.init().then((_) {
      print('auth bloc initialized');
      _movies.init(_auth.userId).then((_) {
        print('movies bloc initialized');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MovieTabs()),
            (Route<dynamic> route) => false);
      });
    });

    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: Image.asset('assets/img/mext_logo_NB.png'),
            ),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }
}

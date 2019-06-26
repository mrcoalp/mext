import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _auth = Provider.of<AuthBloc>(context);

    _auth.init().then((_) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MovieTabs()),
              (Route<dynamic> route) => false)
        });

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Image.asset('assets/img/mext_logo_NB.png'),
      ),
    );
  }
}

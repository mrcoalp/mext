import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:provider/provider.dart';

void main() => runApp(MEXT());

class MEXT extends StatefulWidget {
  @override
  _MEXTState createState() => _MEXTState();
}

class _MEXTState extends State<MEXT> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesBloc>.value(
          value: MoviesBloc(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.teal,
        ),
        home: MovieTabs(),
      ),
    );
  }
}

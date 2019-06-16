import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:MEXT/ui/movie_tabs.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MEXT());

class MEXT extends StatefulWidget {
  @override
  _MEXTState createState() => _MEXTState();
}

class _MEXTState extends State<MEXT> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesBloc>.value(
          value: MoviesBloc(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.teal,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.teal,
        ),
        home: MovieTabs(),
      ),
    );
  }
}

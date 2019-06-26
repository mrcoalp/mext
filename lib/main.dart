import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/ui/splash.dart';
import 'package:flutter/material.dart';
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
        ),
        ChangeNotifierProvider<AuthBloc>.value(
          value: AuthBloc(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 0,
            color: Colors.white,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.teal,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.teal,
          scaffoldBackgroundColor: Colors.black,
          buttonColor: Colors.black,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.black,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/blocs/movies_bloc.dart';
import 'package:MEXT/blocs/settings_bloc.dart';
import 'package:MEXT/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:MEXT/blocs/discover_bloc.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesBloc>.value(
          value: MoviesBloc(),
        ),
        ChangeNotifierProvider<AuthBloc>.value(
          value: AuthBloc(),
        ),
        ChangeNotifierProvider<DiscoverBloc>.value(
          value: DiscoverBloc(),
        ),
        ChangeNotifierProvider<SettingsBloc>.value(
          value: SettingsBloc(),
        ),
      ],
      child: MEXT(),
    ));

class MEXT extends StatefulWidget {
  @override
  _MEXTState createState() => _MEXTState();
}

class _MEXTState extends State<MEXT> {
  @override
  Widget build(BuildContext context) {
    final SettingsBloc _themeBloc = Provider.of<SettingsBloc>(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0.5)));
    return MaterialApp(
      theme: _themeBloc.theme,
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primaryColor: Colors.grey[800],
      //   accentColor: Colors.teal,
      //   scaffoldBackgroundColor: Colors.grey[800],
      //   buttonColor: Colors.grey[800],
      //   appBarTheme: AppBarTheme(
      //     brightness: Brightness.dark,
      //     color: Colors.grey[800],
      //   ),
      //   cardTheme: CardTheme(
      //     elevation: 0,
      //     color: Colors.grey[800],
      //   ),
      //   buttonTheme: ButtonThemeData(
      //     buttonColor: Colors.teal,
      //     textTheme: ButtonTextTheme.primary,
      //   ),
      // ),
      home: SplashScreen(),
    );
  }
}

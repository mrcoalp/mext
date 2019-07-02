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
    final SettingsBloc _settingsBloc = Provider.of<SettingsBloc>(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      future: _settingsBloc.init(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data)
          return MaterialApp(
            theme: _settingsBloc.theme,
            home: SplashScreen(),
          );
        return Container();
      },
    );
  }
}

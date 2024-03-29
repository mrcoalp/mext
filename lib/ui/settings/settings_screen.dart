import 'package:MEXT/blocs/settings_bloc.dart';
import 'package:MEXT/ui/buttons.dart';
import 'package:flutter/material.dart';
import 'package:MEXT/constants.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<ThemeMEXT> _selectTheme(BuildContext context) async {
    return await showDialog<ThemeMEXT>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Theme '),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ThemeMEXT.Light);
                  },
                  child: const Text('Light'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ThemeMEXT.Dark);
                  },
                  child: const Text('Dark'),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc _settingsBloc = Provider.of<SettingsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Appearance',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .textTheme
                        .body1
                        .color
                        .withOpacity(0.5)),
              ),
              SizedBox(height: 5),
              SettingsButton(
                text: 'Select theme',
                onPressed: () async {
                  _settingsBloc.setTheme(await _selectTheme(context));
                },
              ),
              SizedBox(height: 15),
              Text(
                'General',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .textTheme
                        .body1
                        .color
                        .withOpacity(0.5)),
              ),
              SizedBox(height: 5),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('Load previous filters'),
                value: _settingsBloc.loadFilters,
                onChanged: (value) => _settingsBloc.loadFilters = value,
              ),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('Load movie on startup'),
                subtitle: Text('Disable for faster app startup'),
                value: _settingsBloc.loadMovieOnStart,
                onChanged: (value) => _settingsBloc.loadMovieOnStart = value,
              ),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('Load user lists on startup'),
                subtitle: Text(
                    'Disable for faster app startup\n(requires post refresh on user lists screen)'),
                isThreeLine: true,
                value: _settingsBloc.loadUserListsOnStart,
                onChanged: (value) =>
                    _settingsBloc.loadUserListsOnStart = value,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  AppBarButton({@required this.onPressed, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 3) - 16,
      child: FlatButton(
        onPressed: onPressed,
        child: Text(text),
        textColor: Theme.of(context).accentColor,
      ),
    );
  }
}

class GenreUnselectedButton extends StatelessWidget {
  final String genre;
  final Function selectFunc;

  GenreUnselectedButton({@required this.genre, @required this.selectFunc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        elevation: 5,
        color: Theme.of(context).primaryColor,
        textColor: Theme.of(context).accentColor,
        child: Text(genre),
        onPressed: selectFunc,
      ),
    );
  }
}

class GenreSelectedButton extends StatelessWidget {
  final String genre;
  final Function unselectFunc;

  GenreSelectedButton({@required this.genre, @required this.unselectFunc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text(genre),
        onPressed: unselectFunc,
      ),
    );
  }
}

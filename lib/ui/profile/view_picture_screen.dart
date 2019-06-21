import 'package:MEXT/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:MEXT/.env.dart';

class ViewPictureScreen extends StatelessWidget {
  final User user;

  ViewPictureScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Hero(
              tag: user.id,
              child: Image.network('${Config.API_URL}/${user.profilePic}'),
            ),
          ),
          SafeArea(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                color: Theme.of(context).primaryTextTheme.body1.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

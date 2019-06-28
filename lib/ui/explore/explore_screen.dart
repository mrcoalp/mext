import 'package:MEXT/ui/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.cog),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => DrawerMEXT())),
            ),
          )
        ],
      ),
    );
  }
}

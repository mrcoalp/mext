import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MEXTTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MEXT"),
      ),
      bottomNavigationBar: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(FontAwesomeIcons.random),
          )
        ],
      ),
      body: TabBarView(
        children: <Widget>[
          Icon(FontAwesomeIcons.random),
        ],
      ),
    );
  }
}

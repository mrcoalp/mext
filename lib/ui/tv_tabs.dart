import 'package:MEXT/ui/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TVTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('TV Shows'),
          centerTitle: true,
        ),
        drawer: DrawerMEXT(),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(
                FontAwesomeIcons.random,
                size: 16,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.user,
                size: 16,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.cog,
                size: 16,
              ),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: Text('Coming soon...')),
            Center(child: Text('Coming soon...')),
            Center(child: Text('Coming soon...')),
          ],
        ),
      ),
    );
  }
}

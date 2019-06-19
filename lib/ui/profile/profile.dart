import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _auth = Provider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(),
    );
  }
}

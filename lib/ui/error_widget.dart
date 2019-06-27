import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  const CustomErrorWidget({@required this.error});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Error!',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

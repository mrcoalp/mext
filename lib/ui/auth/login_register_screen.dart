import 'package:flutter/material.dart';

enum Screen { LOGIN, REGISTER }

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  Screen _screen = Screen.LOGIN;

  void _changeScreen() {
    this._screen = _screen == Screen.LOGIN ? Screen.REGISTER : Screen.LOGIN;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _screen == Screen.LOGIN ? Text('Login') : Text('Register'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          height: MediaQuery.of(context).size.width / 1.3,
          child: Card(
            elevation: 10,
            child: _screen == Screen.LOGIN
                ? Login(_changeScreen)
                : Register(_changeScreen),
          ),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  final Function onPressed;

  Login(this.onPressed);

  var _userCtrl = new TextEditingController();
  var _passwordCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextField(
            controller: _userCtrl,
            keyboardType: TextInputType.text,
            cursorColor: Colors.teal,
            decoration: InputDecoration(
              hintText: 'username or email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextField(
            controller: _userCtrl,
            keyboardType: TextInputType.text,
            cursorColor: Colors.teal,
            decoration: InputDecoration(
              hintText: 'password',
            ),
            obscureText: true,
          ),
        ),
        RaisedButton(
          child: Text('data'),
          onPressed: onPressed,
        )
      ],
    );
  }
}

class Register extends StatelessWidget {
  final Function onPressed;

  Register(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('data'),
        RaisedButton(
          child: Text('data'),
          onPressed: onPressed,
        )
      ],
    );
  }
}

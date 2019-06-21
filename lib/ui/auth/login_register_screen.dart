import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

enum Screen { LOGIN, REGISTER }

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  Screen _screen = Screen.LOGIN;
  bool _loading = false;
  String _msg;

  void _changeScreen() {
    this._screen = _screen == Screen.LOGIN ? Screen.REGISTER : Screen.LOGIN;
    _msg = null;
    setState(() {});
  }

  Future<void> _login(String user, String password, AuthBloc ab) async {
    setState(() => _loading = true);

    final auth = new AuthRepository();
    var response = await auth.login(user, password);

    if (response.hasError) {
      FocusScope.of(context).requestFocus(new FocusNode());
      var error = response.error.split(':');
      _msg = error.last.toUpperCase();
    } else {
      ab.userId = response.userId;
      ab.token = response.token;
      ab.refreshToken = response.refreshToken;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', ab.userId);
      await prefs.setString('token', ab.token);
      await prefs.setString('refreshToken', ab.refreshToken);

      Navigator.of(context).pop();

      Flushbar(
        message: 'Logged in',
        duration: Duration(seconds: 2),
      )..show(context);
    }

    setState(() => _loading = false);
  }

  Future<void> _register(
      String name, String username, String email, String password) async {
    setState(() => _loading = true);

    final auth = new AuthRepository();
    var response = await auth.register(name, username, email, password);

    if (response.hasError) {
      FocusScope.of(context).requestFocus(new FocusNode());
      var error = response.error.split(':');
      _msg = error.last.toUpperCase();
    } else {
      _screen = Screen.LOGIN;
      _msg =
          '${response.message.toUpperCase()}\n${response.user.username} proceed to login';
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: _screen == Screen.LOGIN ? Text('Login') : Text('Register'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          _loading
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              : Container(),
        ],
      ),
      body: Stack(
        children: <Widget>[
          BackGround(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _msg != null
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          '$_msg',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Card(
                elevation: 10,
                child: _screen == Screen.LOGIN
                    ? Login(_changeScreen, _login)
                    : Register(_changeScreen, _register),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  final Function onPressed;
  final Function login;

  Login(this.onPressed, this.login);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _userCtrl = new TextEditingController();
  var _passwordCtrl = new TextEditingController();
  String _errorLogin = '';

  @override
  Widget build(BuildContext context) {
    final AuthBloc _ab = Provider.of<AuthBloc>(context);

    final _username = TextField(
      controller: _userCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'username',
      ),
    );

    final _password = TextField(
      controller: _passwordCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'password',
      ),
      obscureText: true,
    );

    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _username,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _password,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$_errorLogin',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('Login'),
            onPressed: () {
              if (_userCtrl.text.isNotEmpty && _passwordCtrl.text.isNotEmpty)
                widget.login(_userCtrl.text, _passwordCtrl.text, _ab);
              else
                setState(() => _errorLogin = '*all fields mandatory');
            },
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Don\'t have an account?',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: widget.onPressed,
            child: Text(
              'Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Register extends StatefulWidget {
  final Function onPressed, register;

  Register(this.onPressed, this.register);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _nameCtrl = new TextEditingController();
  var _usernameCtrl = new TextEditingController();
  var _emailCtrl = new TextEditingController();
  var _passwordCtrl = new TextEditingController();
  var _passwordConfirmCtrl = new TextEditingController();
  String _errorRegister = '';

  @override
  Widget build(BuildContext context) {
    final _name = TextField(
      controller: _nameCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'name (optional)',
      ),
    );

    final _username = TextField(
      controller: _usernameCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'username',
      ),
    );

    final _email = TextField(
      controller: _emailCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'email',
      ),
    );

    final _password = TextField(
      controller: _passwordCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'password',
      ),
      obscureText: true,
    );

    final _passwordConfirm = TextField(
      controller: _passwordConfirmCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'confirm password',
      ),
      obscureText: true,
    );

    bool _isEmail(String em) {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = new RegExp(p);

      return regExp.hasMatch(em);
    }

    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _name,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _username,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _email,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _password,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _passwordConfirm,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$_errorRegister',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('Register'),
            onPressed: () {
              if (!_isEmail(_emailCtrl.text))
                setState(() => _errorRegister = '*invalid email');
              else if (_passwordCtrl.text != _passwordConfirmCtrl.text)
                setState(() => _errorRegister = '*passwords do not match');
              else if (_usernameCtrl.text.isNotEmpty &&
                  _emailCtrl.text.isNotEmpty &&
                  _passwordCtrl.text.isNotEmpty)
                widget.register(_nameCtrl.text, _usernameCtrl.text,
                    _emailCtrl.text, _passwordCtrl.text);
              else
                setState(() =>
                    _errorRegister = '*username, email and password mandatory');
            },
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Already have an account?',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: widget.onPressed,
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 300.0,
      ),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 0.75 + 200);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70 + 100,
        size.width * 0.17, size.height * 0.90 + 100);
    path.quadraticBezierTo(size.width * 0.20, size.height + 100,
        size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.40,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    paint.color = Colors.teal.withOpacity(0.5);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.50 + 200);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.80 + 100,
        size.width * 0.15, size.height * 0.60 + 100);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45 + 100,
        size.width * 0.27, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.45,
        size.width * 0.75, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.93, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = Colors.teal.withOpacity(0.8);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.75 + 200);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.55 + 100,
        size.width * 0.22, size.height * 0.70 + 100);
    path.quadraticBezierTo(size.width * 0.30, size.height * 0.90 + 100,
        size.width * 0.40, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.50,
        size.width * 0.65, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = Colors.teal;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

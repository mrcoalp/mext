import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Screen { LOGIN, REGISTER }

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  Screen _screen = Screen.LOGIN;
  bool _loading = false;

  void _changeScreen() {
    this._screen = _screen == Screen.LOGIN ? Screen.REGISTER : Screen.LOGIN;
    setState(() {});
  }

  Future<void> _login(String user, String password, AuthBloc ab) async {
    setState(() => _loading = true);

    final auth = new AuthRepository();
    var response = await auth.login(user, password);

    if (response.hasError) {
    } else {
      ab.userId = response.userId;
      ab.token = response.token;
      ab.refreshToken = response.refreshToken;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', ab.userId);
      await prefs.setString('token', ab.token);
      await prefs.setString('refreshToken', ab.refreshToken);

      Navigator.of(context).pop();
    }

    setState(() => _loading = false);
  }

  void _register(String name, String username, String email, String password) {}

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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.width / 1.3,
              child: Card(
                elevation: 10,
                child: _screen == Screen.LOGIN
                    ? Login(_changeScreen, _login)
                    : Register(_changeScreen),
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

    final _email = TextField(
      controller: _userCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: 'username or email',
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: _email,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: _password,
        ),
        Text(
          '$_errorLogin',
          style: TextStyle(
            color: Colors.red,
          ),
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
          height: 5,
        ),
        Text('Don\'t have an account?'),
        InkWell(
          onTap: widget.onPressed,
          child: Text(
            'Register',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
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

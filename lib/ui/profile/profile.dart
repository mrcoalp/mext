import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:MEXT/data/repositories/user_repository.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/profile/view_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MEXT/.env.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = false;
  final _userRepository = new UserRepository();
  User _user;
  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getUserDetails(int id, String token, AuthBloc a) async {
    setState(() => _loading = true);

    var response = await _userRepository.getUserDetails(id, token);
    if (response.hasError)
      _error = response.error;
    else {
      _error = '';
      _user = response.user;
      await a.initOrClear();
      a.user = response.user;
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc _auth = Provider.of<AuthBloc>(context);

    if (_auth.user == null && _error == '')
      this._getUserDetails(_auth.userId, _auth.token, _auth);
    else
      _user = _auth.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            title: Text(_user?.username ?? ''),
            actions: <Widget>[
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).accentColor),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () =>
                          _getUserDetails(_auth.userId, _auth.token, _auth),
                    ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).accentColor),
                        ),
                      )
                    : _error != ''
                        ? CustomErrorWidget(
                            error: _error,
                          )
                        : Column(
                            children: <Widget>[
                              ProfilePicture(_user),
                            ],
                          ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final User user;

  ProfilePicture(this.user);

  _showModal(BuildContext ctx) {
    showModalBottomSheet<void>(
        context: ctx,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('View Picture'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewPictureScreen(user))),
              ),
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('Select New Picture'),
                onTap: () => null,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: GestureDetector(
          onTap: () => _showModal(context),
          child: Material(
            elevation: 5,
            color: Colors.transparent,
            child: Container(
              child: Hero(
                tag: user.id,
                child: Image.network('${Config.API_URL}/${user.profilePic}'),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).accentColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

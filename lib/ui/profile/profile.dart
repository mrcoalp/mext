import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/profile/view_picture_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MEXT/.env.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _auth = Provider.of<AuthBloc>(context);

    User _user = _auth.user;
    bool _loading = _auth.loading;
    String _error = _auth.error;

    if (_user == null && _auth.userId != null)
      _auth.getUserDetails(_auth.userId);

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
                      onPressed: () => _auth.getUserDetails(_auth.userId),
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
                        : _user != null
                            ? Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () =>
                                        _showModal(context, _user, _auth),
                                    child: ProfilePicture(
                                      user: _user,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(_user.name ?? ''),
                                  SizedBox(height: 10),
                                  Text(_user.username ?? ''),
                                  SizedBox(height: 10),
                                  Text(_user.email ?? ''),
                                ],
                              )
                            : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _showModal(BuildContext ctx, User user, AuthBloc auth) {
    showModalBottomSheet<void>(
        context: ctx,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('View picture'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewPictureScreen(user))),
              ),
              ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text('New picture from gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  String res = await auth.uploadFromGallery();

                  if (res != null) {
                    Flushbar(
                      message: res,
                      duration: Duration(seconds: 2),
                    )..show(ctx);

                    auth.getUserDetails(auth.userId);
                  }
                },
              ),
              ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('New picture from camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  String res = await auth.uploadFromCamera();

                  if (res != null) {
                    Flushbar(
                      message: res,
                      duration: Duration(seconds: 2),
                    )..show(ctx);

                    auth.getUserDetails(auth.userId);
                  }
                },
              ),
            ],
          );
        });
  }
}

class ProfilePicture extends StatelessWidget {
  final User user;

  ProfilePicture({@required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 2,
            ),
            image: DecorationImage(
              image: NetworkImage(
                '${Config.API_URL}/${user.profilePic}',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

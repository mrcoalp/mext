import 'dart:convert';
import 'dart:io';

import 'package:MEXT/blocs/auth_bloc.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:MEXT/data/repositories/user_repository.dart';
import 'package:MEXT/ui/error_widget.dart';
import 'package:MEXT/ui/profile/view_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MEXT/.env.dart';
import 'package:image_picker/image_picker.dart';

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
      imageCache.clear();
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
                              ProfilePicture(_user, _auth, _getUserDetails),
                              SizedBox(height: 20),
                              Text(_user.name ?? ''),
                              SizedBox(height: 10),
                              Text(_user.username ?? ''),
                              SizedBox(height: 10),
                              Text(_user.email ?? ''),
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

class ProfilePicture extends StatefulWidget {
  final User user;
  final AuthBloc ab;
  final Function update;

  ProfilePicture(this.user, this.ab, this.update);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _loading = false;

  Future<String> _upload(File image) async {
    setState(() => _loading = true);

    List<int> imageBytes = await image.readAsBytes();
    print(imageBytes);
    String b64image = base64Encode(imageBytes);

    final _userRepository = new UserRepository();

    final res = await _userRepository.updateProfilePicture(
        widget.ab.userId, widget.ab.token, b64image);

    setState(() => _loading = false);

    return res;
  }

  Future<String> _uploadFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    return await _upload(image);
  }

  Future<String> _uploadFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image == null) return null;

    return await _upload(image);
  }

  _showModal(BuildContext ctx) {
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
                    builder: (context) => ViewPictureScreen(widget.user))),
              ),
              ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text('New picture from gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  String res = await _uploadFromGallery();

                  if (res != null) {
                    this
                        .widget
                        .update(widget.ab.userId, widget.ab.token, widget.ab);
                  }
                },
              ),
              ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('New picture from camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  String res = await _uploadFromCamera();

                  if (res != null) {
                    this
                        .widget
                        .update(widget.ab.userId, widget.ab.token, widget.ab);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).accentColor),
              ),
            )
          : GestureDetector(
              onTap: () => _showModal(context),
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
                        '${Config.API_URL}/${widget.user.profilePic}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

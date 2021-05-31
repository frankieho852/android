
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:online_shopping_4521/theme/colors.dart';
import 'package:image_picker/image_picker.dart';

class AvatarClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0.0, 0.0, 120, 120);
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class IconField extends StatefulWidget {
  final File initialIcon; //TODO: check the data type of image got from firebase
  final Function onChange;

  IconField({
    Key key,
    this.initialIcon,
    @required this.onChange,
  }) : super(key: key);

  @override
  _IconFieldState createState() => _IconFieldState();
}

class _IconFieldState extends State<IconField> {
  File _tempIcon;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _tempIcon = File(pickedFile.path);
        widget.onChange(_tempIcon);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    _tempIcon = widget.initialIcon;
    if (_tempIcon != null) widget.onChange(_tempIcon);

    super.initState();
  }

  List<Widget> _buildIcon(BuildContext context) {
    return [
      CircleAvatar(
        radius: 60.0,
        backgroundImage: _tempIcon != null
            ? FileImage(_tempIcon)
            : AssetImage('assets/default_avatar.png'),
        backgroundColor: Colors.white,
        child: ClipOval(
          clipper: AvatarClipper(),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: _getImage,
        child: Container(
          height: 120,
          width: 120,
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(
              'EDIT',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Color(kWhite),
                  ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        children: _buildIcon(context),
      ),
    );
  }
}

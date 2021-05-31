
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:online_shopping_4521/theme/colors.dart';
import 'package:image_picker/image_picker.dart';

class ImageField extends StatefulWidget {
  // final String initialImageUrl;
  final File initialImage;
  final String filename;
  final double height;
  final double width;
  final Function onChange;

  ImageField({
    Key key,
    // this.initialImageUrl,
    this.initialImage,
    this.filename: "image",
    this.height,
    @required this.width,
    @required this.onChange,
  }) : super(key: key);

  @override
  _ImageFieldState createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  File _tempImage;
  // File _storedImage;
  // String _imageUrl;
  // String _tempImageUrl;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _tempImage = File(pickedFile.path);
        widget.onChange(_tempImage);
      } else {
        print('No image selected.');
      }
    });

    // Directory dir = await getApplicationDocumentsDirectory();
    // String path = dir.uri.resolve(widget.filename + ".png").path;
    // File image = await _tempImage.copy(path);

    // setState(() {
    //   if (image != null) {
    //     _storedImage = File(image.path);
    //     _imageUrl = image.path;
    //     print(image.path);
    //   } else {
    //     print('No image selected.');
    //   }
    // });
  }

  _clearImage() {
    setState(() {
      _tempImage = null;
      widget.onChange(_tempImage);
    });
  }

  @override
  void initState() {
    // _imageUrl = widget.initialImageUrl ?? null;
    _tempImage = widget.initialImage;
    // print("temp " + widget.initialImage.toString());
    if (_tempImage != null) widget.onChange(_tempImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        _tempImage != null
            ? Container(
                width: widget.width,
                height: widget.height ?? widget.width,
                decoration: BoxDecoration(
                  color: Color(kBlack),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 3,
                    color: Color(kBlack),
                  ),
                  image: DecorationImage(
                    image: FileImage(_tempImage),
                    // FileImage(
                    //     File(_imageUrl),
                    //   )

                    fit: BoxFit.fill,
                  ),
                ),
              )
            : Container(
                width: widget.width,
                height: widget.height ?? widget.width,
                color: Color(kWhite),
              ),
        IconButton(
          icon: Icon(
            _tempImage != null
                ? Icons.remove_circle_outline_rounded
                : Icons.add_a_photo_rounded,
          ),
          onPressed: _tempImage != null ? _clearImage : _getImage,
        ),
      ],
    );
  }
}

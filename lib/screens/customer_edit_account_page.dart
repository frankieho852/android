

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/text_input_field.dart';
import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/icon_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CustomerEditAccountPage extends StatefulWidget {
  final String name;
  final String address;
  final String iconURL;
  final String phone;

  @override
  CustomerEditAccountPage({
    this.name,
    this.address, //TODO: see if really need to record customer address in Firestore
    this.iconURL,
    this.phone,
  }) : super();

  @override
  _CustomerEditAccountPageState createState() =>
      _CustomerEditAccountPageState();
}

class _CustomerEditAccountPageState extends State<CustomerEditAccountPage> {
  String _name;
  File _icon;
  String _address;
  String _phone;
  Map<String, bool> errors;
  final _formKey = GlobalKey<FormState>();
  final validCharacters = RegExp(r'^[a-zA-Z0-9 ]+$');
  final validAddress = RegExp(r'^[a-zA-Z0-9 ,/.]+$');
  String userImage;
  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';

  Future<String> uploadIcon() async {
    var  byteData = await images[0].requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    final User _user = FirebaseAuth.instance.currentUser;
    String name= _user.uid;
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('Usericon/' + _name);
    UploadTask uploadTask = firebaseStorageRef.putData(imageData);
    //UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    //String downloadURL = await FirebaseStorage.instance.ref('productImage/'+name).getDownloadURL(); this is working too
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    print(downloadURL);
    FirebaseFirestore.instance
        .collection('user')
        .doc(name)
        .update({

      'iconURL': downloadURL,
      'fullname': _name,

    })
        .then((value) => print("Uploaded"))
        .catchError((onError) => print("Failed:" + onError));
    FirebaseFirestore.instance
        .collection('customer_users')
        .doc(name)
        .update({

      'address':_address,
      'fullname': _name,
      'phone': _phone,

    });
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          //actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          //selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  String _validateTextInput(bool validator, String fieldName) {
    if (validator) {
      setState(() => errors[fieldName] = true);

      switch (fieldName) {
        case 'name':
          if (this._name.isEmpty)
            return 'Please enter a valid full name';
          else if (this._name.length > 30) {
            return 'Maximun characters: 30';
          } else if (!validCharacters.hasMatch(this._name)) {
            return 'Please enter letters and numbers only';
          }
          break;
        case 'address':
          return 'Please enter a valid address';
          break;
      }
    }
    setState(() => errors[fieldName] = false);
    return null;
  }

  @override
  void initState() {
    errors = {"name": false, "address": false};
    userImage = widget.iconURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Edit Profile',
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'My info',
              style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Color(kLightBrown),
                  ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                 /* Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: IconField(
                        //TODO: pass initial icon from Firebase
                        // initialIcon: File(widget.iconUrl),
                        //Firebase function ends
                        onChange: (value) => _icon = value,
                      ),
                    ),
                  ),*/
                  CachedNetworkImage(
                    imageUrl: userImage,
                    imageBuilder: (context, imageProvider) => Container(
                      //padding: EdgeInsets.all(kDefaultPadding * 0.1),
                      height: size.height * 0.06,
                      width: size.height * 0.06, // ensure sqaure container
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: NetworkImage(userImage),
                          //imageProvider
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        height: size.height * 0.06,
                        width: size.height * 0.06,
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF00A299)))),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextInputField(
                      fieldName: 'Name',
                      onSaved: (input) => _name = input,
                      isRequired: true,
                      keyboardType: TextInputType.name,
                      placeholder: 'Enter Username',
                      initialValue: widget.name,
                      isCustomer: false,
                      validator: (input) => _validateTextInput(
                          input.isEmpty ||
                              input.length > 30 ||
                              !validCharacters.hasMatch(input),
                          "name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextInputField(
                      fieldName: 'Address',
                      onSaved: (input) => _address = input,
                      keyboardType: TextInputType.streetAddress,
                      placeholder: 'Enter Address',
                      initialValue: widget.address,
                      isCustomer: false,
                      validator: (input) => _validateTextInput(
                          !validAddress.hasMatch(this._address), "address"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextInputField(
                      fieldName: 'Phone',
                      onSaved: (input) => _phone = input,
                      keyboardType: TextInputType.phone,
                      placeholder: 'Enter Phone',
                      initialValue: widget.phone,
                      isCustomer: false,
                    ),
                  ),
                  Button(
                    text: 'Choose photo',
                    onPress: () =>
                    {
                      //TODO: clear image
                      loadAssets(),
                    },
                    isCustomer: false,
                  ),
                  Button(
                    text: 'Save',
                    onPress: () => {
                      _formKey.currentState.save(),
                      if (_formKey.currentState.validate())
                        {
                          uploadIcon(),
                          //TODO: update data to Firebase
                         /*print("send to db"),
                          //Firebase function ends
                          Navigator.pop(context)*/
                        }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'dart:io';

import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/text_input_field.dart';
import '../widgets/button.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/long_text_input_field.dart';
import '../widgets/checkbox_field.dart';
import '../widgets/icon_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:multi_image_picker/multi_image_picker.dart';


class BusinessEditShopPage extends StatefulWidget {
  final String email;
  final String name;
  final String category;
  final String phone;
  final String sDescription;
  final String lDescription;
  final Map payments;
  final String iconUrl;

  @override
  BusinessEditShopPage({
    Key key,
    this.email,
    this.name,
    this.category,
    this.phone,
    this.sDescription,
    this.lDescription,
    this.payments,
    this.iconUrl,
  }) : super(key: key);

  @override
  _BusinessEditShopPageState createState() => _BusinessEditShopPageState();
}

class _BusinessEditShopPageState extends State<BusinessEditShopPage> {
  String _name, _category, _phone, _sDescription, _lDescription, _iconUrl;
  final List paymentOptions = ["PayMe", "Payment 2"];
  Map _payments;
  File _icon;

  Map<String, bool> errors;
  final _formKey = GlobalKey<FormState>();
  final validCharacters = RegExp(r'^[a-zA-Z0-9.,!? \"]+$');
  final validPriceCharacters = RegExp(r'^([1-9][\d]{0,3})(\.\d{1,2})?$');
  final validQuantity = RegExp(r'^([1-9][\d]{0,2})');
  final validPhone = RegExp(r'^([1-9][\d]{8})');
  List<Asset> images = <Asset>[];
  List<String> docname = <String>[];
  List<String> imageUrls = <String>[];

  @override
  void initState() {
    _name = widget.name;
    _category = widget.category;
    _phone = widget.phone;
    _sDescription = widget.sDescription;
    _lDescription = widget.lDescription;
    _payments = widget.payments;
    _iconUrl = widget.iconUrl;

    errors = {
      "name": false,
      "category": false,
      "phone": false,
      "sDescription": false,
      "lDescription": false,
      "payments": false,
    };
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          //actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: true,
          //selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  void checkIfDocExists() async {
    final QuerySnapshot result =
    await FirebaseFirestore.instance.collection('Shop Image').get();
    final List<DocumentSnapshot> documents = result.docs;

    for (int i = 0; i < documents.length; i++) {
      docname.add(documents[i].id);
    }
  }

  Future<dynamic> postImage(Asset imageFile, String shopname,
      String shopcategory) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage
        .instance.ref('shopImage').child(shopcategory).child(shopname);
    firebase_storage.UploadTask uploadTask = reference.putData(
        (await imageFile.getByteData()).buffer.asUint8List());
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    //print(url);
    return imageUrl;
  }

  void uploadImages(String shopname, String shopcategory,
      String phonenumber, String shortdescription, String longdescription, Map choosemethod) {
    int count = 0;
    var _methodlist = choosemethod.values.toList();
    var user = FirebaseAuth.instance.currentUser;

    for (int i = 0; i < docname.length; i++) {
      if (docname[i] == shopname) {
        // show error
      }
      else {
        for (var imageFile in images) {
          if (images.length == 1) {
            postImage(imageFile, shopname, shopcategory).then((downloadUrl) {
              imageUrls.add(downloadUrl.toString());
              if (imageUrls.length == images.length) {
                FirebaseFirestore.instance.collection('Shop detail')
                    .doc(user.uid)
                    .update({
                  'name': shopname,
                  'category': shopcategory,
                  'phonenumber': phonenumber,
                  'description': shortdescription + longdescription,
                  'payment': _methodlist,
                });
                FirebaseFirestore.instance.collection('Shop Image').doc(
                    shopname).update(
                    {
                      'urls': imageUrls
                    }).then((_) {
                  setState(() {
                    images = [];
                    imageUrls = [];
                  });
                });
              }
            }).catchError((err) {
              print(err);
            });
          }
          else {
            String multicatgoryname = "";
            if (count == 0) {
              multicatgoryname = shopname;
            }
            else {
              String multilword = count.toString();
              multicatgoryname = shopname + multilword;
            }
            postImage(imageFile, multicatgoryname, shopcategory).then((
                downloadUrl) {
              imageUrls.add(downloadUrl.toString());
              if (imageUrls.length == images.length) {
                FirebaseFirestore.instance.collection('Shop detail')
                    .doc(user.uid)
                    .update({
                  'name': shopname,
                  'category': shopcategory,
                  'phonenumber': phonenumber,
                  'description': shortdescription + longdescription,
                  'payment': _methodlist,
                });
                FirebaseFirestore.instance.collection('Shop Image').doc(
                    shopname).update(
                    {
                      'urls': imageUrls
                    }).then((_) {
                  setState(() {
                    images = [];
                    imageUrls = [];
                  });
                });
              }
            }).catchError((err) {
              print(err);
            });
            count++;
          }

        }
      }
    }
  }

  void _deletephoto() async {
    images = [];
    imageUrls = [];
  }

  String _validateTextInput(bool validator, String fieldName) {
    if (validator) {
      setState(() => errors[fieldName] = true);
      switch (fieldName) {
        case 'name':
          if (this._name.isEmpty)
            return 'Please enter a valid shop name';
          else if (this._name.length > 30) {
            return 'Maximun characters: 30';
          } else if (!validCharacters.hasMatch(this._name)) {
            return 'Please enter letters and numbers only';
          }
          break;
        case 'phone':
          if (this._phone.isEmpty || !validPhone.hasMatch(this._phone))
            return 'Please enter a valid phone number';
          break;
        case 'sDescription':
          if (this._sDescription.isEmpty ||
              !validCharacters.hasMatch(this._sDescription))
            return 'Please enter a valid short description';
          break;
        case 'lDescription':
          if (this._lDescription.isEmpty ||
              !validCharacters.hasMatch(this._lDescription))
            return 'Please enter a valid long description';
          break;
      }
    }
    setState(() => errors[fieldName] = false);
    return null;
  }

  List<Widget> _buildFormInput(BuildContext context) {
    return [
      /*Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: IconField(
            initialIcon: File(_iconUrl),
            onChange: (value) => _icon = value,
          ),
        ),
      ),*/
      Expanded(
        child: buildGridView(),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Shop Name',
          onSaved: (input) => _name = input,
          validator: (input) => _validateTextInput(input.isEmpty, "name"),
          isError: errors["name"],
          isRequired: true,
          keyboardType: TextInputType.name,
          placeholder: 'Enter Shop Name',
          isCustomer: false,
          initialValue: widget.name,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Email',
          isReadOnly: true,
          isRequired: true,
          initialValue: widget.email,
          isCustomer: false,
        ),
      ),

      /*Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownField(
          listItem: ["Category 1", "Category 2", "Sports"],
          fieldName: "Category",
          onPress: (value) => {print("selected " + value)},
          isRequired: true,
          isCustomer: false,
          initialValue: widget.category,
        ),
      ),*/
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Contact number',
          onSaved: (input) => _phone = input,
          validator: (input) => _validateTextInput(input.isEmpty, "phone"),
          isError: errors["phone"],
          isRequired: true,
          keyboardType: TextInputType.phone,
          placeholder: 'Enter Contact Number',
          isCustomer: false,
          initialValue: widget.phone,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: LongTextInputField(
          fieldName: 'Short Description',
          onSaved: (input) => _sDescription = input,
          validator: (input) =>
              _validateTextInput(input.isEmpty, "sDescription"),
          isError: errors["sDescription"],
          isRequired: true,
          keyboardType: TextInputType.multiline,
          placeholder: 'Enter Short Description',
          isCustomer: false,
          maxLength: 50,
          initialValue: widget.sDescription,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: LongTextInputField(
          fieldName: 'Long Description',
          onSaved: (input) => _sDescription = input,
          validator: (input) =>
              _validateTextInput(input.isEmpty, "lDescription"),
          isError: errors["lDescription"],
          isRequired: true,
          keyboardType: TextInputType.multiline,
          placeholder: 'Enter Long Description',
          isCustomer: false,
          maxLength: 200,
          initialValue: widget.lDescription,
        ),
      ),
      Row(
        children: [
          Text(
            "Payment method(s)",
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Color(kDarkBrown),
                ),
          ),
          Text(
            '*',
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Color(kRed),
                ),
          ),
        ],
      ),
      for (var i in paymentOptions)
        CheckboxField(
          fieldOption: i,
          initialIsChecked: _payments.containsKey(i),
          initialInfo: _payments.containsKey(i) ? _payments[i] : null,
          onCheck: (option) => {_payments[i] = null},
          onUncheck: (option) => {_payments.remove(i)},
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Edit Shop Info",
          hasBack: true,
          isCustomer: false,
        ),
        backgroundColor: Color(kDarkRed),
        body: Form(
          key: _formKey,
          child: ListView(
            cacheExtent: 9999,
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                "Shop Info",
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Color(kDarkBrown),
                    ),
              ),
              ..._buildFormInput(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Button(
                        text: 'Choose photo',
                        onPress: () =>
                        {

                          loadAssets(),
                        },
                        isCustomer: false,
                      ),
                    ),
                      Button(
                        text: 'Update',
                        onPress: () => {
                          _formKey.currentState.save(),
                          if (_formKey.currentState.validate())
                            {
                              uploadImages(_name , _category , _phone , _sDescription , _lDescription , _payments),
                              /*ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Processing Data'))),*/
                            },
                          print('validate & update')
                        },
                        isCustomer: false,
                      ),
                    Button(
                      text: 'Reset',
                      onPress: () => {_formKey.currentState.reset(),_deletephoto()
                      },
                      isCustomer: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/text_input_field.dart';
import '../widgets/button.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/long_text_input_field.dart';
import '../widgets/image_field.dart';

class BusinessAddProductPage extends StatefulWidget {
  @override
  BusinessAddProductPage({
    Key key,
  }) : super(key: key);

  @override
  _BusinessAddProductPageState createState() => _BusinessAddProductPageState();
}

class _BusinessAddProductPageState extends State<BusinessAddProductPage> {
  String _name, _category, _description;
  double _price;
  int _totalQuantity;
  String _shopname;
  List<File> _images;
  List _imagesUrl;

  Map<String, bool> errors;
  final _formKey = GlobalKey<FormState>();
  final validCharacters = RegExp(r'^[a-zA-Z0-9.,!? \"]+$');
  final validPriceCharacters = RegExp(r'^([1-9][\d]{0,3})(\.\d{1,2})?$');
  final validQuantity = RegExp(r'^([1-9][\d]{0,2})');
  List<Asset> images = <Asset>[];
  List<String> docname = <String>[];
  List<String> imageUrls = <String>[];


  @override
  void initState() {
    _name = "";
    _category = "";
    _price = 0.0;
    _totalQuantity = 0;
    _description = "";
    _images = [null, null, null, null];
    _shopname = "";

    errors = {
      "name": false,
      "category": false,
      "quantity": false,
      "price": false,
      "description": false,
    };
    super.initState();
    _getName();
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
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
    await FirebaseFirestore.instance.collection('Product Image').get();
    final List<DocumentSnapshot> documents = result.docs;

    for (int i = 0; i < documents.length; i++) {
      docname.add(documents[i].id);
    }
  }

  Future<dynamic> postImage(Asset imageFile, String productname,
      String categoryname) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage
        .instance.ref('productImage').child(categoryname).child(productname);
    firebase_storage.UploadTask uploadTask = reference.putData(
        (await imageFile.getByteData()).buffer.asUint8List());
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    //print(url);
    return imageUrl;
  }

  Future<void> _getName() async {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('Shop')
        .where('owner' , isEqualTo: user.uid)
        .snapshots()
        .listen((detailData) {
      setState(() {
        String getshopname = detailData.docs.first.get('searchKeywords')['shop_name'];
        _shopname = getshopname;
      });
    });
  }


  void uploadImages(String productname, String categoryname,
      double productprice, int productquantity, String productdescription) {
    int count = 0;

        for (var imageFile in images) {
          if (images.length == 1) {
            print('enter the add function to firebase');
            postImage(imageFile, productname, categoryname).then((downloadUrl) {
              imageUrls.add(downloadUrl.toString());
              if (imageUrls.length == images.length) {
                FirebaseFirestore.instance.collection('Product detail')
                    .doc(productname)
                    .set({
                  'shopname': _shopname,
                  'category': categoryname,
                  'price': productprice,
                  'quantity': productquantity,
                  'sold' : 0,
                  'description': productdescription,
                });
                FirebaseFirestore.instance.collection('Product Image').doc(
                    productname).set(
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
              multicatgoryname = productname;
            }
            else {
              String multilword = count.toString();
              multicatgoryname = productname + multilword;
            }
            postImage(imageFile, multicatgoryname, categoryname).then((
                downloadUrl) {
              imageUrls.add(downloadUrl.toString());
              if (imageUrls.length == images.length) {
                FirebaseFirestore.instance.collection('Product detail')
                    .doc(productname)
                    .set({
                  'shopname': _shopname,
                  'category': categoryname,
                  'price': productprice,
                  'quantity': productquantity,
                  'sold' : 0,
                  'description': productdescription,
                });
                FirebaseFirestore.instance.collection('Product Image').doc(
                    productname).set(
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

  Future _saveInfo() async {
    //final List<File> images = _images;

    loadAssets();
//TODO: save to firebase
    /*Directory dir = await getApplicationDocumentsDirectory();
    images.asMap().forEach((index, element) async {
      String path =
          dir.uri.resolve("image_" + (index + 1).toString() + ".png").path;
      File image = await element.copy(path);

      setState(() {
        if (image != null) {
          _imagesUrl.insert(index, image.path);
          print(image.path);
        } else {
          print('No image selected.');
        }
      });
    });*/
  }

  void _deletephoto() async {
    images = [];
    imageUrls = [];
  }


  String _validateTextInput(bool validator, String fieldName) {
    if (validator) {
      setState(() => errors[fieldName] = true);

      switch (fieldName) {
        case 'category':
          if (this._name.isEmpty)
            return 'Please enter a valid product category';
          else if (this._name.length > 30) {
            return 'Maximun characters: 30';
          } else if (!validCharacters.hasMatch(this._category)) {
            return 'Please enter letters and numbers only';
          }
          break;
        case 'name':
          if (this._name.isEmpty)
            return 'Please enter a valid product name';
          else if (this._name.length > 30) {
            return 'Maximun characters: 30';
          } else if (!validCharacters.hasMatch(this._name)) {
            return 'Please enter letters and numbers only';
          }
          break;
        case 'price':
          if (this._price == 0)
            return 'Please enter a valid product name';
          else if (!validPriceCharacters.hasMatch(this._price.toString())) {
            return 'Please enter a valid price, at most 2 d.p.';
          }

          break;
        case 'quantity':
          if (this._totalQuantity == 0)
            return 'Please enter a valid quantity';
          else if (!validQuantity.hasMatch(this._totalQuantity.toString()))
            return 'Please enter a valid quantity with positive number';
          break;
        case 'description':
          if (this._description.isEmpty ||
              !validCharacters.hasMatch(this._description))
            return 'Please enter a valid description';
      }
    }
    setState(() => errors[fieldName] = false);
    return null;
  }

  List<Widget> _buildFormInput(BuildContext context, double screenWidth) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Product Category',
          onSaved: (input) => _category = input,
          validator: (input) =>
              _validateTextInput(
                  input.isEmpty || !validCharacters.hasMatch(input),
                  "category"),
          isError: errors["category"],
          isRequired: true,
          keyboardType: TextInputType.name,
          placeholder: 'Enter Product Category',
          isCustomer: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Product Name',
          onSaved: (input) => _name = input,
          validator: (input) =>
              _validateTextInput(
                  input.isEmpty || !validCharacters.hasMatch(input), "name"),
          isError: errors["name"],
          isRequired: true,
          keyboardType: TextInputType.name,
          placeholder: 'Enter Product Name',
          isCustomer: false,
        ),
      ),
      /*Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownField(
          listItem: ["Category 1", "Category 2", "Kitchen", "Sports"],
          fieldName: "Category",
          onPress: (value) => {print("selected " + value)},
          isRequired: true,
          isCustomer: false,
        ),
      ),*/
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Price',
          onSaved: (input) =>
          input.isEmpty || !validPriceCharacters.hasMatch(input.toString())
              ? _price = 0
              : _price = double.parse(input),
          validator: (input) =>
              _validateTextInput(
                  input.isEmpty ||
                      !validPriceCharacters.hasMatch(this._price.toString()),
                  "price"),
          isError: errors["price"],
          isRequired: true,
          keyboardType: TextInputType.number,
          placeholder: 'Enter Price',
          isCustomer: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextInputField(
          fieldName: 'Total Quantity',
          onSaved: (input) =>
          input.isEmpty || !validQuantity.hasMatch(input.toString())
              ? _totalQuantity = 0
              : _totalQuantity = int.parse(input),
          validator: (input) =>
              _validateTextInput(
                  input.isEmpty || !validQuantity.hasMatch(input.toString()),
                  "quantity"),
          isError: errors["quantity"],
          isRequired: true,
          keyboardType: TextInputType.number,
          placeholder: 'Enter Quantity',
          isCustomer: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: LongTextInputField(
          fieldName: 'Description',
          onSaved: (input) => _description = input,
          validator: (input) =>
              _validateTextInput(
                  input.isEmpty || !validCharacters.hasMatch(input),
                  "description"),
          isError: errors["description"],
          isRequired: true,
          keyboardType: TextInputType.multiline,
          placeholder: 'Enter Description',
          isCustomer: false,
          maxLength: 200,
        ),
      ),
      Row(
        children: [
          Text(
            "Product Image(s)",
            style: Theme
                .of(context)
                .textTheme
                .headline4
                .copyWith(
              color: Color(kDarkBrown),
            ),
          ),
          Text(
            '*',
            style: Theme
                .of(context)
                .textTheme
                .headline4
                .copyWith(
              color: Color(kRed),
            ),
          ),
        ],
      ),
      Expanded(
        child: buildGridView(),
      ),
      /*Row(
        children: [
          ImageField(
            width: screenWidth - 40 - ((screenWidth - 56) / 4),
            onChange: (value) => {_images[0] = value},
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: ImageField(
                  width: (screenWidth - 56) / 4,
                  onChange: (value) => {_images[1] = value},
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 4.0, top: 4.0),
                child: ImageField(
                  width: (screenWidth - 56) / 4,
                  onChange: (value) => {_images[2] = value},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: ImageField(
                  width: (screenWidth - 56) / 4,
                  onChange: (value) => {_images[3] = value},
                ),
              ),
            ],
          )
        ],
      )*/
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Add Product",
          hasBack: true,
          isCustomer: false,
        ),
        backgroundColor: Color(kDarkRed),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                "Product Info",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3
                    .copyWith(
                  color: Color(kDarkBrown),
                ),
              ),
              ..._buildFormInput(context, width),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Button(
                        text: 'Reset',
                        onPress: () =>
                        {
                          //TODO: clear image
                          _formKey.currentState.reset(),
                          _deletephoto()
                        },
                        isCustomer: false,
                      ),
                    ),
                    Button(
                      text: 'Choose photo',
                      onPress: () =>
                      {
                        _saveInfo(),
                      },
                      isCustomer: false,
                    ),
                    Button(
                      text: 'Add',
                      onPress: () =>
                      {
                        _formKey.currentState.save(),
                        if (_formKey.currentState.validate())
                          {
                            print('filfull all requirment'),
                            uploadImages(
                                _name, _category, _price, _totalQuantity,
                                _description),
                            Navigator.pop(context),
                            //TODO: send to Firebase, check how to send image
                            /*print("send to db"),
                            //Firebase function ends
                            Navigator.pop(context)*/
                          },
                        // _saveInfo()
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


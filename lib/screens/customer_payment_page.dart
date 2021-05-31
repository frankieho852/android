

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/accordination.dart';
import 'package:online_shopping_4521/widgets/button.dart';
import 'package:online_shopping_4521/widgets/sorting_filter.dart';
import 'package:online_shopping_4521/widgets/status_tag.dart';
import 'package:online_shopping_4521/widgets/text_input_field.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../widgets/custom_app_bar.dart';

class CustomerPaymentPage extends StatefulWidget {
  final List imagesUrl;
  final String productName;
  final double rating;
  final String category;
  final double totalPrice;
  final String statusTagText;
  final String description;
  final int orderQuantity;
  final int quantityLeft;
  final Map payments;

  @override
  CustomerPaymentPage({
    Key key,
    @required this.productName,
    @required this.imagesUrl,
    @required this.rating,
    @required this.category,
    @required this.totalPrice,
    @required this.statusTagText,
    @required this.description,
    @required this.orderQuantity,
    @required this.quantityLeft,
    @required this.payments,
  }) : super(key: key);

  @override
  _CustomerPaymentPageState createState() => _CustomerPaymentPageState();
}

class _CustomerPaymentPageState extends State<CustomerPaymentPage> {
  String _payment;
  int _currentImageIndex;
  String _paymentRef;
  Map<String, bool> _errors;
  final _formKey = GlobalKey<FormState>();
  List<String> _listOfImages = <String>[];
  int count;

  @override
  void initState() {
    _currentImageIndex = 0;
    count = 0;
    _payment = (widget.payments).keys.toList()[0];
    _paymentRef = "";
    _errors = {"refNumber": false};
    super.initState();
  }

  String _validateTextInput(bool validator) {
    if (validator) {
      setState(() => _errors["refNumber"] = true);
      return 'Please enter a valid number';
    } else {
      setState(() => _errors["refNumber"] = false);
      return null;
    }
  }

  void savetraninfo(String productname, String categoryname,
      double productprice, int productquantity) {

    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('customer_users')
        .doc(user.uid)
        .snapshots()
        .listen((detailData) {
      setState(() {
        count = detailData.get("order");
      });
    });
    FirebaseFirestore.instance.collection('customer_user')
        .doc(user.uid)
        .update({
      'product_history': {
        'orderId': count,
        'is_paid': "false",
        "productname": productname,
        "total_price":productprice,
        'quantity': productquantity,
      }
    });
    count+=1;
    FirebaseFirestore.instance.collection('customer_user')
        .doc(user.uid)
        .update({
      'order': count,
    });
  }

  void savetran(String productname, double totoalprice, String paymentref){
    var user = FirebaseAuth.instance.currentUser;
    String getaddress;
    String getname;
    String getphone;
    FirebaseFirestore.instance
        .collection('customer_users')
        .doc(user.uid)
        .snapshots()
        .listen((detailData) {
      setState(() {
        getaddress = detailData.get("address");
        getname = detailData.get("fullname");
        getphone = detailData.get("phone");

      });
    });
    FirebaseFirestore.instance.collection('transactions')
        .doc(user.uid)
        .update({
      'customer': getname,
      'customer_address': getaddress,
      'customer_phone':getphone,
      'payment_ref': {
        '$_payment': paymentref,
        'product': productname,
        'total_price': totoalprice,
        'transaction_id': user.uid,
      }
    });
  }

    void detelerecord(){
      var user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('customer_users').doc(user.uid).update({'product_history': FieldValue.delete()}).whenComplete((){
        print('Cart Deleted');
      });
    }



  Widget _buildImageDisplay(screenWidth) {
    /*return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          width: screenWidth - 32,
          height: screenWidth - 32,
          decoration: BoxDecoration(
            color: Color(kBlack),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2,
              color: Color(kBlack),
            ),
            image: DecorationImage(
              image: AssetImage(
                widget.imagesUrl[_currentImageIndex],
              ),
              //TODO: use Firebase image in correct form
              // FileImage(
              //   File(widget.imagesUrl[_currentImageIndex]),
              // ),
              //Firebase function ends
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i in [0, 1, 2, 3])
            GestureDetector(
              onTap: () => {
                setState(() {
                  _currentImageIndex = i;
                })
              },
              child: Container(
                width: (screenWidth - 32 - 24) / 4,
                height: (screenWidth - 32 - 24) / 4,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: _currentImageIndex == i ? 3 : 0,
                    color: Color(kBlack),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      widget.imagesUrl[i],
                    ),
                    //TODO: change it to use Firebase image in correct form
                    // FileImage(
                    //   File(widget.imagesUrl[_currentImageIndex]),
                    // ),
                    //Firebase function ends
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
        ],
      )
    ]);*/
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Product Image').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          _listOfImages = [];

                          if(snapshot.data.docs[index].id == widget.productName) {
                            for (int i = 0; i <
                                snapshot.data.docs[index].data()['urls'].length; i++) {
                              _listOfImages.add(snapshot.data
                                  .docs[index].data()['urls'][i]);

                            }
                          }
                          return Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: Carousel(
                                      boxFit: BoxFit.cover,
                                      images: _listOfImages.map((url){
                                        return CachedNetworkImage(
                                          imageUrl: url,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: CircularProgressIndicator(
                                                  value: downloadProgress.progress,
                                                  backgroundColor: Colors.grey[200],
                                                  strokeWidth : 6.0,
                                                  valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        );
                                      }).toList(),
                                      autoplay: false,
                                      indicatorBgPadding: 5.0,
                                      dotPosition: DotPosition.bottomCenter,
                                      animationCurve: Curves.fastOutSlowIn,
                                      animationDuration:
                                      Duration(milliseconds: 10000)),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }))
      ],
    );
  }

  Widget _buildPaymentLink(selectedPayment) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SelectableText(
            widget.payments[selectedPayment],
            style: Theme.of(context).textTheme.headline4.copyWith(
                  decoration: TextDecoration.underline,
                  decorationThickness: 1.5,
                  // color: Color(kLightBrown),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Payment',
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildImageDisplay(width),
            RatingBarIndicator(
              rating: widget.rating,
              itemBuilder: (context, index) =>
                  Icon(Icons.star, color: Color(kYellow)),
              itemCount: 5,
              itemSize: 30,
              unratedColor: Color(0xFFC4C4C4),
              direction: Axis.horizontal,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.category,
                style: Theme.of(context).textTheme.headline3.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.5,
                      color: Color(kLightBrown),
                    ),
              ),
            ),
            Text(
              'Order Quantity: ' + widget.orderQuantity.toString(),
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Color(kLightBrown),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: StatusTag(text: widget.statusTagText),
                ),
                Text(
                  'Total HKD ' +
                      double.parse(widget.totalPrice.toStringAsFixed(2))
                          .toString(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color(kLightBrown),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Accordination(content: widget.description),
            widget.orderQuantity <= widget.quantityLeft
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select payment method: ',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Color(kLightBrown),
                              ),
                        ),
                        SortingFilter(
                          listItem: widget.payments.keys.toList(),
                          onPress: (value) => {
                            setState(() {
                              this._payment = value;
                            }),
                            print('selected ' + value),
                          },
                        ),
                        Text(
                          'Link/Phone (Long tap to copy): ',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Color(kLightBrown),
                              ),
                        ),
                        _buildPaymentLink(_payment),
                        TextInputField(
                            fieldName: 'Invoice Reference number',
                            isRequired: true,
                            isError: _errors["refNumber"],
                            onSaved: (input) => _paymentRef = input,
                            validator: (input) =>
                                _validateTextInput(input.isEmpty)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Button(
                                text: "Process",
                                onPress: () => {
                                  _formKey.currentState.save(),
                                  if (_formKey.currentState.validate())
                                    //TODO: send to Firebase the payment ref & wait for shop to confirm okay, after okay then change the isPaid to true, if not okay remind buyer and keep isPaid in false
                                    savetraninfo(widget.productName, widget.category,widget.totalPrice,widget.orderQuantity),
                                    savetran(widget.productName,widget.totalPrice,_paymentRef),

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'send to db & process, if incorrect then void'),
                                      ),
                                    ),
                                  //Fir0ebase function ends
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        'Insufficient quantity left',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Button(
                          text: "Remove from Cart",
                          onPress: () => {
                            //TODO: remove from Firebase User shopping history
                            detelerecord(),
                            print("send to db & remove")
                            //Firebase function ends
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

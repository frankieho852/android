
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/accordination.dart';
import 'package:online_shopping_4521/widgets/add_review.dart';
import 'package:online_shopping_4521/widgets/comment_tile.dart';

import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/customer_product_card.dart';
import 'customer_product_detail_page.dart';

class CustomerShopDetailPage extends StatefulWidget {
  final String smallimageUrl;
  final String largeimageUrl;
  final String shopName;
  final double rating;
  final String category;
  final String longDescription;
  final String phone;
  final String email;
  final List payments;

  @override
  CustomerShopDetailPage({
    Key key,
    this.smallimageUrl: 'assets/default_product_image.png',
    this.largeimageUrl: 'assets/default_product_image250.png',
    @required this.shopName,
    @required this.rating,
    @required this.category,
    @required this.longDescription,
    @required this.payments,
    this.phone,
    @required this.email,
  }) : super(key: key);

  @override
  _CustomerShopDetailPageState createState() => _CustomerShopDetailPageState();
}

class _CustomerShopDetailPageState extends State<CustomerShopDetailPage> {
  String _comment;
  double _rating;
  bool _canReview;

  @override
  void initState() {
    _comment = "";
    _rating = 0;
    _canReview = false;
    super.initState();
  }

  Future<DocumentSnapshot> _getUserInfo() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();
  }

  Widget _buildSubtitle(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(
            color: Color(kLightBrown),
          ),
    );
  }

  Widget _buildProduct(data, imageWidth) {
    return CustomerProductCard(
      category: data['category'],
      price: data['price'],
      productName: data['product_name'],
      statusTagText: data['quantity_left'] == 0
          ? "Sold Out"
          : data['quantity_left'] / data['total_quantity'] > 0.5
              ? "Still have a lot"
              : "Still have a few",
      rating: data['rating'],
      // isAddedToCart: data.isInCart,
      imageWidth: imageWidth,
      // imageUrl: data['image'][0], //TODO: change to imageUrl in Firebase
      imageUrl: 'assets/sample_product_image.png',
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerProductDetailPage(
              productName: data['product_name'],
              rating: data['rating'].toDouble(),
              category: data['category'],
              price: data['price'],
              statusTagText: data['quantity_left'] == 0
                  ? "Sold Out"
                  : data['quantity_left'] / data['total_quantity'] > 0.5
                      ? "Still have a lot"
                      : "Still have a few",
              description: data['description'],
              //TODO: use Firebase image
              // imagesUrl: data['image'],
              imagesUrl: [
                'assets/sample_product_image.png',
                'assets/default_add_product_image.png',
                'assets/sample_product_image.png',
                'assets/sample_product_image.png'
              ],
              quantityLeft: data['quantity_left'],
            ),
          ),
        )
      },
    );
  }

  Widget _buildCommentList(context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('link',
                isEqualTo: widget.shopName) //TODO: shopname or shop id?
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (!streamSnapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                color: Color(kLightBrown),
              ),
            );
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: streamSnapshot.data.docs.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(4),
                child: Container(
                  width:
                      width - 8 - 32, //calculate the width of screen - padding
                  child: CommentTile(
                    username: streamSnapshot.data.docs[index]['username'],
                    userIconURL: streamSnapshot.data.docs[index]
                        ['userIconUrl'], //TODO: check if the name is correct
                    content: streamSnapshot.data.docs[index]['content'],
                    rating: streamSnapshot.data.docs[index]['rating'],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.category,
          style: Theme.of(context).textTheme.headline4.copyWith(
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
                color: Color(kLightBrown),
                fontWeight: FontWeight.w600,
              ),
        ),
        RatingBarIndicator(
          rating: widget.rating,
          itemBuilder: (context, index) =>
              Icon(Icons.star, color: Color(kYellow)),
          itemCount: 5,
          itemSize: 24,
          unratedColor: Color(0xFFC4C4C4),
          direction: Axis.horizontal,
        ),
        widget.phone != null
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.local_phone_rounded,
                      color: Color(kLightBrown),
                    ),
                  ),
                  Text(
                    widget.phone,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                          color: Color(kLightBrown),
                        ),
                  ),
                ],
              )
            : Container(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.email_rounded,
                color: Color(kLightBrown),
              ),
            ),
            Text(
              widget.email,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 1.5,
                    color: Color(kLightBrown),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(List paymentsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paymentsList.length > 1
              ? 'Accepted payment methods'
              : 'Accepted payment method',
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: Color(kLightBrown),
              ),
        ),
        ...paymentsList.map(
          (payment) => Text(
            '- ' + payment,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Color(kLightBrown),
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double productTileWidth = (width - 16 * 2 - 8) / 2;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.shopName,
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(widget.smallimageUrl),
                      radius: 60,
                    ),
                  ),
                  _buildHeader(),
                ],
              ),
            ),
            _buildPaymentInfo(widget.payments),
            Accordination(content: widget.longDescription),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FutureBuilder(
                future: _getUserInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder(
                      stream: snapshot.data.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (!streamSnapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(kLightBrown),
                            ),
                          );
                        else {
                          if (!streamSnapshot.data.docs[0]['subscription']
                              .contains(widget.shopName)) {
                            return Button(
                                text: 'Subscribe',
                                onPress: () => {
                                      //TODO: Check: add to User subscribed shop in Firebase; customer_users will be combined in users collection
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .update({
                                        "subscription": FieldValue.arrayUnion(
                                            [widget.shopName])
                                      }).then(
                                        (_) {
                                          print("subscribed");
                                        },
                                      ),
                                      //Firebase function ends
                                    });
                          } else {
                            return Button(
                              text: 'Unsubscribe',
                              onPress: () => {
                                //TODO: Check: remove to User subscribed shop in Firebase
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .update({
                                  "subscription":
                                      FieldValue.arrayRemove([widget.shopName])
                                }).then(
                                  (_) {
                                    print("unsubscribed");
                                  },
                                ),
                                //Firebase function ends
                              },
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //TODO: skip comment part if not enough time
                _buildSubtitle('Comments:'),
                FutureBuilder(
                  future: _getUserInfo(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder(
                        stream: snapshot.data.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (!streamSnapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(kLightBrown),
                              ),
                            );
                          else {
                            //TODO: Check: visible when user shopping_history has record shopped in the shop & isPaid
                            for (var i = 0;
                                i <
                                    streamSnapshot
                                        .data.docs[0]['productHistory'].length;
                                i++) {
                              if (streamSnapshot.data.docs[0]['productHistory']
                                          [i]['shop'] ==
                                      widget.shopName &&
                                  streamSnapshot.data.docs[0]['productHistory']
                                      [i]['isPaid']) {
                                return Button(
                                  text: '+ Review',
                                  onPress: () => {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AddReview(
                                        onPress:
                                            (String comment, double rating) {
                                          _comment = comment;
                                          _rating = rating;
                                        },
                                      ),
                                    ).then((_) {
                                      //TODO: Check: send to Firebase if rating != 0
                                      //TODO: Check: update the relavent rating in Shop in Firebase
                                      if (_rating > 0) {
                                        FirebaseFirestore.instance
                                            .collection("comments")
                                            .add({
                                          "writer": FirebaseAuth
                                              .instance.currentUser.uid,
                                          "iconUrl":
                                              "", //TODO: can skip if hard to make
                                          "rating": _rating,
                                          "content": _comment,
                                          "referenceTo": widget
                                              .shopName, //TODO: or store the shop id?
                                        }).then((value) {
                                          print('Rating: ' +
                                              _rating.toString() +
                                              " comment: " +
                                              _comment);
                                          FirebaseFirestore.instance
                                              .collection('shops')
                                              .doc(widget
                                                  .shopName) //TODO: Is shopName == doc id?
                                              .update({
                                            "totalRatings": {
                                              "number": FieldValue.increment(1),
                                              "score":
                                                  FieldValue.increment(_rating),
                                            } //TODO: if get rating in other pages need to use score / number
                                          });
                                        });
                                      }
                                      //Firebase function ends
                                    }),
                                  },
                                );
                              }
                            }
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            _buildCommentList(context),
            _buildSubtitle('Product in sales:'),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('shop',
                      isEqualTo: widget.shopName) //TODO: shopname or shop id?
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (!streamSnapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(kLightBrown),
                    ),
                  );
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        productTileWidth / (productTileWidth + 105),
                    crossAxisSpacing: 4,
                  ),
                  itemCount: streamSnapshot.data.docs.length,
                  //TODO: limit the numbers to display, better 4-6 only
                  itemBuilder: (context, index) {
                    return _buildProduct(
                        streamSnapshot.data.docs[index], productTileWidth - 16);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

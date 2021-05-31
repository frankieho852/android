

import 'dart:core';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/accordination.dart';
import 'package:online_shopping_4521/widgets/comment_tile.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';

import './business_edit_product_page.dart';

class BusinessProductDetailPage extends StatefulWidget {
  final String productName;
  final double rating;
  final String category;
  final double price;
  final int quantityLeft;
  final String description;
  final List imagesUrl;
  final List comments;

  @override
  BusinessProductDetailPage({
    Key key,
    @required this.productName,
    @required this.rating,
    @required this.category,
    @required this.price,
    @required this.quantityLeft,
    @required this.description,
    @required this.imagesUrl,
    @required this.comments,
  }) : super(key: key);

  @override
  _BusinessProductDetailPageState createState() =>
      _BusinessProductDetailPageState();
}

class _BusinessProductDetailPageState extends State<BusinessProductDetailPage> {
  int _currentImageIndex;
  List<String> _listOfImages = <String>[];


  @override
  void initState() {
    //_currentImageIndex = 0;
    super.initState();
  }

  Widget _buildSubtitle(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(
        color: Color(kDarkBrown),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCommentList(data, context) {
    double width = MediaQuery.of(context).size.width;

    return data.length != 0
        ? Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            width:
            width - 8 - 32, //calculate the width of screen - padding
            child: CommentTile(
              username: data[index].username,
              userIconURL: data[index].userIconUrl,
              content: data[index].content,
              rating: data[index].rating,
            ),
          ),
        ),
      ),
    )
        : Center(
      child: Text(
        "No comment yet",
        style: Theme.of(context).textTheme.headline4.copyWith(
          color: Color(kDarkBrown),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(screenWidth) {
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
              //TODO: use Firebase image, check how shd it displayed (network image?)
              image: AssetImage(
                widget.imagesUrl[_currentImageIndex],
              ),
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
                    //TODO: use Firebase image, check how shd it displayed (network image?)
                    image: AssetImage(
                      widget.imagesUrl[i],
                    ),
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
  }

  @override
  Widget build(BuildContext context) {
    //TODO: get from Firebase
    // final List<Comment> comments = commentData;
    //Firebase function ends
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.productName,
          hasBack: true,
          isCustomer: false,
        ),
        backgroundColor: Color(kDarkRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  text: "Edit",
                  onPress: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessEditProductPage(
                          name: widget.productName,
                          totalQuantity: widget.quantityLeft,
                          category: widget.category,
                          price: widget.price,
                          description: widget.description,
                          imagesUrl: widget.imagesUrl,
                        ),
                      ),
                    )
                  },
                  isCustomer: false,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildImageDisplay(width),
            ),
            Text(
              widget.category,
              style: Theme.of(context).textTheme.headline4.copyWith(
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
                color: Color(kDarkBrown),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    widget.quantityLeft.toString() + " Left",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Color(kDarkBrown),
                    ),
                  ),
                ),
                Text(
                  'HKD ' + widget.price.toString(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Color(kDarkBrown),
                  ),
                ),
              ],
            ),
            Accordination(
              content: widget.description,
              isCustomer: false,
            ),
            Row(
              children: [
                Text(
                  "Rating: ",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Color(kDarkBrown),
                  ),
                ),
                Text(
                  widget.rating != 0
                      ? (widget.rating.toString() + " / 5.0")
                      : "No rating yet",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Color(kDarkBrown),
                  ),
                ),
              ],
            ),
            _buildSubtitle("Comments:"),
            //_buildCommentList(widget.comments, context),
          ],
        ),
      ),
    );
  }
}

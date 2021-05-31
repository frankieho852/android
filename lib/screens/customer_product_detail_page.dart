
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/accordination.dart';
import 'package:online_shopping_4521/widgets/add_review.dart';
import 'package:online_shopping_4521/widgets/comment_tile.dart';
import 'package:online_shopping_4521/widgets/status_tag.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/customer_product_card.dart';
import '../data/data.dart';
import '../models/comment.dart';
import '../models/product.dart';

class CustomerProductDetailPage extends StatefulWidget {
  final List imagesUrl;
  final String productName;
  final double rating;
  final String category;
  final double price;
  final String statusTagText;
  final String description;
  final int quantityLeft;

  @override
  CustomerProductDetailPage({
    Key key,
    @required this.imagesUrl,
    @required this.productName,
    @required this.rating,
    @required this.category,
    @required this.price,
    @required this.statusTagText,
    @required this.description,
    @required this.quantityLeft,
  }) : super(key: key);

  @override
  _CustomerProductDetailPageState createState() =>
      _CustomerProductDetailPageState();
}

class _CustomerProductDetailPageState extends State<CustomerProductDetailPage> {
  int _currentImageIndex;
  int _orderQuantity;
  String _comment;
  double _rating;
  List<Comment> comments = [];
  List<Product> products = [];

  @override
  void initState() {
    _currentImageIndex = 0;
    _orderQuantity = 0;
    _comment = "";
    _rating = 0;
    super.initState();
  }

  Widget _buildSubtitle(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(
        color: Color(kLightBrown),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildImageDisplay(screenWidth) {
    return Column(children: [
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
                    //Firebase function ends
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
        ],
      )
    ]);
  }

  Widget _buildProductList(data, context) {
    double width = MediaQuery.of(context).size.width;
    double productCardWidth = (width - 16 * 2 - 8 * 2) / 2;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: productCardWidth + 105,
      width: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            width: productCardWidth,
            child: CustomerProductCard(
              category: data[index].category,
              price: data[index].price,
              productName: data[index].name,
              statusTagText: data[index].quantityLeft == 0
                  ? "Sold Out"
                  : data[index].quantityLeft / data[index].totalQuantity > 0.5
                  ? "Still have a lot"
                  : "Still have a few",
              rating: data[index].rating,
              imageWidth: productCardWidth - 16,
              imageUrl: data[index].imagesUrl[0],
              onPress: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerProductDetailPage(
                      productName: data[index].name,
                      rating: data[index].rating,
                      category: data[index].category,
                      price: data[index].price,
                      statusTagText: data[index].quantityLeft == 0
                          ? "Sold Out"
                          : data[index].quantityLeft /
                          data[index].totalQuantity >
                          0.5
                          ? "Still have a lot"
                          : "Still have a few",
                      description: data[index].description,
                      imagesUrl: data[index].imagesUrl,
                      quantityLeft: data[index].quantityLeft,
                    ),
                  ),
                )
              },
              isAddedToCart: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentList(data, context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            width: width - 8 - 32, //calculate the width of screen - padding
            child: CommentTile(
              username: data[index].username,
              userIconURL: data[index].userIconUrl,
              content: data[index].content,
              rating: data[index].rating,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _settoShoppingcart() async{
    var user = FirebaseAuth.instance.currentUser;
    
    FirebaseFirestore.instance
    .collection('user')
    .doc(user.uid)
    .set({
      'product_history' : {
        'is_paid' : false,
        'order_quantity' : _orderQuantity,
        'product' : widget.productName,
        'total_price' : widget.price * _orderQuantity,
        'transaction' : "",
      }
    });
  }

  bool _CheckUserRecord() {
    var user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .snapshots()
    .listen((event) {
      event.get('product_history').forEach((data){
        if(data['product'] == widget.productName && data['is_paid']){
          return true;
        }
      });
      return false;
    });
  }

  Future<void> _addComment (comment,rating) async{
    var user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
    .collection('commments')
    .add({
      'writer' : user.uid,
      'iconUrl' : "",
      'content' : comment,
      'referenceTo' : widget.productName,
      'rating' : rating,
    });
  }

  Future<void> _getComment() async{
    FirebaseFirestore.instance
        .collection('Comments')
        .where('refereceTo' , isEqualTo: widget.productName)
        .snapshots()
        .listen((event) {
      setState(() {
        comments.clear();
          event.docs.forEach((element) {
            FirebaseFirestore.instance
            .collection('userprofile')
            .doc(element.get('writer'))
            .snapshots()
            .listen((event) {
              comments.add(
                  Comment(
                    userIconUrl: '',
                    rating: element.get('rating'),
                    username: event.get('name'),
                    content: element.get('content'),
                  )
              );
            });
            });
          });
    });
  }

  //not done
  Future<void> _getproduct() async{
    FirebaseFirestore.instance
        .collection('Product detail')
        .where('category' , isEqualTo: widget.category)
        .snapshots()
        .listen((event) {
          setState(() {
            event.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('Product Image')
                  .doc(element.id)
                  .snapshots()
                  .listen((event) {
                products.add(
                    Product(name: element.id,
                        imagesUrl: event.get('urls')[0],
                        rating: 3,
                        statusTagText: element.get('quantity') - element.get('sold') == 0
                            ? "Sold Out"
                            : element.get('quantity') - element.get('sold') /
                            element.get('quantity') >
                            0.5
                            ? "Still have a lot"
                            : "Still have a few",
                        quantityLeft: element.get('quantity') - element.get('sold'),
                        totalQuantity: element.get('quantity'),
                        category: element.get('category'),
                        price: element.get('price'),
                        description: element.get('description'))
                );
              });
              
            });
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //TODO: get from Firebase, related comments (use prod name to search) & prod from same shop / same category
    _getComment();
    _getproduct();

    //Firebase function ends

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.productName,
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildImageDisplay(width),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  //TODO: consider displaying the quantity left instead of a tag
                  child: StatusTag(text: widget.statusTagText),
                ),
                Text(
                  'HKD ' + widget.price.toString(),
                  style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Color(kLightBrown),
                  ),
                ),
              ],
            ),
            Accordination(content: widget.description),
            Visibility(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Order Quantity: ',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Color(kLightBrown),
                    ),
                  ),
                  OutlinedButton(
                    child: Text(
                      "-",
                      style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Color(kLightBrown),
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (_orderQuantity > 0) _orderQuantity -= 1;
                      })
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                              (states) => Color(kDarkRed)),
                      side: MaterialStateBorderSide.resolveWith(
                            (states) =>
                            BorderSide(width: 2, color: Color(kLightBrown)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _orderQuantity.toString(),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color(kLightBrown),
                      ),
                    ),
                  ),
                  OutlinedButton(
                      child: Text(
                        "+",
                        style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Color(kLightBrown),
                        ),
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                                (states) => Color(kDarkRed)),
                        side: MaterialStateBorderSide.resolveWith(
                              (states) =>
                              BorderSide(width: 2, color: Color(kLightBrown)),
                        ),
                      ),
                      onPressed: () => {
                        setState(() {
                          if (_orderQuantity < widget.quantityLeft)
                            _orderQuantity += 1;
                        })
                      }),
                ],
              ),
              visible: widget.statusTagText == "Sold Out" ? false : true,
            ),
            Visibility(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Button(
                  text: "Add to Cart",
                  onPress: () => {
                    //TODO: send data to Firebase user shopping history with ispaid = false
                    _settoShoppingcart(),
                    //product id (if have), order quantity
                    //total price shd not be stored in shopping history but calculate in payment page again
                    print("click ")
                    //Firebase function ends
                  },
                ),
              ),
              visible: widget.statusTagText == "Sold Out" ? false : true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubtitle("Comments:"),
                Visibility(
                  //TODO: visible when user shopping_history has this record & isPaid
                  visible: _CheckUserRecord(),
                  //Firebase function ends
                  child: Button(
                    text: '+ Review',
                    onPress: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AddReview(
                          onPress: (String comment, double rating) {
                            _comment = comment;
                            _rating = rating;
                          },
                        ),
                      ).then(
                        //TODO: send to Firebase if rating != 0
                        //TODO: update the relavent rating in Product in Firebase
                            (value) => {
                              if(_rating != 0 && _comment.isNotEmpty){_addComment(_comment,_rating)},
                              print('Rating: ' +
                                  _rating.toString() +
                                  " comment: " +
                                  _comment),
                            }
                        //Firebase function ends
                      ),
                    },
                  ),
                ),
              ],
            ),
            _buildCommentList(comments, context),
            _buildSubtitle("Products for you:"),
            _buildProductList(products, context),
          ],
        ),
      ),
    );
  }
}
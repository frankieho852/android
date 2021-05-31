
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/payment_tile.dart';
import '../widgets/custom_app_bar.dart';
import 'customer_product_detail_page.dart';

import '../data/data.dart';
import '../models/product.dart';
import '../models/shop.dart';

class CustomerViewOrderCartPage extends StatefulWidget {
  @override
  _CustomerViewOrderCartPageState createState() =>
      _CustomerViewOrderCartPageState();
}

Widget _buildNotPaidTileList(productData, shopData, context) {
  return PaymentTile(
    shopName: productData.shopName,
    productName: productData.name,
    productCategory: productData.category,
    rating: productData.rating ?? 0.0,
    statusTagText: productData.quantityLeft == 0
        ? "Sold Out"
        : productData.quantityLeft / productData.totalQuantity > 0.5
            ? "Still have a lot"
            : "Still have a few",
    shortDescription: productData.description,
    totalPrice: productData.orderQuantity * productData.price,
    orderQuantity: productData.orderQuantity,
    imagesUrl: productData.imagesUrl,
    quantityLeft: productData.quantityLeft,
    acceptPayments: shopData.payments,
    isPaid: false,
    onPress: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (pageContext) => CustomerProductDetailPage(
            productName: productData.name,
            rating: productData.rating ?? 0.0,
            category: productData.category,
            price: productData.price,
            statusTagText: productData.quantityLeft == 0
                ? "Sold Out"
                : productData.quantityLeft / productData.totalQuantity > 0.5
                    ? "Still have a lot"
                    : "Still have a few",
            description: productData.description,
            imagesUrl: productData.imagesUrl,
            quantityLeft: productData.quantityLeft,
          ),
        ),
      )
    },
  );
}

Widget _buildPaidTileList(productData, Map<int, Map<dynamic,dynamic>> shopData, context) {
  return PaymentTile(
    shopName: productData.shopName,
    productName: productData.name,
    productCategory: productData.category,
    rating: productData.rating ?? 0.0,
    statusTagText: productData.quantityLeft == 0
        ? "Sold Out"
        : productData.quantityLeft / productData.totalQuantity > 0.5
            ? "Still have a lot"
            : "Still have a few",
    shortDescription: productData.description,
    totalPrice: productData.orderQuantity * productData.price,
    orderQuantity: productData.orderQuantity,
    imagesUrl: productData.imagesUrl,
    quantityLeft: productData.quantityLeft,
    acceptPayments: shopData,
    isPaid: true,
    onPress: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (pageContext) => CustomerProductDetailPage(
            productName: productData.name,
            rating: productData.rating ?? 0.0,
            category: productData.category,
            price: productData.price,
            statusTagText: productData.quantityLeft == 0
                ? "Sold Out"
                : productData.quantityLeft / productData.totalQuantity > 0.5
                    ? "Still have a lot"
                    : "Still have a few",
            description: productData.description,
            imagesUrl: productData.imagesUrl,
            quantityLeft: productData.quantityLeft,
          ),
        ),
      )
    },
  );
}

class _CustomerViewOrderCartPageState extends State<CustomerViewOrderCartPage> {
  //final List<Product> productsInCart = productData.where((product) => product.isInCart).toList();
  List<Product> shoppinghistory = [];
  List<Product> shoppingCart = [];
  List<Map<dynamic, dynamic>> paidshop = [];
  List<Map<dynamic, dynamic>> unpaidshop = [];

  Future<void> _getShoppingHistory() {
    var user = FirebaseAuth.instance.currentUser;
    //print('enter the get product in cart function');
    FirebaseFirestore.instance
        .collection('customer_users')
        .doc('c_user1')
        .snapshots()
        .listen((product) {
      setState(() {
        shoppinghistory.clear();
        for (int i = 0; i < product.get('product_history').length; i++) {
          if (product.get('product_history')[i]['is_paid'] == true) {
            FirebaseFirestore.instance
                .collection('product detail')
                .doc(product.get('product_history')[i]['product'])
                .get()
                .then((value1) => {
                      FirebaseFirestore.instance
                          .collection('product image')
                          .doc(product.get('product_history')[i]['product'])
                          .get()
                          .then((value2) => {
                                shoppinghistory.add(Product(
                                  name: value1.get('name'),
                                  imagesUrl: value2.get('urls'),
                                  rating: 3,
                                  statusTagText: value1.get('quantity') -
                                              value1.get('sold') ==
                                          0
                                      ? "Sold Out"
                                      : value1.get('quantity') -
                                                  value1.get('sold') /
                                                      value1.get('quantity') >
                                              0.5
                                          ? "Still have a lot"
                                          : "Still have a few",
                                  quantityLeft: value1.get('quantity') -
                                      value1.get('sold'),
                                  totalQuantity: value1.get('quantity'),
                                  category: value1.get('category'),
                                  price: value1.get('price'),
                                  description: value1.get('description'),
                                )),
                                FirebaseFirestore.instance
                                    .collection('Shop detail')
                                    .where('name', isEqualTo: value1.id)
                                    .get()
                                    .then(
                                      (value) => paidshop.add(
                                        value.docs.first.get('payment'),
                                      ),
                                    ),
                              })
                    });
          }
        }
      });
    });
  }

  Future<void> _getShoppingCart() {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('customer_users')
        .doc('c_user1')
        .snapshots()
        .listen((product) {
      setState(() {
        for (int i = 0; i < product.get('product_history').length; i++) {
          if (product.get('product_history')[i]['is_paid'] == false) {
            FirebaseFirestore.instance
                .collection('product detail')
                .doc(product.get('product_history')[i]['product'])
                .get()
                .then((value1) => {
                      FirebaseFirestore.instance
                          .collection('product image')
                          .doc(product.get('product_history')[i]['product'])
                          .get()
                          .then((value2) => {
                                shoppingCart.add(Product(
                                  name: value1.get('name'),
                                  imagesUrl: value2.get('urls'),
                                  rating: 3,
                                  statusTagText: value1.get('quantity') -
                                              value1.get('sold') ==
                                          0
                                      ? "Sold Out"
                                      : value1.get('quantity') -
                                                  value1.get('sold') /
                                                      value1.get('quantity') >
                                              0.5
                                          ? "Still have a lot"
                                          : "Still have a few",
                                  quantityLeft: value1.get('quantity') -
                                      value1.get('sold'),
                                  totalQuantity: value1.get('quantity'),
                                  category: value1.get('category'),
                                  price: value1.get('price'),
                                  description: value1.get('description'),
                                )),
                                FirebaseFirestore.instance
                                    .collection('Shop detail')
                                    .where('name', isEqualTo: value1.id)
                                    .get()
                                    .then(
                                      (value) => unpaidshop.add(
                                        value.docs.first.get('payment'),
                                      ),
                                    )
                              })
                    });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: get the product in cart from Firebase shopping history with isPaid == false
    _getShoppingHistory();
    //TODO: get the orders from Firebase shopping history with isPaid == true
    _getShoppingCart();
    //TODO: get the ccorresponding shop data for the payment methods
    //Firebase function ends

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(kLightRed),
          appBar: CustomAppBar(
            title: 'My orders and cart',
            hasBack: true,
            bottom: TabBar(
              indicatorColor: Color(kLightBrown),
              indicatorWeight: 4,
              tabs: [
                Text(
                  'Cart',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Color(kDarkBrown),
                      ),
                ),
                Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Color(kDarkBrown),
                      ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: shoppingCart.length,
                itemBuilder: (productContext, productIndex) =>
                    _buildNotPaidTileList(shoppingCart[productIndex],
                        unpaidshop[productIndex], productContext),
              ),
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: shoppinghistory.length,
                itemBuilder: (productContext, productIndex) =>
                    _buildPaidTileList(shoppinghistory[productIndex],
                        paidshop[productIndex], productContext),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

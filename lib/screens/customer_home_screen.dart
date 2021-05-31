

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/customer_product_card.dart';
import 'customer_product_detail_page.dart';

import '../data/data.dart';
import '../models/product.dart';

class CustomerHomeScreen extends StatefulWidget {
  final String username;


  @override
  CustomerHomeScreen({
    this.username,
  }) : super();

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<Product> _suggestProducts = [];
  List<Product> _productInCart = [];

  Widget _buildSubtitle(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(
            color: Color(kLightBrown),
          ),
    );
  }

  Widget _buildProductList(data, context) {
    double width = MediaQuery.of(context).size.width;
    double productTileWidth = (width - 16 * 2 - 8 * 2) / 2;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: productTileWidth + 105,
      width: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            width: productTileWidth,
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
              imageWidth: productTileWidth - 16,
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

  Future<void> _getSuggestProduct (){
    FirebaseFirestore.instance
    .collection('Product detail')
    .snapshots()
    .listen((product) {
      //print('the product length ' + product.docs.length.toString());
      setState(() {
      _suggestProducts.clear();
      for(int i = 0 ; i < product.docs.length ; i++){
          _suggestProducts.add(
              Product(
                imagesUrl: ['assets/default_avatar.png','assets/default_avatar.png'],
                name: product.docs[i].id,
                totalQuantity: product.docs[i].get('quantity'),
                rating: 3,
                description: product.docs[i].get('description'),
                category: product.docs[i].get('category'),
                quantityLeft: product.docs[i].get('quantity') - product.docs[i].get('sold'),
                price: product.docs[i].get('price'),
                statusTagText: product.docs[i].get('quantity') - product.docs[i].get('sold') == 0
                    ? "Sold Out"
                    : product.docs[i].get('quantity') - product.docs[i].get('sold') /
                    product.docs[i].get('quantity') >
                    0.5
                    ? "Still have a lot"
                    : "Still have a few",
              ));
        }
      });
    });
  }

  Future<void> _getShoppingCart(){
    FirebaseFirestore.instance
        .collection('customer_users')
        .doc('c_user1')
        .snapshots()
        .listen((product) {
      for(int i = 0 ; i < product.get('product_history').length ; i++){
        if(product.get('product_history')[i]['is_paid'] == true){
          FirebaseFirestore.instance.collection('product detail').where('name' , isEqualTo: product.get('product_history')[i]['product']).get().then((value1) => {
            FirebaseFirestore.instance.collection('product image').doc(product.get('product_history')[i]['product']).get().then((value2) => {
              setState((){
                _productInCart.add(
                    Product(
                      name: value1.docs.first.get('name'),
                      imagesUrl: value2.get('urls'),
                      rating: 3,
                      statusTagText: value1.docs.first.get('quantity') - value1.docs.first.get('sold') == 0
                          ? "Sold Out"
                          : value1.docs.first.get('quantity') - value1.docs.first.get('sold') /
                          value1.docs.first.get('quantity') >
                          0.5
                          ? "Still have a lot"
                          : "Still have a few",
                      quantityLeft: value1.docs.first.get('quantity') - value1.docs.first.get('sold'),
                      totalQuantity: value1.docs.first.get('quantity'),
                      category: value1.docs.first.get('category'),
                      price: value1.docs.first.get('price'),
                      description: value1.docs.first.get('description'),
                    )
                );
              })
            })
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //TODO: get the data from Firebase
    _getSuggestProduct();
    //_getShoppingCart();
    final List<Product> productsInCart =
        productData.where((product) => product.isInCart).toList();

    //TODO: add a addDate field in Product & calculate if it is a new product
    final List<Product> newProducts = productData;
    //Firebase function ends

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Hello ' + widget.username,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSubtitle("The product you may like:"),
            _buildProductList(_suggestProducts, context),
            _buildSubtitle("Product in your cart:"),
            _buildProductList(_productInCart, context),
            _buildSubtitle("New product this month:"),
            _buildProductList(productsInCart, context),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 0,
        ),
      ),
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/function/searchservice.dart';
import 'package:online_shopping_4521/screens/customer_shop_detail_page.dart';
import 'package:online_shopping_4521/screens/customer_product_detail_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/shop_card.dart';

import '../widgets/toggle_button.dart';
import '../widgets/nav_bar.dart';
import '../widgets/sorting_filter.dart';
import '../widgets/search_bar.dart';
import '../widgets/customer_product_card.dart';

import '../data/data.dart';
import '../models/product.dart';
import '../models/shop.dart';

class CustomerSearchScreen extends StatefulWidget {
  @override
  _CustomerSearchScreenState createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  int _status; // 0 = All , 1 = shop , 2 = product
  List<Product> _products;
  List<Shop> _shops;
  String _sort;
  String _search;

  @override
  void initState() {
    super.initState();
    _status = 0;
    _sort = 'Price';
    _search = "";
    _products = [];
    _shops = [];
  }

  _handleSearch(type) {
    _firebaseSearch(String searched, String type) {
      return FirebaseFirestore.instance
          .collection(type)
          .get();
    }

    Map<dynamic,dynamic> _getShopOwner(shopname){

      FirebaseFirestore.instance
      .collection('Shop detail')
      .where('name' , isEqualTo: shopname)
      .snapshots()
      .listen((event) {
        FirebaseFirestore.instance
        .collection('userProfile')
        .doc(event.docs.first.id)
        .snapshots()
        .listen((event1) {
          Map<dynamic, dynamic> result = {
            "name" : event1.get('name'),
            "email": event1.get('email'),
            "fullname" :event1.get('name'),
            "iconUrl" : "assets/default_avatar.png"
          };
          return result;
        });

      });


    }

     _firebaseSearchShop() {

      var user = FirebaseAuth.instance.currentUser;
      setState(() {
        //clear all the records
        _shops.clear();
      _firebaseSearch(_search, 'Shop detail').then((QuerySnapshot snapshots) {
        print('this isze of snapshots ' + snapshots.docs.length.toString());

          for (int i = 0; i < snapshots.docs.length; i++) {
            if(snapshots.docs[i].get('name').contains(_search)){
              FirebaseFirestore.instance.collection('Shop Image').doc(snapshots.docs[i].get('name')).get().then((DocumentSnapshot snapshots2) => {
              print('this isze of snapshots ' + snapshots2.exists.toString()),
                _shops.add(
                  Shop(
                    //TODO: change to firebase result, default value shd be assigned in Add product page
                      email: user.email,
                      name: snapshots.docs[i].get('name'),
                      shortDescription: snapshots.docs[i].get('short_description'),
                      longDescription: snapshots.docs[i].get('long_description'),
                      payments: {'payme' : '123456789'},
                      owner: _getShopOwner(snapshots.docs[i].get('name')),
                      category: snapshots.docs[i].get('category'),
                      imageUrl: snapshots2.get('urls')[0],
                      rating: 3,
                  ),
                )
              });
            }
          }
        });
      });
    }

    double _calShopRating(String shopname){
      double total_score = 0.0;
      int num_of_comment = 0;

      FirebaseFirestore.instance
          .collection('comments')
          .snapshots()
      .listen((element) {
        setState(() {
          num_of_comment = element.docs.length;
          for(int i = 0 ; i < element.docs.length ; i++){
            total_score += element.docs[i].get('rating');
          }
          if(total_score < 0 || num_of_comment < 0){
            return 0.0;
          }else{
            return total_score / num_of_comment;
          }

        });
      });
    }

     _firebaseSearchProduct() {
      setState(() {
        //clear all the records
        _products.clear();
      _firebaseSearch(_search, 'Product detail').then((QuerySnapshot snapshots) {
          for (int i = 0; i < snapshots.docs.length; i++) {
            if(snapshots.docs[i].id.contains(_search)){
              FirebaseFirestore.instance.collection('Product Image').doc(snapshots.docs[i].id).get().then((DocumentSnapshot snapshots2) => {
              _products.add(
              Product(
              //TODO: change to firebase result, default value shd be assigned in Add product page
              imagesUrl: snapshots2.get('urls'),
              name: snapshots.docs[i].id.toString(),
              totalQuantity: snapshots.docs[i].get('quantity'),
              rating: _calShopRating(snapshots.docs[i].id.toString()),
              description: snapshots.docs[i].get('description'),
              category: snapshots.docs[i].get('category'),
              quantityLeft: snapshots.docs[i].get('quantity') - snapshots.docs[i].get('sold'),
              price: snapshots.docs[i].get('price'),
              statusTagText: snapshots.docs[i].get('quantity') - snapshots.docs[i].get('sold') == 0
              ? "Sold Out"
                  : snapshots.docs[i].get('quantity') - snapshots.docs[i].get('sold') /
              snapshots.docs[i].get('quantity') >
              0.5
              ? "Still have a lot"
                  : "Still have a few",
              ),
              )
              });
            }
          }
        });
        print('Product result: ' + _products.toString());
      });
    }

    switch (type) {
      case 0:
        _firebaseSearchShop();
        _firebaseSearchProduct();
        break;
      case 1:
        _firebaseSearchShop();
        break;
      case 2:
        _firebaseSearchProduct();
        break;
    }

    print('Shop result: ' + _shops.length.toString());

  }

  _handleSort(type) {
    setState(() {
      type == "Price"
          ? _products.sort((a, b) => a.price.compareTo(b.price))
          : _products.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  // _changestatuesort(value) {
  //   setState(() {
  //     shops = [];
  //     products = [];
  //     _sort = value;
  //   });
  //   handlesearchproductwithsort(searchstring, _sort);
  // }

  // handlesearchshop(searchstring) {
  //   if (searchstring.length == 0) {
  //     setState(() {
  //       shops = [];
  //       products = [];
  //     });
  //   } else {
  //     SearchService()
  //         .searchfunctionshop(searchstring)
  //         .then((QuerySnapshot docs) {
  //       for (int i = 0; i < docs.docs.length; i++) {
  //         setState(() {
  //           shops.add(Shop(
  //             shortDescription: docs.docs[i].get('short_description'),
  //             email: docs.docs[i].get('email'),
  //             name: docs.docs[i].get('shop_name'),
  //             owner: {},
  //             payments: {},
  //             longDescription: docs.docs[i].get('long_description'),
  //             category: docs.docs[i].get('category'),
  //           ));
  //         });
  //         print('I find one similar result ' + shops.toString());
  //       }
  //     });
  //   }
  // }

  // handlesearchproduct(searchstring) {
  //   if (searchstring.length == 0) {
  //     setState(() {
  //       shops = [];
  //       products = [];
  //     });
  //   } else {
  //     SearchService()
  //         .searchfunctionproduct(searchstring)
  //         .then((QuerySnapshot docs) {
  //       for (int i = 0; i < docs.docs.length; i++) {
  //         setState(() {
  //           products.add(Product(
  //             imagesUrl: ['assets/default_avatar.png'],
  //             name: docs.docs[i].get('product_name'),
  //             totalQuantity: docs.docs[i].get('total_quantity'),
  //             rating: docs.docs[i].get('rating') + .0,
  //             description: docs.docs[i].get('description'),
  //             category: docs.docs[i].get('category'),
  //             quantityLeft: docs.docs[i].get('quantity_left'),
  //             price: docs.docs[i].get('price'),
  //             statusTagText: docs.docs[i].get('quantity_left') == 0
  //                 ? "Sold Out"
  //                 : docs.docs[i].get('quantity_left') /
  //                             docs.docs[i].get('total_quantity') >
  //                         0.5
  //                     ? "Still have a lot"
  //                     : "Still have a few",
  //           ));
  //         });
  //         print('I find one similar result ' + products.toString());
  //       }
  //     });
  //   }
  // }

  // handlesearchproductwithsort(searchstring, sort) {
  //   if (searchstring.length == 0) {
  //     setState(() {
  //       shops = [];
  //       products = [];
  //     });
  //   } else {
  //     SearchService()
  //         .searchfunctionsort(searchstring, sort)
  //         .then((QuerySnapshot docs) {
  //       for (int i = 0; i < docs.docs.length; i++) {
  //         setState(() {
  //           products.add(Product(
  //             imagesUrl: ['assets/default_avatar.png'],
  //             name: docs.docs[i].get('product_name'),
  //             totalQuantity: docs.docs[i].get('total_quantity'),
  //             rating: docs.docs[i].get('rating') + .0,
  //             description: docs.docs[i].get('description'),
  //             category: docs.docs[i].get('category'),
  //             quantityLeft: docs.docs[i].get('quantity_left'),
  //             price: docs.docs[i].get('price'),
  //             statusTagText: docs.docs[i].get('quantity_left') == 0
  //                 ? "Sold Out"
  //                 : docs.docs[i].get('quantity_left') /
  //                             docs.docs[i].get('total_quantity') >
  //                         0.5
  //                     ? "Still have a lot"
  //                     : "Still have a few",
  //           ));
  //         });
  //         print('I find one similar result ' +
  //             docs.docs[i].get('product_name') +
  //             " and the value is: " +
  //             sort);
  //       }
  //     });
  //   }
  // }

  // _changeStatus() {
  //   setState(() {
  //     shops = [];
  //     products = [];
  //   });

  //   if (status + 1 > 2) {
  //     handlesearchshop(searchstring);
  //     handlesearchproduct(searchstring);
  //     setState(() => (status = 0));
  //   } else {
  //     status + 1 == 1 ? handlesearchshop(searchstring) : null;
  //     status + 1 == 2 ? handlesearchproductwithsort(searchstring, _sort) : null;
  //     setState(() => (status++));
  //   }
  // }

  Widget _buildShop(data) {
    return ShopCard(
      shopName: data.name,
      category: data.category,
      rating: data.rating ?? 0.0,
      shortDescription: data.shortDescription,
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (pageContext) => CustomerShopDetailPage(
              shopName: data.name,
              rating: data.rating ?? 0.0,
              category: data.category,
              longDescription: data.longDescription,
              payments: data.payments.keys.map((key) => key).toList(),
              phone: data.phone,
              email: data.email,
            ),
          ),
        )
      },
    );
  }

  Widget _buildProduct(data, imageWidth) {
    return CustomerProductCard(
      category: data.category,
      price: data.price,
      productName: data.name,
      statusTagText: data.quantityLeft == 0
          ? "Sold Out"
          : data.quantityLeft / data.totalQuantity > 0.5
              ? "Still have a lot"
              : "Still have a few",
      rating: data.rating,
      isAddedToCart: data.isInCart,
      imageWidth: imageWidth,
      imageUrl: data.imagesUrl[0],
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerProductDetailPage(
              productName: data.name,
              rating: data.rating,
              category: data.category,
              price: data.price,
              statusTagText: data.quantityLeft == 0
                  ? "Sold Out"
                  : data.quantityLeft / data.totalQuantity > 0.5
                      ? "Still have a lot"
                      : "Still have a few",
              description: data.description,
              imagesUrl: data.imagesUrl,
              quantityLeft: data.quantityLeft,
            ),
          ),
        )
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double productTileWidth = (width - 16 * 2 - 8) / 2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(kLightRed),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color(kDarkRed),
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              expandedHeight: 100.0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: SearchBar(
                          listItem: [
                            'hahahahhaha',
                            'hehehehehheh',
                            'hohohhohoho'
                          ],
                          onChange: (value) => {
                            setState(
                              () {
                                _search = value;
                              },
                            ),
                            // _status == 0 || _status == 1
                            //     ? handlesearchshop(value)
                            //     : null,
                            // _status == 0 ? handlesearchproduct(value) : null,
                            // _status == 2
                            //     ? handlesearchproductwithsort(value, _sort)
                            //     : null,
                            _handleSearch(_status),
                            print('searched ' + _search)
                          },
                        ),
                      ),
                      Visibility(
                        visible: _status == 2 ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SortingFilter(
                            listItem: ['Price', 'Rating'],
                            onPress: (value) => {
                              setState(() {
                                _sort = value;
                              }),
                              _handleSort(_sort),
                              // _changestatuesort(value),
                              print('selected ' + value),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Looking For:',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Color(kDarkBrown))),
                  ToggleButton(
                      options: ['All', 'Shop', 'Product'],
                      isCustomer: false,
                      onPress: () => {
                            setState(() {
                              _status != 2 ? _status++ : _status = 0;
                              _shops.clear();
                              _products.clear();
                            }),
                            _handleSearch(_status),
                            if (_status == 2) _handleSort(_sort),
                          }
                      // _changeStatus(),
                      )
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate:
                    SliverChildListDelegate(_status != 2 && _shops.length == 0
                        ? [
                            Text(
                              "No result in Shop",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    color: Color(kErrorRed),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ]
                        : [for (var i in _shops) _buildShop(i)]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                childAspectRatio: productTileWidth / (productTileWidth + 105),
                children: _status != 1 && _products.length == 0
                    ? [
                        Text(
                          "No result",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Color(kErrorRed),
                              ),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          " in Product",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Color(kErrorRed),
                              ),
                          textAlign: TextAlign.start,
                        ),
                      ]
                    : List.generate(_products.length, (j) {
                        return _buildProduct(
                            _products[j], productTileWidth - 16);
                      }),
              ),
            )
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 1,
        ),
      ),
    );
  }
}

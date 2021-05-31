import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'theme/theme.dart';
import './screens/screens.dart';

import '../data/data.dart';
import '../models/users.dart';
import '../models/shop.dart';
import '../models/product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
   List<Users> customer = [];
   List<Users> business = [];
   List<Shop> shops = [];
   List<Product> products = [];


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  _MyAppState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  Map _orginlizePaymentlist(List paymentlist){
    print('the size of paymentlist ' + paymentlist[0].toString());
    if(paymentlist.length == 1){
      return { 'payme' : paymentlist[0]};
    }else{
      return {
        'payme' : paymentlist[0],
        'payment2' : paymentlist[1]
      };
    }
  }


  _FindUserInformation(){
    print('run the find user information function');
    var user = FirebaseAuth.instance.currentUser;
    print('the user uid ' + user.uid.toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((event) {
      print('the identity ' + event.get('identity'));
      FirebaseFirestore.instance
          .collection('Shop')
          .where('owner' , isEqualTo: user.uid)
          .snapshots()
          .listen((event1) {
        if (event.get('identity') == 'customer') {
          setState(() {
            widget.customer.add(
                Users(username: event.get('username'),
                  iconUrl: 'assets/default_avatar.png',
                  email: event.get('email'),
                  fullname: event.get('username'),)
            );
          });
        }else{
          setState(() {
            widget.business.add(
                Users(username: event.get('username'),
                    iconUrl: 'assets/default_avatar.png',
                    email: event.get('email'),
                    fullname: event.get('username')
                )
            );
          });
          if (event1.size != 0) {
            print('enter the user have shop');
            FirebaseFirestore.instance
                .collection('Shop Image')
                .doc(event1.docs.first.get('searchKeywords')['shop_name'])
                .snapshots()
                .listen((event2) {
                  print("add the shops" + event.exists.toString());
                  setState(() {
                    widget.shops.add(
                      Shop(name: event1.docs.first.get('searchKeywords')['shop_name'],
                          owner: {
                            'iconUrl' : 'assets/default_avatar.png',
                          },
                          category: event1.docs.first.get('category'),
                          shortDescription: event1.docs.first.get('searchKeywords')['short_description'],
                          longDescription: event1.docs.first.get('long_description'),
                          email: event.get('email'),
                          imageUrl: event2.get('urls')[0],
                          payments: {"payme" : "12345678"}));
                  });
            });
          };
          FirebaseFirestore.instance
          .collection('Product detail')
          .where('shopname' , isEqualTo: event1.docs.first.get('searchKeywords')['shop_name'])
          .snapshots()
          .listen((event2) {
            event2.docs.forEach((element)=>{
              FirebaseFirestore.instance
              .collection('Product Image')
              .doc(element.id)
              .snapshots()
              .listen((event) {
                setState(() {
                  print('enter add product');
                  widget.products.add(
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
                          description: element.get('description'),

                      )
                  );
                });
              })
            });
          });
        }
          });
    });
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Online shopping App',
      theme: appTheme(),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        //if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}

        switch (settings.name) {

          case '/c_home':
            widget.customer = [];
            widget.business = [];
            if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}
            return PageRouteBuilder(
                pageBuilder: (
              _,
              __,
              ___,
            ) =>  CustomerHomeScreen(
                      //TODO: get from Firebase the logined account
                      username: widget.customer[0].username?? 'group1',
                      //Firebase function ends
                    ));
          case '/c_search':

            return PageRouteBuilder(
                pageBuilder: (
              _,
              __,
              ___,
            ) =>
                    CustomerSearchScreen());
          case '/c_browse':
            return PageRouteBuilder(
                pageBuilder: (
              _,
              __,
              ___,
            ) =>
                    CustomerBrowseScreen());
          case '/c_account':
            if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}
            return PageRouteBuilder(
                pageBuilder: (
              _,
              __,
              ___,
            ) =>
                    CustomerAccountScreen(
                      //TODO: get from Firebase the logined account
                      //TODO: address can skip in Firebase? just ask users to write when they are paying?
                      username: widget.customer[0].username,
                      iconURL: widget.customer[0].iconUrl,
                      email: widget.customer[0].email,
                      address: 'Room xxxx, xxxx building, xxxxxx,xxxx, HK',
                      //Firebase function ends
                    ));
          case '/b_home':
            widget.business = [];
            if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}
            print('the shop is empty + ' + widget.shops.isEmpty.toString());
            return PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>widget.shops.isEmpty ?
                  BusinessHomeScreen(
                    hvShop: widget.shops.isEmpty ? false : true,
                    username: widget.business[0].username,
                    iconUrl: widget.business[0].iconUrl,
                    email: widget.business[0].email,
                  )
                 : BusinessHomeScreen(
                //TODO: get from Firebase the logined account
                hvShop: widget.shops.isEmpty ? false : true,
                username: widget.business[0].username,
                iconUrl: widget.business[0].iconUrl,
                email: widget.business[0].email,
                shopname: widget.shops[0].name,
                category: widget.shops[0].category,

                //Firebase function ends
              ),
            );
          case '/b_shop':
            widget.business = [];
            if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}
            print('the shop is empty + ' + widget.shops.isEmpty.toString());
            print('the shop payment list ' + widget.shops[0].payments.toString());
            return PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) => widget.shops.isEmpty ? BusinessShopScreen(
                hvShop: false,
                userIconUrl: "assets/default_avatar.png",
              )
                  : BusinessShopScreen(
                //TODO: get from Firebase the logined account
                shopname: widget.shops[0].name,
                shopIconUrl:"assets/default_avatar.png",
                userIconUrl:"assets/default_avatar.png",
                hvShop: true,
                email: widget.shops[0].email,
                phone: widget.shops[0].phone,
                category: widget.shops[0].category,
                shortDescription: widget.shops[0].shortDescription,
                longDescription: widget.shops[0].longDescription,
                payments: widget.shops[0].payments,
                //Firebase function ends
              ),
            );
          case '/b_product':
            widget.business = [];
            if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}
            print('the shop is empty + ' + widget.shops.isEmpty.toString());
            return PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>
              widget.shops.isEmpty ?
              BusinessProductScreen(
                //TODO: get from Firebase the logined account
                hvShop: false,
                email: widget.business[0].email,
                //Firebase function ends
              ):
                  BusinessProductScreen(
                //TODO: get from Firebase the logined account
                products: widget.products,
                hvShop: true,
                email: widget.business[0].email,
                //Firebase function ends
              ),
            );
          case '/b_account':
            widget.business = [];
            widget.customer = [];
            if(widget.customer.isEmpty && widget.business.isEmpty){_FindUserInformation();}
            print('the shop is empty + ' + widget.shops.isEmpty.toString() + ' the business ' + widget.business.isEmpty.toString());
            return PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>
                  BusinessAccountScreen(
                //TODO: get from Firebase the logined account
                username: widget.business[0].username,
                iconUrl: "assets/default_avatar.png",
                email: widget.business[0].email,
                //Firebase function ends
              ),
            );
          case '/login':
            return PageRouteBuilder(pageBuilder: (_, __, ___) => LoginScreen());
          case '/testing':
            return PageRouteBuilder(
                pageBuilder: (
              _,
              __,
              ___,
            ) =>
                    TestingScreen());
        }
      },
    );
  }
}

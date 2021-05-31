
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/customer_shop_detail_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/shop_card.dart';

import '../widgets/custom_app_bar.dart';

import '../data/data.dart';
import '../models/shop.dart';

class CustomerScribedShopPage extends StatefulWidget {
  @override
  _CustomerScribedShopPageState createState() =>
      _CustomerScribedShopPageState();
}

class _CustomerScribedShopPageState extends State<CustomerScribedShopPage> {

  final List<Shop> _subscribedShops = [];

  Widget _buildShopList(data) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (shopContext, shopIndex) => Padding(
        padding: EdgeInsets.all(4),
        child: ShopCard(
          shopName: data[shopIndex].name,
          category: data[shopIndex].category,
          rating: data[shopIndex].rating ?? 0.0,
          shortDescription: data[shopIndex].shortDescription,
          onPress: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (pageContext) => CustomerShopDetailPage(
                  shopName: data[shopIndex].name,
                  rating: data[shopIndex].rating ?? 0.0,
                  category: data[shopIndex].category,
                  longDescription: data[shopIndex].longDescription,
                  payments:
                      data[shopIndex].payments.keys.map((key) => key).toList(),
                  phone: data[shopIndex].phone,
                  email: data[shopIndex].email,
                ),
              ),
            )
          },
        ),
      ),
    );
  }


  Map<dynamic,dynamic> _getShopOwner(owneruid){
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection(user.uid)
        .snapshots()
        .listen((event) {
      Map<dynamic, dynamic> result = {
        "name" : event.docs.first.get('name'),
        "email": event.docs.first.get('email'),
        "fullname" : event.docs.first.get('name'),
        "iconUrl" : "assets/default_avatar.png"
      };
      return result;
    });


  }

  Future<void> _getScribedShops() async{
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get()
    .then((DocumentSnapshot snapshot) => {
      snapshot.get('subscription').forEach((element) => {
        FirebaseFirestore.instance.collection('Shop detail').where('name' , isEqualTo: element.toString()).get().then((value1) =>
        {
          FirebaseFirestore.instance.collection('Shop image').doc(element.toString()).get().then((value2) =>
          {
            setState((){
              _subscribedShops.add(
                Shop(
                  //TODO: change to firebase result, default value shd be assigned in Add product page
                  email: value1.docs.first.id,
                  name: value1.docs.first.get('name'),
                  shortDescription: value1.docs.first.get('description'),
                  longDescription: value1.docs.first.get('description'),
                  payments: value1.docs.first.get('payment'),
                  owner: _getShopOwner(value1.docs.first.id),
                  category: value1.docs.first.get('category'),
                  imageUrl: value2.get('urls'),
                ),
              );
            })
          })
        })
      })
    });

  }

  @override
  Widget build(BuildContext context) {
    //TODO: get the subscribed shop list from Firebase User documents
    _getScribedShops();

    //Firebase function ends

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Subscribed Shop',
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: _buildShopList(_subscribedShops),
      ),
    );
  }
}

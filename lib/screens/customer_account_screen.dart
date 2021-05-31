

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/customer_view_order_cart_page.dart';
import 'package:online_shopping_4521/screens/customer_subscribed_shop_page.dart';
import 'package:online_shopping_4521/screens/customer_edit_account_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/nav_bar.dart';
import '../widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'login_screen.dart';

class CustomerAccountScreen extends StatefulWidget {
  final String username;
  final String iconURL;
  final String email;
  final String address;

  @override
  CustomerAccountScreen({
    this.username,
    this.iconURL,
    this.email,
    this.address,
  }) : super();

  @override
  _CustomerAccountScreenState createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> {
  Widget _buildAppBar(theme, screenWidth) {

    Size size = MediaQuery.of(context).size;
    String geturl;
    String getname;
    String getemail;
    String getaddress;

    Future<void> _getinfo() async {
      var user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .snapshots()
          .listen((detailData) {
        setState(() {
          geturl = detailData.get("url");
          getname = detailData.get("name");
          getemail = user.email;
        });
        FirebaseFirestore.instance
            .collection('customer_users')
            .doc(user.uid)
            .snapshots()
            .listen((detailData) {
          setState(() {
            getaddress = detailData.get("addresss");
          });
        });
      });
      CustomerAccountScreen(username:getname,iconURL:geturl,email:getemail,address:getaddress);
    }

    _getinfo();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(kDarkRed),
      toolbarHeight: 152,
      title: Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.iconURL,
            imageBuilder: (context, imageProvider) => Container(
              //padding: EdgeInsets.all(kDefaultPadding * 0.1),
              height: size.height * 0.06,
              width: size.height * 0.06, // ensure sqaure container
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(widget.iconURL),
                  //imageProvider
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                alignment: Alignment.center,
                height: size.height * 0.06,
                width: size.height * 0.06,
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Color(0xFF00A299)))),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              //TODO: check how shd the firebase image displayed on frontend (network image?)
              backgroundImage: AssetImage(widget.iconURL),
              radius: 60,
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth - 32 - 120 - 32,
              child: Text(
                //TDOD: hard code for now , get from db later
                widget.username,
                style: theme.textTheme.headline3.copyWith(
                  color: Color(kDarkBrown),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(theme, width),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My info',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Color(kLightBrown),
                      ),
                ),
                Button(
                  text: 'Edit',
                  onPress: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerEditAccountPage(
                          name: widget.username,
                          address: widget.address,
                          iconURL: widget.iconURL,
                        ),
                      ),
                    ),
                  },
                ),
              ],
            ),
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.iconURL),
                radius: 80,
              ),
            ),*/
            CachedNetworkImage(
              imageUrl: widget.iconURL,
              imageBuilder: (context, imageProvider) => Container(
                //padding: EdgeInsets.all(kDefaultPadding * 0.1),
                height: size.height * 0.06,
                width: size.height * 0.06, // ensure sqaure container
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(widget.iconURL),
                    //imageProvider
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  width: size.height * 0.06,
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xFF00A299)))),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.email,
                    color: Color(kLightBrown),
                  ),
                ),
                Text(
                  widget.email,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color(kLightBrown),
                      ),
                ),
              ],
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(right: 8.0),
            //       child: Icon(Icons.location_on),
            //     ),
            //     Expanded(
            //       child: Text(
            //         widget.address,
            //         style: Theme.of(context).textTheme.headline4.copyWith(
            //               color: Color(kLightBrown),
            //             ),
            //       ),
            //     )
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Button(
                  text: 'View my subscribed shops',
                  onPress: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerScribedShopPage(),
                          ),
                        ),
                      }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Button(
                text: 'View my orders and cart',
                onPress: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerViewOrderCartPage(),
                    ),
                  )
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Button(
                  text: 'Logout',
                  isCustomer: true,
                  onPress: () => {
                    FirebaseAuth.instance.signOut().then((value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ),
                    }),
                  }),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 3,
        ),
      ),
    );
  }
}

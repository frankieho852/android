
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/login_screen.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/nav_bar.dart';
import './business_edit_account_page.dart';
import '../widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BusinessAccountScreen extends StatefulWidget {
  final String username;
  final String iconUrl;
  final String email;

  @override
  BusinessAccountScreen({
    Key key,
    this.username,
    this.iconUrl,
    this.email,
  }) : super(key: key);

  @override
  _BusinessAccountScreenState createState() => _BusinessAccountScreenState();
}

class _BusinessAccountScreenState extends State<BusinessAccountScreen> {

  Widget _buildAppBar(theme) {
    Size size = MediaQuery.of(context).size;
    String geturl;
    String getname;
    String getemail;

    Future<void> _getinfo() async {
      var user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((detailData) {
        setState(() {
          geturl = detailData.get("url");
          getname = detailData.get("name");
          getemail = user.email;
          BusinessAccountScreen(username:getname,iconUrl:geturl,email:getemail);
        });
      });
    }
    _getinfo();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(kLightRed),
      toolbarHeight: 152,
      title: Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.iconUrl,
            imageBuilder: (context, imageProvider) => Container(
              //padding: EdgeInsets.all(kDefaultPadding * 0.1),
              height: size.height * 0.06,
              width: size.height * 0.06, // ensure sqaure container
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(widget.iconUrl),
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
              //TODO: check how to display
              backgroundImage: AssetImage(widget.iconUrl),
              radius: 60,
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.username + " : D",
              style: theme.textTheme.headline3.copyWith(
                color: Color(kLightBrown),
                fontWeight: FontWeight.w500,
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
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(theme),
        backgroundColor: Color(kDarkRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'My info',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Color(kDarkBrown),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            /*CircleAvatar(
              backgroundImage: AssetImage(widget.iconUrl),
              radius: 80,
            ),*/
            CachedNetworkImage(
              imageUrl: widget.iconUrl,
              imageBuilder: (context, imageProvider) => Container(
                //padding: EdgeInsets.all(kDefaultPadding * 0.1),
                height: size.height * 0.06,
                width: size.height * 0.06, // ensure sqaure container
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: NetworkImage(widget.iconUrl),
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
              //TODO: check how to display
              backgroundImage: AssetImage(widget.iconUrl),
              radius: 60,
            ),
          ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.username + " : D",
                style: theme.textTheme.headline3.copyWith(
                  color: Color(kLightBrown),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.email,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    decorationThickness: 1.5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Button(
                  text: 'Edit',
                  isCustomer: false,
                  onPress: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusineesEditAccountPage(
                          fullname: widget.username,
                          iconUrl: widget.iconUrl,
                        ),
                      ),
                    ),
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Button(
                  text: 'Logout',
                  isCustomer: false,
                  onPress: () => {
                    FirebaseAuth.instance.signOut().then((value) =>
                      {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => LoginScreen(

                  ),
                  ),
                  ),
                  }),

                  }),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 3,
          isCustomer: false,
        ),
      ),
    );
  }
}

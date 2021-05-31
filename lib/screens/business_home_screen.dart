
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/button.dart';

import '../widgets/nav_bar.dart';
import '../widgets/custom_app_bar.dart';

import './business_register_shop_page.dart';
import './business_comment_page.dart';

import '../data/data.dart';
import '../models/comment.dart';

class BusinessHomeScreen extends StatefulWidget {
  final bool hvShop;
  final String username;
  final String iconUrl;
  final String email;
  final String shopname;
  final String category;

  @override
  BusinessHomeScreen({
    Key key,
    this.hvShop,
    this.username,
    this.iconUrl,
    this.email,
    this.shopname,
    this.category,
  }) : super(key: key);
  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  Map<String, String> shopStat;
  Map<String, String> tradeStat;
  Map<String, String> productStat;

  @override
  void initState() {
    //TODO: get from Firebase
    shopStat = {
      "Total Shop Views": "0", //TODO: maybe delete this
      "Total Subscribers": "0",
      "Average Rating": "0 / 5.0"
    };
    tradeStat = {
      "Total Trades":
          "0", //TODO: calculate the shops' isPaid history from User?
      "Number of Customers":
          "0", //TODO: number of different users bought products
      "Total Products sold": "0"
    };
    productStat = {
      "Total Product Views": "0", // TODO: maybe delete also
      "Number of Added to Cart": "0", //TODO: isPaid == false
    };
    super.initState();
  }

  Widget _buildSubtitle(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(
            color: Color(kDarkBrown),
          ),
    );
  }

  Widget _buildShopHeader(deviceWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 120,
              width: deviceWidth,
              decoration: BoxDecoration(
                color: Color(kLightRed),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.shopname, //TODO: get from Firebase if have
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Color(kLightBrown),
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "@ " + widget.category, //TODO: get from Firebase
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Color(kLightBrown),
                          ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -60,
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.iconUrl),
                radius: 60,
              ),
            ),
          ]),
    );
  }

  Widget _buildShopInfo(deviceWidth, header, info) {
    return Column(
      children: [
        Card(
          color: Color(kLightRed),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  header,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color(kLightBrown),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                for (var stat in info.keys)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stat,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Color(kLightBrown),
                            ),
                      ),
                      Text(
                        info[stat],
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Color(kLightBrown),
                            ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeHeader(deviceWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 120,
        width: deviceWidth,
        decoration: BoxDecoration(
          color: Color(kLightRed),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                //TODO: check the way to display the image
                backgroundImage: AssetImage(widget.iconUrl),
                radius: 52,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You can be an owner!!",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Color(kLightBrown),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Join our community \n in a few minutes!!",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Color(kLightBrown),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //TODO: get from Firebase
    final List<Comment> comments = commentData;
    //Firebase function ends

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Welcome ' + widget.username.toString() + ' :D',
          isCustomer: false,
        ),
        backgroundColor: Color(kDarkRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            widget.hvShop ? _buildShopHeader(width) : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: _buildSubtitle(widget.hvShop
                  ? "Shop Overview"
                  : "You haven't had a shop yet?!"),
            ),
            widget.hvShop
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildShopInfo(width, "Shop Statistic", shopStat),
                      _buildShopInfo(width, "Trade Statistic", tradeStat),
                      _buildShopInfo(width, "Product Statistic", productStat),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Button(
                          text: "Comment >>",
                          onPress: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusinessCommentPage(
                                  comments: comments,
                                ),
                              ),
                            )
                          },
                          isCustomer: false,
                        ),
                      ),
                    ],
                  )
                : _buildHomeHeader(width),
            Visibility(
              visible: !widget.hvShop,
              child: Button(
                text: "Register your own Shop >>>",
                onPress: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessRegisterShopPage(
                        email: widget.email,
                      ),
                    ),
                  )
                },
                isCustomer: false,
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 0,
          isCustomer: false,
        ),
      ),
    );
  }
}

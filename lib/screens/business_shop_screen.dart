

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/button.dart';
import '../widgets/nav_bar.dart';
import '../widgets/accordination.dart';

import './business_register_shop_page.dart';
import './business_edit_shop_page.dart';

class BusinessShopScreen extends StatefulWidget {
  final bool hvShop;
  final String shopname;
  final String shopIconUrl;
  final String userIconUrl;
  final String email;
  final String phone;
  final String category;
  final String shortDescription;
  final String longDescription;
  final Map payments;

  @override
  BusinessShopScreen({
    Key key,
    @required this.hvShop,
    this.shopname,
    this.shopIconUrl,
    this.userIconUrl,
    this.email,
    this.phone,
    this.category,
    this.shortDescription,
    this.longDescription,
    this.payments,
  }) : super(key: key);
  @override
  _BusinessShopScreenState createState() => _BusinessShopScreenState();
}

class _BusinessShopScreenState extends State<BusinessShopScreen> {
  Map<IconData, String> infoRow;

  @override
  void initState() {
    if (widget.hvShop)
      infoRow = {
        Icons.apps_rounded: widget.category,
        Icons.email: widget.email,
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

  Widget _buildAppBar(theme) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(kLightRed),
      toolbarHeight: 152,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              //TDOD: check how to display
              backgroundImage: widget.hvShop
                  ? FileImage(File(widget.shopIconUrl))
                  : AssetImage(widget.userIconUrl),
              radius: 60,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.hvShop
                  ? widget.shopname + " : D"
                  : "You can be \n an owner!",
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

  Widget _buildPaymentInfo(Map paymentsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paymentsList.length > 1 ? 'Payment methods' : 'Payment method',
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: Color(kDarkBrown),
              ),
        ),
        for (var i in paymentsList.keys)
          Text(
            '- ' + i,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Color(kDarkBrown),
                ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (widget.hvShop && widget.phone != null)
      infoRow[Icons.local_phone_rounded] = "(+852) " + widget.phone;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(theme),
        backgroundColor: Color(kDarkRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSubtitle(widget.hvShop
                      ? "Shop Info"
                      : "You haven't had a shop yet?!"),
                  Visibility(
                    visible: widget.hvShop,
                    child: Button(
                      text: "Edit",
                      onPress: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessEditShopPage(
                              email: widget.email,
                              name: widget.shopname,
                              category: widget.category,
                              phone: widget.phone,
                              sDescription: widget.shortDescription,
                              lDescription: widget.longDescription,
                              payments: widget.payments,
                              iconUrl: widget.shopIconUrl,
                            ),
                          ),
                        )
                      },
                      isCustomer: false,
                    ),
                  ),
                ],
              ),
            ),
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
            if (widget.hvShop)
              for (var key in infoRow.keys)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Icon(key),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        infoRow[key],
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              decorationThickness: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
            Visibility(
              visible: widget.hvShop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Accordination(
                    content: widget.shortDescription,
                    header: "Short Description",
                    isCustomer: false,
                  ),
                  Accordination(
                    content: widget.longDescription,
                    header: "Long Description",
                    isCustomer: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildPaymentInfo(widget.payments),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 1,
          isCustomer: false,
        ),
      ),
    );
  }
}

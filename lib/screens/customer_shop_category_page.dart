
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping_4521/screens/customer_shop_detail_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/shop_card.dart';

import '../widgets/nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class CustomerShopCategoryPage extends StatefulWidget {
  final String category;

  CustomerShopCategoryPage({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _CustomerShopCategoryPageState createState() =>
      _CustomerShopCategoryPageState();
}

class _CustomerShopCategoryPageState extends State<CustomerShopCategoryPage> {
  Widget _buildShopList(data) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (shopContext, shopIndex) => Padding(
        padding: EdgeInsets.all(4),
        child: ShopCard(
          shopName: data[shopIndex]['shop_name'],
          category: data[shopIndex]['category'],
          rating: data[shopIndex]['rating'] ?? 0.0,
          shortDescription: data[shopIndex]['short_description'],
          onPress: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (pageContext) => CustomerShopDetailPage(
                  shopName: data[shopIndex]['shop_name'],
                  rating: data[shopIndex]['rating'] ?? 0.0,
                  category: data[shopIndex]['category'],
                  longDescription: data[shopIndex]['long_description'],
                  payments: data[shopIndex]['payments']
                      .keys
                      .map((key) => key)
                      .toList(),
                  phone: data[shopIndex]['phone'],
                  email: data[shopIndex]['email'],
                ),
              ),
            )
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Shop >>> ' + widget.category,
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('shops')
              .where('category', isEqualTo: widget.category)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  color: Color(kLightBrown),
                ),
              );
            return _buildShopList(streamSnapshot.data.docs);
          },
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 2,
        ),
      ),
    );
  }
}

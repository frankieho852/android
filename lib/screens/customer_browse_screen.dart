

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/customer_product_category_page.dart';
import 'package:online_shopping_4521/screens/customer_shop_category_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';

import '../widgets/nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/category_tile.dart';

import '../data/data.dart';
import '../models/category.dart';

class CustomerBrowseScreen extends StatefulWidget {
  @override
  _CustomerBrowseScreenState createState() => _CustomerBrowseScreenState();
}

class _CustomerBrowseScreenState extends State<CustomerBrowseScreen> {
  List<Category> productCategories = [];
  List<Category> shopCategories = [];

  Widget _buildSubtitle(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline3.copyWith(
            color: Color(kLightBrown),
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildProductCategory(data) {
    return CategoryTile(
      text: data.name,
      categoryIcon: data.icon,
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CustomerProductCategoryPage(category: data.name),
          ),
        )
      },
    );
  }

  Widget _buildShopCategory(data) {
    return CategoryTile(
      text: data.name,
      categoryIcon: data.icon,
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerShopCategoryPage(category: data.name),
          ),
        )
      },
    );
  }

  Future<void> _getCategory() async{
    FirebaseFirestore.instance
        .collection('categoty')
        .snapshots()
        .listen((category) {
          print('enter the switch function' + category.docs.length.toString());
      setState(() {
        productCategories.clear();
        shopCategories.clear();
        category.docs.forEach((element) {
          switch(element.get('type')){
            case 'both' :
              productCategories.add(
                Category(
                  name: element.get('name'),
                  type: element.get('type')
                ),
              );

              shopCategories.add(
                Category(
                    name: element.get('name'),
                    type: element.get('type')
                ),
              );
              break;
            case 'shop' :
              shopCategories.add(
                Category(
                    name: element.get('name'),
                    type: element.get('type')
                ),
              );
              break;
            case 'product' :
              productCategories.add(
                Category(
                    name: element.get('name'),
                    type: element.get('type')
                ),
              );
              break;
          }
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    /*TODO: create a collection for category in Firebase, with
    * a field stating the name (randomly make 6 - 8 samples for product or/ and shop)
    * a field stating it is for both product & shop or only one
    * a field storing the icon string, if cannot store (data type not found) then make a switch here to map the icons
    */
    _getCategory();
    //TODO: get the data from Firebase

    //Firebase function ends

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Find more here :p',
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSubtitle('Shop >>>'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: shopCategories.length,
                itemBuilder: (context, index) {
                  return _buildShopCategory(shopCategories[index]);
                },
              ),
            ),
            _buildSubtitle('Product >>>'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: productCategories.length,
                itemBuilder: (context, index) {
                  return _buildProductCategory(productCategories[index]);
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 2,
        ),
      ),
    );
  }
}

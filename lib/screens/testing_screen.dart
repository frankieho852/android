
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

import '../widgets/text_input_field.dart';
import '../widgets/text_link.dart';
import '../widgets/button.dart';
import '../widgets/toggle_button.dart';
import '../widgets/nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/customer_product_card.dart';
import '../widgets/category_tile.dart';
import '../widgets/shop_card.dart';
import '../widgets/sorting_filter.dart';
import '../widgets/search_bar.dart';
import '../widgets/accordination.dart';
import '../widgets/business_product_card.dart';
import '../widgets/comment_tile.dart';
import '../widgets/long_text_input_field.dart';
import '../widgets/dialogBox.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/checkbox_field.dart';
import '../widgets/icon_field.dart';

class TestingScreen extends StatefulWidget {
  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  // ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'testing',
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kDarkRed),
        body: ListView(
          padding: const EdgeInsets.all(16),
          // controller: _controller,
          children: [
            TextLink(text: 'testing', onPress: () => {print('call test link')}),
            TextInputField(fieldName: 'testing'),
            Button(text: 'testing', onPress: () => {print('call button')}),
            ToggleButton(
                options: ['test1', 'test2'],
                onPress: () => {print('call toggle button')}),
            Container(
              width: 200,
              child: Row(
                children: [
                  CustomerProductCard(
                    productName: 'nullJADSFJA;JDFfjdlfak',
                    statusTagText: 'Still have a lot',
                    category: 'null',
                    price: 10.3,
                    rating: 2.7,
                    imageWidth: 150,
                    onPress: () => {print("click tile")},
                    isAddedToCart: true,
                  ),
                  BusinessProductCard(
                      productName: 'null',
                      category: 'null',
                      imageWidth: 150,
                      price: 103,
                      quantityLeft: 10,
                      onPress: () => {})
                ],
              ),
            ),
            Container(
              width: 200,
              child: CategoryTile(
                text: 'category 1fff fffdsdcdva',
                onPress: () => {},
              ),
            ),
            ShopCard(
                shopName: "Shop 1",
                category: "category 1",
                onPress: () => {},
                shortDescription:
                    "this is a short short short description of haha ajfjajadaja this is a short short "),
            Row(
              children: [
                Flexible(
                  child: SearchBar(
                    listItem: ['hahahahhaha', 'hehehehehheh', 'hohohhohoho'],
                    onChange: (value) => {print('searched ' + value)},
                  ),
                ),
                SortingFilter(
                  listItem: ['', 'hahahahahha', 'hehe', 'hoho', 'hihi', 'huhu'],
                  onPress: (value) => {
                    print('selected ' + value),
                  },
                ),
              ],
            ),
            Accordination(
              content: "a short description",
            ),
            CommentTile(
              content: 'hah',
              username: 'hah',
              userIconURL: 'assets/default_product_image30.png',
              rating: 3.9,
            ),
            LongTextInputField(fieldName: "Long Description"),
            DialogBox(
              title: 'hahahhahahha',
              content: "confirm?",
              confirmAction: () => {print("confirm")},
            ),
            DropdownField(
              fieldName: "Select field",
              listItem: ['', 'hahahahahha', 'hehe', 'hoho', 'hihi', 'huhu'],
              onPress: (value) => {
                print('selected ' + value),
              },
            ),
            // CheckboxField(fieldOption: "Pay Me", onCheck: (),),
            // IconField(filename: "shopAvatar"),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 2,
          isCustomer: true,
        ),
      ),
    );
  }
}

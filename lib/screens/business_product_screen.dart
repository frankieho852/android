

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/button.dart';

import '../widgets/nav_bar.dart';
import '../widgets/sorting_filter.dart';
import '../widgets/search_bar.dart';
import '../widgets/business_product_card.dart';

import '../models/product.dart';

import './business_register_shop_page.dart';
import './business_add_product_page.dart';
import './business_product_detail_page.dart';

class BusinessProductScreen extends StatefulWidget {
  final List products;
  final Map comments;
  final bool hvShop;
  final String email;

  @override
  BusinessProductScreen({
    Key key,
    this.products,
    this.comments,
    this.hvShop,
    this.email,
  }) : super(key: key);
  @override
  _BusinessProductScreenState createState() => _BusinessProductScreenState();
}

class _BusinessProductScreenState extends State<BusinessProductScreen> {
  String _sort;
  List<Product> _products;
  String _search;

  @override
  void initState() {
    _sort = 'Price';
    _products = [];
    _search = "";
    super.initState();
  }

  _handleSearch() {
    setState(() {
      _products = widget.products.where((product) =>
          product.name.toLowerCase().contains(_search.toLowerCase()));
    });
  }

  _handleSort(type) {
    setState(() {
      type == "Price"
          ? _products.sort((a, b) => a.price.compareTo(b.price))
          : _products.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  Widget _buildProduct(productData, imageWidth) {
    return BusinessProductCard(
      category: productData.category,
      price: productData.price,
      productName: productData.name,
      quantityLeft: productData.quantityLeft,
      imageWidth: imageWidth,
      imageUrl: productData.imagesUrl[0],
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessProductDetailPage(
              productName: productData.name,
              rating: productData.rating,
              category: productData.category,
              price: productData.price,
              quantityLeft: productData.quantityLeft,
              description: productData.description,
              comments: null, //TODO: get from Firebase
              imagesUrl: productData.imagesUrl,
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
        backgroundColor: Color(kDarkRed),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color(kLightRed),
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              expandedHeight: 120.0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Visibility(
                    visible: widget.hvShop &&
                        (widget.products != null &&
                            widget.products.length != 0),
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
                              //TODO: Check: write logic
                              setState(() {
                                _search = value;
                              }),
                              _handleSearch(),
                              print('searched ' + value)
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SortingFilter(
                            listItem: ['Price', 'Rank'],
                            onPress: (value) => {
                              //TODO: Check: write logic
                              setState(() {
                                _sort = value;
                              }),
                              _handleSort(_sort),
                              print('selected ' + value),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Product',
                    style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Color(kLightBrown),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Visibility(
                    visible: widget.hvShop &&
                        (widget.products != null &&
                            widget.products.length != 0),
                    child: Button(
                      text: "Add",
                      onPress: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessAddProductPage(),
                          ),
                        ),
                      },
                      isCustomer: true,
                    ),
                  ),
                ],
              ),
            ),
            !widget.hvShop
                ? SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Oops! You haven't set up a shop!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                        color: Color(kDarkBrown),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Button(
                                    text: "Register your own Shop >>>",
                                    onPress: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessRegisterShopPage(
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
                          ),
                        ],
                      ),
                    ),
                  )
                : widget.products != null && widget.products.length != 0
                    ? SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid.count(
                          crossAxisCount: 2,
                          childAspectRatio:
                              productTileWidth / (productTileWidth + 75),
                          children: List.generate(widget.products.length, (j) {
                            return _buildProduct(
                                widget.products[j],
                                //widget.comments[widget.products[j].name] ?? "group1", //TODO: get the corresponding comments of product, if no time then skip
                                productTileWidth - 16);
                          }),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Oops! You have no product!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                            color: Color(kDarkBrown),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Button(
                                        text: "Add Product",
                                        onPress: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BusinessAddProductPage(),
                                            ),
                                          )
                                        },
                                        isCustomer: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ],
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: 2,
          isCustomer: false,
        ),
      ),
    );
  }
}

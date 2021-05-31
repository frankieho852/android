

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/customer_product_card.dart';
import '../widgets/custom_app_bar.dart';
import 'customer_product_detail_page.dart';

class CustomerProductCategoryPage extends StatefulWidget {
  final String category;

  CustomerProductCategoryPage({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _CustomerProductCategoryPageState createState() =>
      _CustomerProductCategoryPageState();
}

class _CustomerProductCategoryPageState
    extends State<CustomerProductCategoryPage> {
  Widget _buildProduct(data, imageWidth) {
    return CustomerProductCard(
      category: data['category'],
      price: data['price'],
      productName: data['product_name'],
      statusTagText: data['quantity_left'] == 0
          ? "Sold Out"
          : data['quantity_left'] / data['total_quantity'] > 0.5
              ? "Still have a lot"
              : "Still have a few",
      rating: data['rating'].toDouble(),
      isAddedToCart: false, //TODO; get from User
      imageWidth: imageWidth,
      // imageUrl: data['image'][0], //TODO: change to imageUrl in Firebase
      imageUrl: 'assets/sample_product_image.png',
      onPress: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerProductDetailPage(
              productName: data['product_name'],
              rating: data['rating'].toDouble(),
              category: data['category'],
              price: data['price'],
              statusTagText: data['quantity_left'] == 0
                  ? "Sold Out"
                  : data['quantity_left'] / data['total_quantity'] > 0.5
                      ? "Still have a lot"
                      : "Still have a few",
              description: data['description'],
              //TODO: use Firebase image
              // imagesUrl: data['image'],
              imagesUrl: [
                'assets/sample_product_image.png',
                'assets/default_add_product_image.png',
                'assets/sample_product_image.png',
                'assets/sample_product_image.png'
              ],
              quantityLeft: data['quantity_left'],
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
        appBar: CustomAppBar(
          title: 'Product >>> ' + widget.category,
          hasBack: true,
          isCustomer: true,
        ),
        backgroundColor: Color(kLightRed),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('category', isEqualTo: widget.category)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  color: Color(kLightBrown),
                ),
              );
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        productTileWidth / (productTileWidth + 105),
                    crossAxisSpacing: 4,
                  ),
                  itemCount: streamSnapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return _buildProduct(
                        streamSnapshot.data.docs[index], productTileWidth - 16);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

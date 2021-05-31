
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import './status_tag.dart';

class CustomerProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double rating;
  final String statusTagText;
  final String category;
  final double price;
  final Function onPress;
  final bool isAddedToCart;
  final bool isCustomer;
  final double imageWidth;

  CustomerProductCard({
    Key key,
    @required this.productName,
    @required this.category,
    @required this.price,
    @required this.onPress,
    @required this.imageWidth,
    this.imageUrl: 'assets/default_product_image150.png',
    this.rating: 0.0,
    this.statusTagText: "Sold Out",
    this.isAddedToCart: false,
    this.isCustomer: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(kWhite),
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    this.imageUrl,
                    scale: 1,
                    width: this.imageWidth,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      this.productName,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: this.rating,
                    itemBuilder: (context, index) =>
                        Icon(Icons.star, color: Color(kYellow)),
                    itemCount: 5,
                    itemSize: 18,
                    unratedColor: Color(0xFFC4C4C4),
                    direction: Axis.horizontal,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: StatusTag(text: this.statusTagText),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.category,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                        ),
                  ),
                  Text(
                    'HKD ' + this.price.toString(),
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class BusinessProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String category;
  final double price;
  final int quantityLeft;
  final Function onPress;
  final bool isVisible;
  final double imageWidth;

  BusinessProductCard({
    Key key,
    @required this.productName,
    @required this.category,
    @required this.price,
    @required this.quantityLeft,
    @required this.onPress,
    @required this.imageWidth,
    this.imageUrl: 'assets/default_product_image150.png',
    this.isVisible: true,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      this.quantityLeft.toString() + " Left",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
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

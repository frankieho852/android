
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/customer_payment_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:online_shopping_4521/widgets/status_tag.dart';

import 'button.dart';

class PaymentTile extends StatelessWidget {
  final String productName;
  final String shopName;
  final List imagesUrl;
  final String shortDescription;
  final double rating;
  final String statusTagText;
  final String productCategory;
  final int orderQuantity;
  final double totalPrice;
  final bool isPaid;
  final Function onPress;
  final Function onPay;
  final Map acceptPayments;
  final int quantityLeft;

  PaymentTile({
    Key key,
    @required this.productName,
    @required this.shopName,
    @required this.shortDescription,
    @required this.productCategory,
    @required this.orderQuantity,
    @required this.totalPrice,
    @required this.imagesUrl,
    this.rating: 0.0,
    this.statusTagText: "Sold Out",
    @required this.isPaid,
    @required this.onPress,
    this.onPay,
    @required this.acceptPayments,
    @required this.quantityLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(kWhite),
      child: InkWell(
        onTap: this.onPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    this.imagesUrl[0],
                    scale: 1,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            this.productName,
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'From ' + this.shopName,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: StatusTag(text: this.statusTagText),
                          ),
                          Text(
                            'Order Quantity: ' + this.orderQuantity.toString(),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      decorationThickness: 1.5,
                                    ),
                          ),
                          Text(
                            'Total: HKD ' + this.totalPrice.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          this.isPaid
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    height: 30,
                                    child: Button(
                                      text: "Pay Now >>",
                                      onPress: () => {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerPaymentPage(
                                              imagesUrl: this.imagesUrl,
                                              productName: this.productName,
                                              rating: this.rating,
                                              category: this.productCategory,
                                              totalPrice: this.totalPrice,
                                              statusTagText: this.statusTagText,
                                              description:
                                                  'This is the description for the product',
                                              orderQuantity: this.orderQuantity,
                                              payments: this.acceptPayments,
                                              quantityLeft: this.quantityLeft,
                                            ),
                                          ),
                                        ),
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

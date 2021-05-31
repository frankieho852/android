
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class StatusTag extends StatelessWidget {
  final Map<String, int> statusText = {
    "Still have a lot": kGreen,
    "Still have a few": kYellow,
    "Sold Out": kRed
  };
  final String text;
  final bool isCustomer;

  StatusTag({Key key, @required this.text, this.isCustomer: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color(statusText[this.text] ?? kBlack),
      ),
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Text(
        this.text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w400,
              color: Color(0xffffffff),
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

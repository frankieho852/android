
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class CategoryTile extends StatelessWidget {
  final String text;
  final Function onPress;
  final IconData categoryIcon;
  final bool isCustomer;

  CategoryTile(
      {Key key,
      @required this.text,
      @required this.onPress,
      this.categoryIcon,
      this.isCustomer: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: FlatButton(
        splashColor: Colors.transparent,
        hoverColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
        focusColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
        highlightColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: isCustomer ? Color(kDarkRed) : Color(kLightRed),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                categoryIcon ?? Icons.apps_rounded,
                size: 40,
                color: isCustomer ? Color(kDarkBrown) : Color(kLightBrown),
              ),
            ),
            Expanded(
              //prevent overflow error in text
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          isCustomer ? Color(kDarkBrown) : Color(kLightBrown),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onPressed: onPress,
      ),
    );
  }
}

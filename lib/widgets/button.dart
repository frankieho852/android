
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPress;
  final bool isCustomer;

  Button(
      {Key key,
      @required this.text,
      @required this.onPress,
      this.isCustomer: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(
          blurRadius: 6,
          color: Color(0x70000000),
          offset: Offset(0, 3),
        ),
      ]),
      child: FlatButton(
        splashColor: Colors.transparent,
        hoverColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
        focusColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
        highlightColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: isCustomer ? Color(kDarkRed) : Color(kLightRed),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.w500,
                color: isCustomer ? Color(kDarkBrown) : Color(kLightBrown),
              ),
        ),
        onPressed: onPress,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/button.dart';

class DialogBox extends StatelessWidget {
  final String title;
  final String content;
  final String buttonConfirmText;
  final String buttonCancelText;
  final Function confirmAction;
  final bool isCustomer;
  final bool haveCancel;

  @override
  DialogBox({
    Key key,
    @required this.title,
    @required this.content,
    @required this.confirmAction,
    this.buttonConfirmText: 'Confirm',
    this.buttonCancelText: 'Cancel',
    this.isCustomer: true,
    this.haveCancel: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: isCustomer ? Color(kDarkRed) : Color(kLightRed),
      title: Text(this.title),
      titleTextStyle: theme.textTheme.headline4.copyWith(
        fontWeight: FontWeight.w500,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(this.content),
          ],
        ),
      ),
      contentTextStyle: theme.textTheme.bodyText1,
      actions: <Widget>[
        Button(
          text: this.buttonConfirmText,
          onPress: () => {
            this.confirmAction,
            Navigator.of(context).pop(),
          },
          isCustomer: false,
        ),
        Button(
          text: this.buttonCancelText,
          onPress: () => Navigator.of(context).pop(),
          isCustomer: false,
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';

class TextLink extends StatefulWidget {
  final String text;
  final Function onPress;

  TextLink({
    Key key,
    @required this.text,
    @required this.onPress,
  }) : super(key: key);

  @override
  _TextLinkState createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onPress,
      child: Text(
        widget.text,
        style: theme.textTheme.caption.copyWith(
          decoration: TextDecoration.underline,
          decorationThickness: 1.5,
        ),
      ),
    );
  }
}

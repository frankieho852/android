
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class ToggleButton extends StatefulWidget {
  final List<String> options;
  final Function onPress;
  final bool isCustomer;

  ToggleButton(
      {Key key,
      @required this.options,
      @required this.onPress,
      this.isCustomer: true})
      : super(key: key);
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  int _currentText = 0;

  _toggleText() {
    setState(() => {
          _currentText < widget.options.length - 1
              ? _currentText += 1
              : _currentText = 0
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          width: 2.5,
          color: widget.isCustomer ? Color(kLightBrown) : Color(kDarkBrown),
        ),
      ),
      child: FlatButton(
        splashColor: Colors.transparent,
        hoverColor: widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
        focusColor: widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
        highlightColor: widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
        child: Text(
          widget.options[_currentText],
          style: Theme.of(context).textTheme.headline5.copyWith(
                color:
                    widget.isCustomer ? Color(kDarkBrown) : Color(kLightBrown),
                fontWeight: FontWeight.w600,
              ),
        ),
        onPressed: () {
          widget.onPress();
          _toggleText();
        },
      ),
    );
  }
}

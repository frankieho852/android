
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class DropdownField extends StatefulWidget {
  final List<String> listItem;
  final String fieldName;
  final bool isCustomer;
  final bool isRequired;
  final Function onPress;
  final String initialValue;

  DropdownField({
    Key key,
    @required this.listItem,
    @required this.fieldName,
    @required this.onPress,
    this.isCustomer: true,
    this.isRequired: false,
    this.initialValue,
  }) : super(key: key);

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.initialValue ?? widget.listItem[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 84,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.fieldName,
                style: theme.textTheme.headline4.copyWith(
                  color: widget.isCustomer
                      ? Color(kLightBrown)
                      : Color(kDarkBrown),
                ),
              ),
              Text(
                widget.isRequired ? '*' : '',
                style: theme.textTheme.headline4.copyWith(
                  color: Color(kRed),
                ),
              ),
            ],
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Color(kWhite),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                width: 3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: dropdownValue,
                elevation: 4,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                dropdownColor: Color(kWhite),
                icon: Icon(Icons.arrow_drop_down_rounded, size: 30),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(kWhite),
                    ),
                  ),
                ),
                items: this
                    .widget
                    .listItem
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    widget.onPress(dropdownValue);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

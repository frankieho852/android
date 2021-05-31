
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class SortingFilter extends StatefulWidget {
  final List<String> listItem;
  final Function onPress;

  SortingFilter({
    Key key,
    @required this.listItem,
    @required this.onPress,
  }) : super(key: key);

  @override
  _SortingFilterState createState() => _SortingFilterState();
}

class _SortingFilterState extends State<SortingFilter> {
  String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.listItem[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: DropdownButton(
        value: dropdownValue,
        elevation: 4,
        style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.w400,
            ),
        dropdownColor: Color(kWhite),
        icon: Icon(Icons.arrow_drop_down_rounded),
        underline: Container(
          height: 2,
          color: Color(0xffffffff),
        ),
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue;
            widget.onPress(dropdownValue);
          });
        },
        items:
            this.widget.listItem.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

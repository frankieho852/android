
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class SearchBar extends StatefulWidget {
  final List<String> listItem;
  final Function onChange;
  final bool isCustomer;

  SearchBar(
      {Key key,
      @required this.listItem,
      @required this.onChange,
      this.isCustomer: true})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<String> filteredNames = [];

  bool hasText;
  TextEditingController _searchBarController;

  @override
  void initState() {
    _searchBarController = TextEditingController();
    _searchBarController.addListener(() {
      setState(() {
        hasText = _searchBarController.text != null &&
            _searchBarController.text != '';
      });
    });
    super.initState();
  }

  void handleSearch(String value) {
    setState(() {
      if (hasText) {
        filteredNames = widget.listItem
            .where((name) => name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        filteredNames = [];
      }
      widget.onChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Color(kWhite),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          width: 3,
          color: Color(0xFFFFFFFF),
        ),
      ),
      child: TextField(
        onChanged: handleSearch,
        controller: _searchBarController,
        maxLines: 1,
        cursorColor: widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
        decoration: InputDecoration(
          hintText: " Search ...",
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: Color(kBlack)),
          suffixIcon: IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.clear_rounded, color: Color(kBlack)),
            splashColor: Colors.transparent,
            onPressed: () {
              _searchBarController.clear();
              filteredNames = [];
              widget.onChange('');
            },
          ),
        ),
      ),
    );
  }
}

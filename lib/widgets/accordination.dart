

import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class Accordination extends StatefulWidget {
  final String header;
  final String content;
  final bool isCustomer;

  @override
  Accordination(
      {Key key,
      this.header: "Description",
      @required this.content,
      this.isCustomer: true})
      : super(key: key);

  @override
  _AccordinationState createState() => _AccordinationState();
}

class _AccordinationState extends State<Accordination> {
  bool _isOpen;
  @override
  void initState() {
    super.initState();
    _isOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ExpansionTile(
            collapsedBackgroundColor:
                widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
            backgroundColor:
                widget.isCustomer ? Color(kDarkRed) : Color(kLightRed),
            title: Text(
              this.widget.header,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color:
                    widget.isCustomer ? Color(kDarkBrown) : Color(kLightBrown),
              ),
            ),
            trailing: _isOpen
                ? Icon(Icons.arrow_drop_up_rounded,
                    color: widget.isCustomer
                        ? Color(kDarkBrown)
                        : Color(kLightBrown))
                : Icon(Icons.arrow_drop_down_rounded,
                    color: widget.isCustomer
                        ? Color(kDarkBrown)
                        : Color(kLightBrown)),
            onExpansionChanged: (isOpen) {
              setState(() => (_isOpen = !_isOpen));
            },
            children: [
              ListTile(
                title: Text(
                  widget.content,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: widget.isCustomer
                            ? Color(kDarkBrown)
                            : Color(kLightBrown),
                      ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

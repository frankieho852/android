
import 'package:flutter/material.dart';

import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/text_input_field.dart';

class CheckboxField extends StatefulWidget {
  final String fieldOption;
  final bool isCustomer;
  final bool initialIsChecked;
  final String initialInfo;
  final Function onInfoChange;
  final Function onCheck;
  final Function onUncheck;

  CheckboxField({
    Key key,
    @required this.fieldOption,
    this.isCustomer: false,
    this.initialIsChecked,
    this.initialInfo,
    this.onInfoChange,
    @required this.onCheck,
    @required this.onUncheck,
  }) : super(key: key);
  @override
  _CheckboxFieldState createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  bool _isChecked;
  String _info;

  @override
  void initState() {
    _isChecked = widget.initialIsChecked ?? false;
    _info = widget.initialInfo ?? null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
            title: Text(
              widget.fieldOption,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Color(widget.isCustomer ? kLightBrown : kDarkBrown),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            activeColor: Color(widget.isCustomer ? kDarkRed : kLightRed),
            controlAffinity: ListTileControlAffinity.leading,
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value;
                _isChecked
                    ? widget.onCheck(widget.fieldOption)
                    : widget.onUncheck(widget.fieldOption);
              });
            }),
        Visibility(
          visible: _isChecked,
          child: Padding(
            padding: const EdgeInsets.only(left: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: _info == null || _info == "",
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Please enter a valid payment link.',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                TextInputField(
                  fieldName: "Link/Phone",
                  onSaved: (input) => _info = input,
                  isRequired: true,
                  isCustomer: false,
                  initialValue: widget.initialInfo,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

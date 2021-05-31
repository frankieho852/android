
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class LongTextInputField extends StatefulWidget {
  final String fieldName;
  final String placeholder;
  final bool isCustomer;
  final bool isRequired;
  final bool isError;
  final String errorText;
  final String initialValue;
  final TextEditingController textController;
  final Function validator;
  final Function onSaved;
  final TextInputType keyboardType;
  final int maxLength;

  LongTextInputField({
    Key key,
    @required this.fieldName,
    this.placeholder: '',
    this.isCustomer: true,
    this.isRequired: false,
    this.isError: false,
    this.errorText: 'Error',
    this.textController,
    this.validator,
    this.onSaved,
    this.keyboardType,
    this.maxLength: 100,
    this.initialValue,
  }) : super(key: key);

  @override
  _LongTextInputFieldState createState() => _LongTextInputFieldState();
}

class _LongTextInputFieldState extends State<LongTextInputField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      // height: 155,
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
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            height: 120,
            decoration: BoxDecoration(
              color: Color(kWhite),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                width: 3,
                color: Color(0xFFFFFFFF),
              ),
            ),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              controller: widget.textController,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              cursorColor: widget.isError
                  ? Color(kErrorRed)
                  : widget.isCustomer
                      ? Color(kDarkRed)
                      : Color(kLightRed),
              decoration: InputDecoration(
                // errorText: widget.errorText,
                errorStyle: TextStyle(height: 0),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: widget.placeholder,
              ),
              onSaved: widget.onSaved,
              style: theme.textTheme.headline4,
              maxLines: 3,
              maxLength: widget.maxLength,
              initialValue: widget.initialValue,
            ),
          ),
        ],
      ),
    );
  }
}

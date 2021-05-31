
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class TextInputField extends StatefulWidget {
  final String fieldName;
  final String placeholder;
  final bool isCustomer;
  final bool isRequired;
  final bool isObscureText;
  final bool isReadOnly;
  final bool isError;
  final String errorText;
  final TextEditingController textController;
  final Function validator;
  final Function onSaved;
  final TextInputType keyboardType;
  final int maxLines;
  final String initialValue;

  TextInputField({
    Key key,
    @required this.fieldName,
    this.placeholder: '',
    this.isCustomer: true,
    this.isRequired: false,
    this.isObscureText: false,
    this.isReadOnly: false,
    this.isError: false,
    this.errorText: 'Error',
    this.textController,
    this.validator,
    this.onSaved,
    this.keyboardType,
    this.maxLines: 1,
    this.initialValue: "",
  }) : super(key: key);

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _obscureText;

  _toggleObscure() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  void initState() {
    _obscureText = widget.isObscureText;
    super.initState();
  }

  Widget _buildSuffixIcon() {
    if (widget.isObscureText)
      return IconButton(
        icon: Icon(Icons.remove_red_eye_rounded),
        onPressed: () => _toggleObscure(),
        padding: const EdgeInsets.all(0),
        splashColor: Colors.transparent,
        color: _obscureText
            ? Color(kBlack)
            : widget.isCustomer
                ? Color(kDarkBrown)
                : Color(kLightBrown),
      );
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: 100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
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
          ),
          Container(
            padding: const EdgeInsets.only(left: 8),
            height: 55,
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
              readOnly: widget.isReadOnly,
              cursorColor: widget.isError
                  ? Color(kErrorRed)
                  : widget.isCustomer
                      ? Color(kDarkRed)
                      : Color(kLightRed),
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: _buildSuffixIcon(),
                focusedBorder: InputBorder.none,
                hintText: widget.placeholder,
              ),
              onSaved: widget.onSaved,
              obscureText: _obscureText,
              style: theme.textTheme.headline4,
              maxLines: widget.maxLines,
              initialValue: widget.initialValue ?? "",
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/text_input_field.dart';
import '../widgets/text_link.dart';
import '../widgets/button.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  String email;
  Map<String, bool> errors;
  final _formKey = GlobalKey<FormState>();
  final validEmailCharacters = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    email = "";
    errors = {"email": false};
    super.initState();
  }

  String _validateTextInput(bool validator, String fieldName) {
    if (validator) {
      setState(() => errors[fieldName] = true);
      return 'Please enter a valid email';
    }
    setState(() => errors[fieldName] = false);
    return null;
  }

  List<Widget> _buildFormInput(BuildContext context) {
    return [
      TextInputField(
        fieldName: 'Email',
        onSaved: (input) => email = input,
        validator: (input) => _validateTextInput(
            (!validEmailCharacters.hasMatch(this.email) &&
                    this.email.isNotEmpty) ||
                this.email.isEmpty,
            "email"),
        isError: errors["email"],
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        placeholder: 'Enter your registered email',
        isCustomer: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(kDarkRed),
                Color(kLightRed),
              ],
              tileMode: TileMode.clamp),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'App Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Color(kDarkBrown),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ..._buildFormInput(context),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              child: TextLink(
                                                  text:
                                                      'Already have an account?',
                                                  onPress: () =>
                                                      Navigator.pop(context)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Button(
                                          text: 'Send Reset Password Link',
                                          onPress: () => {
                                            _formKey.currentState.save(),
                                            //TODO: check if can find in db, if cannot return error msg
                                            if (_formKey.currentState
                                                .validate())
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'send email after validation = can find in db'),
                                                  ),
                                                ),
                                              },
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

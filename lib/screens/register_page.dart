
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/text_input_field.dart';
import '../widgets/text_link.dart';
import '../widgets/button.dart';
import '../widgets/toggle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email, name, password, confirmedPassword, address;
  bool _isCustomer;
  Map<String, bool> errors;
  final _formKey = GlobalKey<FormState>();
  final validEmailCharacters = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final validNameCharacters = RegExp(r'^[a-zA-Z]+$');
  final validPasswordCharacters = RegExp(r'(?=.*\d)(?=.*[a-zA-Z])[a-zA-Z0-9]+');


  @override
  void initState() {
    email = "";
    name = "";
    password = "";
    confirmedPassword = "";
    // address = "";

    _isCustomer = false;
    errors = {
      "email": false,
      "name": false,
      "password": false,
      "confirmed password": false,
      // "address": false,
    };
    super.initState();
  }

  _toggleAccount() {
    setState(() => _isCustomer = !_isCustomer);
  }

  String _validateTextInput(bool validator, String fieldName) {
    // print('the in validatetextinput password: ' +
    //     this.password +
    //     ' and the confirmed password: ' +
    //     this.confirmedPassword);

    if (validator) {
      setState(() => errors[fieldName] = true);
      // if (name != 'address') {
      //   if (this.name.isEmpty) {
      //     return 'Please enter a valid ' + name;
      //   }
      // }
      switch (fieldName) {
        case 'email':
          return 'Please enter a valid email';
          break;
        case 'name':
          if (this.name.isEmpty)
            return 'Please enter a valid full name';
          else if (this.name.length > 30) {
            return 'Maximun characters: 30';
          } else if (!validNameCharacters.hasMatch(this.name)) {
            return 'Please enter letters only';
          }
          break;
        case 'password':
          if (this.password.isEmpty)
            return 'Please enter a valid password';
          else if (this.password.length < 8) {
            return 'Minimum characters: 8';
          } else if (!validPasswordCharacters.hasMatch(this.password)) {
            return 'Please enter at least 1 letter and number.';
          }
          break;
        case 'confirmed password':
          if (this.confirmedPassword.isEmpty)
            return 'Please enter a valid confirmed password';
          else if (this.confirmedPassword != this.password &&
              this.confirmedPassword.isNotEmpty &&
              this.password.isNotEmpty) {
            return 'Please enter the same password';
          }
          break;
      }
    }
    setState(() => errors[fieldName] = false);
    return null;
  }

  void signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (_isCustomer == true) {
        final User _user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .set({
          'username': name,
          'identity': "customer",
          'url':"https://firebasestorage.googleapis.com/v0/b/e-shop-ust.appspot.com/o/Usericon%2Fdefault_user_icon.jpg?alt=media&token=c1d6fa90-53d7-47f0-91e7-c09a8292638a",
        });
        await FirebaseFirestore.instance
            .collection('customer_users')
            .doc(_user.uid)
            .set({
          'address': "",
          'order': 0,
        });
      }
      else if  (_isCustomer == false) {
        final User _user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .set({
          'username': name,
          'identity': "business",
          'url':"https://firebasestorage.googleapis.com/v0/b/e-shop-ust.appspot.com/o/Usericon%2Fdefault_user_icon.jpg?alt=media&token=c1d6fa90-53d7-47f0-91e7-c09a8292638a",
        });
        await FirebaseFirestore.instance
            .collection('business_users')
            .doc(_user.uid)
            .set({
          'have_shop': "false",
        });
      }

      //jump to home page
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'weak-password') {
        // might remove this statement later
        print("The password provided is too weak.");
      } else if (authError.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (authError.code == 'invalid-email') {
        print("Please enter correct email");
      } else {
        print("Error code: " + authError.code);
      }
    } catch (e) {
      print('Failed to sign up - ' + e);
    }
  }

  List<Widget> _buildFormInput(BuildContext context, customer) {
    return [
      TextInputField(
        fieldName: 'Email',
        onSaved: (input) => email = input,
        validator: (input) => _validateTextInput(
            input.isEmpty || !validEmailCharacters.hasMatch(input), "email"),
        isError: errors["email"],
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        placeholder: 'Enter Email',
        isCustomer: customer,
      ),
      TextInputField(
        fieldName: 'Name',
        onSaved: (input) => name = input,
        validator: (input) => _validateTextInput(
            input.isEmpty || !validNameCharacters.hasMatch(input), "name"),
        isError: errors["name"],
        isRequired: true,
        keyboardType: TextInputType.name,
        placeholder: 'Enter Name',
        isCustomer: customer,
      ),
      TextInputField(
        fieldName: 'Password',
        onSaved: (input) => password = input,
        validator: (input) => _validateTextInput(
            input.isEmpty || !validPasswordCharacters.hasMatch(input),
            "password"),
        isObscureText: true,
        isError: errors["password"],
        isRequired: true,
        keyboardType: TextInputType.visiblePassword,
        placeholder: 'Enter Password',
        isCustomer: customer,
      ),
      TextInputField(
        fieldName: 'Confirmed Password',
        onSaved: (input) => confirmedPassword = input,
        validator: (input) => _validateTextInput(
            input.isEmpty || (input != this.password && input.isNotEmpty),
            "confirmed password"),
        isObscureText: true,
        isError: errors["confirmed password"],
        isRequired: true,
        keyboardType: TextInputType.visiblePassword,
        placeholder: 'Enter Password Again',
        isCustomer: customer,
      ),
      // customer
      //     ? TextInputField(
      //         fieldName: 'Address',
      //         onSaved: (input) => address = input,
      //         //change
      //         validator: (input) =>
      //             _validateTextInput(input.isEmpty, "address"),
      //         isError: errors["address"],
      //         keyboardType: TextInputType.streetAddress,
      //         placeholder: '(Optional) Enter address',
      //         isCustomer: customer,
      //       )
      //     : Container()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _isCustomer ? Color(kLightRed) : Color(kDarkRed)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Center(
                                child: Text(
                                  'App Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _isCustomer
                                        ? Color(kLightBrown)
                                        : Color(kDarkBrown),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'You are?',
                                        style: theme.textTheme.headline4
                                            .copyWith(
                                            color: _isCustomer
                                                ? Color(kLightBrown)
                                                : Color(kDarkBrown)),
                                      ),
                                      ToggleButton(
                                        options: ['Merchant', 'Customer'],
                                        onPress: () => _toggleAccount(),
                                        isCustomer: _isCustomer ?? false,
                                      )
                                    ],
                                  ),
                                  ..._buildFormInput(
                                      context, _isCustomer ?? false),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: TextLink(
                                        text: 'Already have an account?',
                                        onPress: () => Navigator.pop(context)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Button(
                                text: 'Register',
                                onPress: () => {
                                  _formKey.currentState.save(),
                                  //TODO: send the data to Firestore and create a document
                                  if (_formKey.currentState.validate())
                                    {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      signUp(email,password),
                                      /*ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Processing Data'))),*/
                                    },
                                  //Firebase function ends
                                  print('the password: ' +
                                      this.password +
                                      ' and the confirmed password: ' +
                                      this.confirmedPassword),
                                  print('the errors statue: ' +
                                      errors.toString()),
                                  print('the email: ' +
                                      _formKey.currentState
                                          .validate()
                                          .toString())
                                },
                                isCustomer: _isCustomer ?? false,
                              ),
                            ),
                            Button(
                              text: 'Reset',
                              onPress: () => {
                                print('clear'),
                                _formKey.currentState.reset(),
                              },
                              isCustomer: _isCustomer ?? false,
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
      ),
    );
  }
}

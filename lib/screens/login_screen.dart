
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/customer_home_screen.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/text_input_field.dart';
import '../widgets/text_link.dart';
import '../widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './forget_password_page.dart';
import './register_page.dart';
import 'business_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  Map<String, bool> errors;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    email = "";
    password = "";
    errors = {"email": false, "password": false};
    super.initState();
  }

  String _validateTextInput(bool validator, String name) {
    if (validator) {
      setState(() => errors[name] = true);
      return 'Please enter a valid ' + name;
    } else {
      setState(() => errors[name] = false);
      return null;
    }
  }

  void emailLogin(String email, String password) async {


    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var user = FirebaseAuth.instance.currentUser;
      print('the user uid ' + user.uid.toString());
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((event) {
            print('the identity ' + event.get('identity'));
        FirebaseFirestore.instance
            .collection('business_users')
            .doc(user.uid)
            .snapshots()
            .listen((event1) {
          if (event.get('identity') == 'customer') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerHomeScreen(
                      username: event.get('username'),
                    )));
          }else if (event1.get('have_shop') == 'true') {
            FirebaseFirestore.instance
            .collection('Shop')
            .where('owner' , isEqualTo: user.uid.toString())
            .snapshots()
            .listen((event2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BusinessHomeScreen(
                        username: event.get('username'),
                        email: event.get('email'),
                        hvShop: true,
                        iconUrl: 'assets/sample_product_image.png',
                        shopname: event2.docs.first.get('searchKeywords')['shop_name'],
                        category: event2.docs.first.get('category'),
                      )));
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BusinessHomeScreen(
                          username: event.get('username'),
                          email: event.get('email'),
                          hvShop: false,
                          iconUrl: 'assets/sample_product_image.png',
                        )));
          }
        });

      });
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'user-not-found' ||
          authError.code == 'wrong-password') {
        print("Invalid email or password.");
      } else {
        print(
            "Error code: ${authError.code}\nError message: ${authError.message}");
      }
    }
  }

  List<Widget> _buildFormInput(BuildContext context) {
    return [
      TextInputField(
        fieldName: 'Email',
        onSaved: (input) => email = input,
        validator: (input) => _validateTextInput(input.isEmpty, "email"),
        isError: errors["email"],
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        placeholder: 'Enter Email',
        isCustomer: false,
      ),
      TextInputField(
        fieldName: 'Password',
        onSaved: (input) => password = input,
        validator: (input) => _validateTextInput(input.isEmpty, "password"),
        isObscureText: true,
        isError: errors["password"],
        isRequired: true,
        keyboardType: TextInputType.visiblePassword,
        placeholder: 'Enter Password',
        isCustomer: false,
      )
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
                flex: 9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'App Name',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Color(kDarkBrown),
                              ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ..._buildFormInput(context),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: TextLink(
                                          text: 'Forget password?',
                                          onPress: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgetPasswordPage()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Button(
                                text: 'Login',
                                onPress: () => {
                                  //check the user input state
                                  _formKey.currentState.save(),
                                  //TODO: validate email and pw in Firebase, if fail then show error message
                                  if (_formKey.currentState.validate())
                                    {
                                      emailLogin(email, password),

                                      /*ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Jump to a right home page')))*/
                                    }
                                  //Firebase function ends
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextLink(
                text: 'Don\'t have an account? Register >>',
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

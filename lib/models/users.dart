

import 'package:flutter/material.dart';

class Users {
  const Users({
    @required this.username,
    @required this.iconUrl,
    @required this.email,
    @required this.fullname,
    @required this.password,
    @required this.accountIsCustomer,
    this.hvShop,
  });

  final String username;
  final String iconUrl;
  final String email;
  final String fullname;
  final String password;
  final bool accountIsCustomer;
  final bool hvShop;
}

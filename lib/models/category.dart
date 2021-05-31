

import 'package:flutter/material.dart';

//type: both, product, shop
class Category {
  const Category({
    @required this.name,
    @required this.type,
    this.icon,
  });

  final String name;
  final String type;
  final IconData icon;
}

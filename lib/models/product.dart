

import 'package:flutter/material.dart';

class Product {
  const Product({
    @required this.name,
    @required this.imagesUrl,
    @required this.rating,
    @required this.statusTagText,
    @required this.quantityLeft,
    @required this.totalQuantity,
    @required this.category,
    @required this.price,
    this.shopName,
    this.isInCart: false,
    this.isVisible: false,
    this.orderQuantity: 0,
    @required this.description,
  });

  final String name;
  final List imagesUrl;
  final double rating;
  final String statusTagText;
  final int quantityLeft;
  final int totalQuantity;
  final String category;
  final double price;
  final String shopName;
  final bool isInCart;
  final bool isVisible;
  final int orderQuantity;
  final String description;
}

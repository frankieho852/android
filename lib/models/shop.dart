
import 'package:flutter/material.dart';

class Shop {
  const Shop({
    @required this.name,
    @required this.owner,
    this.imageUrl,
    this.rating,
    @required this.category,
    this.isSubscribed: false,
    @required this.shortDescription,
    @required this.longDescription,
    this.phone,
    @required this.email,
    @required this.payments,
    this.products,
    this.comments,
  });

  final String name;
  final Map<dynamic, dynamic> owner;
  final String imageUrl;
  final double rating;
  final String category;
  final bool isSubscribed;
  final String shortDescription;
  final String longDescription;
  final String phone;
  final String email;
  final Map<String, String> payments;
  final List<Object> products;
  final List<String> comments;
}

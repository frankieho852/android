

import '../models/category.dart';
import 'package:flutter/material.dart';

Category _category1 = Category(name: "Category 1", type: "both");

Category _category2 = Category(name: "Category 2", type: "both");

Category _sports = Category(
  name: "Sports",
  type: "both",
  icon: Icons.sports_football_rounded,
);

Category _music = Category(
  name: "Music",
  type: "shop",
  icon: Icons.library_music_rounded,
);

Category _kitchen = Category(
  name: "Kitchen",
  type: "product",
  icon: Icons.rice_bowl_rounded,
);

List<Category> categoryData = [
  _category1,
  _category2,
  _sports,
  _music,
  _kitchen,
];

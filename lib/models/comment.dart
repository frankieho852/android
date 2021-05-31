
import 'package:flutter/material.dart';

class Comment {
  const Comment({
    @required this.username,
    @required this.userIconUrl,
    @required this.rating,
    @required this.content,
  });

  final String username;
  final String userIconUrl;
  final double rating;
  final String content;
}

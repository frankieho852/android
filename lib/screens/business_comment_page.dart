

import 'package:flutter/material.dart';

import 'package:online_shopping_4521/theme/colors.dart';
import '../widgets/custom_app_bar.dart';

import 'package:online_shopping_4521/widgets/comment_tile.dart';

class BusinessCommentPage extends StatelessWidget {
  final List comments;

  BusinessCommentPage({Key key, @required this.comments}) : super(key: key);

  Widget _buildComment(data, context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width - 32, //calculate the width of screen - padding
      child: CommentTile(
        username: data.username,
        userIconURL: data.userIconUrl,
        content: data.content,
        rating: data.rating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Comment",
          hasBack: true,
          isCustomer: false,
        ),
        backgroundColor: Color(kDarkRed),
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: this.comments.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildComment(this.comments[index], context),
          ),
        ),
      ),
    );
  }
}

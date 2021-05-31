
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentTile extends StatelessWidget {
  final String username;
  final String userIconURL;
  final String content;
  final double rating;

  @override
  CommentTile({
    Key key,
    @required this.username,
    @required this.userIconURL,
    @required this.content,
    @required this.rating,
  }) : super(key: key);

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(this.userIconURL),
          radius: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.username,
                style: theme.textTheme.headline4.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              RatingBarIndicator(
                rating: this.rating,
                itemBuilder: (context, index) =>
                    Icon(Icons.star, color: Color(kYellow)),
                itemCount: 5,
                itemSize: 24,
                unratedColor: Color(0xFFC4C4C4),
                direction: Axis.horizontal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: Color(kWhite),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            Text(
              this.content,
              style: theme.textTheme.headline5,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

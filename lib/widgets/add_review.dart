
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping_4521/theme/colors.dart';

class AddReview extends StatefulWidget {
  final Function(String, double) onPress;

  @override
  AddReview({
    Key key,
    @required this.onPress,
  }) : super(key: key);

  @override
  _AddReview createState() => _AddReview();
}

class _AddReview extends State<AddReview> {
  double _rating;
  String _comment;

  @override
  void initState() {
    super.initState();
    _rating = 0;
    _comment = "";
  }

  Widget _buildRating() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rating",
            style: Theme.of(context).textTheme.headline4,
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemSize: 32,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Color(kYellow),
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
              print("current rating: " + rating.toString());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.0),
        ),
      ),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        width: width - 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildRating(),
            Divider(
              color: Color(0xffc4c4c4),
              height: 4.0,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onChanged: (input) => _comment = input,
                cursorColor: Color(kDarkRed),
                style: Theme.of(context).textTheme.headline5,
                maxLength: 270,
                decoration: InputDecoration(
                  hintText: "Type Your Comment...",
                  border: InputBorder.none,
                ),
                maxLines: 9,
              ),
            ),
            InkWell(
              onTap: () {
                if (_rating != 0) {
                  widget.onPress(_comment, _rating);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Color(kLightRed),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7.0),
                    bottomRight: Radius.circular(7.0),
                  ),
                ),
                child: Text(
                  "Comment!",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Color(kLightBrown),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

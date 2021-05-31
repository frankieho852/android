
import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShopCard extends StatelessWidget {
  final String iconUrl;
  final String shopName;
  final double rating;
  final String category;
  final String shortDescription;
  final Function onPress;
  final bool isSubscribed;

  ShopCard({
    Key key,
    @required this.shopName,
    @required this.category,
    @required this.onPress,
    @required this.shortDescription,
    this.iconUrl: 'assets/default_product_image.png',
    this.rating: 0.0,
    this.isSubscribed: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(kBlack),
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    //TODO: change the way to get Firebase image
                    backgroundImage: AssetImage(this.iconUrl),
                    radius: 60,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.shopName,
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Color(kWhite),
                                    ),
                            overflow: TextOverflow.ellipsis,
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
                          Text(
                            this.category,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 1.5,
                                      fontSize: 20,
                                      color: Color(kWhite),
                                    ),
                          ),
                          Text(
                            this.shortDescription,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Color(kWhite),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  isSubscribed
                      ? Icons.unsubscribe_rounded
                      : Icons.email_rounded,
                  color: Color(kWhite),
                ),
                padding: EdgeInsets.all(0),
                onPressed: () => {
                  //TODO: ref. to customer shop detail page subscribe function
                  print("subscribe, send to db")
                  //Firebase function ends
                },
                splashColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:online_shopping_4521/screens/customer_payment_page.dart';
import 'package:online_shopping_4521/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping_4521/widgets/status_tag.dart';

import 'button.dart';

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(kWhite),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/default_product_image150.png'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The product name',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'The shop name',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'The description',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        RatingBarIndicator(
                          rating: 4,
                          itemBuilder: (context, index) =>
                              Icon(Icons.star, color: Color(kYellow)),
                          itemCount: 5,
                          itemSize: 18,
                          unratedColor: Color(0xFFC4C4C4),
                          direction: Axis.horizontal,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: StatusTag(text: 'this.statusTagText'),
                        ),
                        Text(
                          'this.category',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                decorationThickness: 1.5,
                              ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'this.quenity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    decorationThickness: 1.5,
                                  ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              'Total HKD ' + '550',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

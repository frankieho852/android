
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool hasBack;
  final bool isCustomer;
  final Widget bottom;

  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? 90 : 55);

  const CustomAppBar({
    Key key,
    @required this.title,
    this.actions,
    this.hasBack: false,
    this.isCustomer: true,
    this.bottom,
  }) : super(key: key);

  Widget _buildLeading(BuildContext context) {
    return hasBack
        ? Container(
            child: IconButton(
              iconSize: 50,
              padding: const EdgeInsets.all(0),
              icon: Icon(Icons.arrow_left_rounded),
              color: isCustomer ? Color(kLightRed) : Color(kDarkRed),
              focusColor: isCustomer ? Color(kDarkRed) : Color(kLightRed),
              highlightColor: isCustomer ? Color(kDarkRed) : Color(kLightRed),
              hoverColor: isCustomer ? Color(kDarkRed) : Color(kLightRed),
              splashColor: Colors.transparent,
              onPressed: () => Navigator.pop(context),
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      leading: _buildLeading(context),
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: theme.textTheme.headline3.copyWith(
          color: isCustomer ? Color(kDarkBrown) : Color(kLightBrown),
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
      backgroundColor: isCustomer ? Color(kDarkRed) : Color(kLightRed),
      centerTitle: false,
      bottom: bottom ?? null,
    );
  }
}

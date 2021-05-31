
import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class NavBar extends StatelessWidget {
  NavBar({
    @required this.selectedIndex,
    this.isCustomer: true,
  });

  final int selectedIndex;
  final bool isCustomer;

  Map<String, IconData> _getTabs(BuildContext context, customer) {
    return customer
        ? {
            'home': Icons.dashboard_rounded,
            'search': Icons.search_rounded,
            'browse': Icons.shopping_basket_rounded,
            'account': Icons.account_circle_rounded
          }
        : {
            'home': Icons.dashboard_rounded,
            'shop': Icons.store_rounded,
            'product': Icons.local_offer_rounded,
            'account': Icons.account_circle_rounded
          };
  }

  void _onTabTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        isCustomer
            ? Navigator.pushNamed(context, '/c_home')
            : Navigator.pushNamed(context, '/b_home');
        break;
      case 1:
        isCustomer
            ? Navigator.pushNamed(context, '/c_search')
            : Navigator.pushNamed(context, '/b_shop');
        break;
      case 2:
        isCustomer
            ? Navigator.pushNamed(context, '/c_browse')
            : Navigator.pushNamed(context, '/b_product');
        break;
      case 3:
        isCustomer
            ? Navigator.pushNamed(context, '/c_account')
            : Navigator.pushNamed(context, '/b_account');
        break;
    }
  }

  List<BottomNavigationBarItem> _buildNavBarItems(BuildContext context) {
    final List<BottomNavigationBarItem> navBarItems = List();
    _getTabs(context, isCustomer).forEach(
      (iconName, iconData) {
        navBarItems.add(
          BottomNavigationBarItem(
            icon: Icon(
              iconData,
            ),
            label: iconName.toUpperCase(),
          ),
        );
      },
    );
    return navBarItems;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: isCustomer ? Color(kDarkRed) : Color(kLightRed),
      type: BottomNavigationBarType.fixed,
      items: _buildNavBarItems(context),
      currentIndex: selectedIndex,
      selectedLabelStyle: TextStyle(
        shadows: [
          Shadow(
            color: Color(kLightBrown),
            blurRadius: 30.0,
            offset: Offset(0, 5.0),
          ),
          Shadow(
            color: Color(kLightBrown),
            blurRadius: 30.0,
            offset: Offset(0, 5.0),
          ),
          Shadow(
            color: Color(kLightBrown),
            blurRadius: 30.0,
            offset: Offset(15.0, 10.0),
          ),
          Shadow(
            color: Color(kLightBrown),
            blurRadius: 30.0,
            offset: Offset(-15.0, 10.0),
          ),
        ],
      ),
      selectedItemColor: isCustomer ? Color(kLightRed) : Color(kDarkRed),
      unselectedItemColor: Color(kBlack),
      onTap: (int index) {
        _onTabTapped(index, context);
      },
      elevation: 0,
    );
  }
}

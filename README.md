# online_shopping android application in HKUST-COMP4521

Theme & color of the project: lib > theme

Screens of the project: lib > screens

Assets(widgets) of the project: lib > widgets

## Add routes in main.dart, export screen in screens.dart

### Tips:

1. Naming of page(by push)/screen(directly access in nav bar) files:

accountType_page/screenName_page/screen.dart
e.g. customer_browse_screen, business_edit_account_page

2. Naming of widgets/screens:

start with Uppercase
e.g. CustomerBrowseScreen

3. Naming of variable:

start with lowercase, then by Uppercase, don't include _ between words, _ is for local variable (=without final)
e.g. finalVariable, \_localVariable

4. Don't use this. in stateful widget

initialize final variables as @required in class of that widget/screen e.g. customer_product_detail_page.dart

5. Adjust Text style

6. isCustomer variable default set to true in different widgets, no need to specify it in customer page development

7. use Dialog box: https://api.flutter.dev/flutter/material/AlertDialog-class.html

8. upload image to Firebase: https://www.youtube.com/watch?v=HCmAwk2fnZc

##

Useful icons:

1. Direction:

- chevron_left_rounded
- chevron_right_rounded

2. Drop down:

- arrow_drop_down_rounded
- arrow_drop_up_rounded

3. Nav bar icon:

- dashboard_rounded
- attribution_rounded
- category_rounded
- contacts_rounded

4. Category:

- child_friendly_rounded
- cleaning_services_rounded
- construction_rounded
- eco_rounded

5. Others:

- backpack_rounded
- beenhere_rounded
- contact_support_rounded
- create_rounded
- delete_rounded
- add_shopping_cart_rounded
- remove_shopping_cart_rounded
- star_rounded
- star_outline_rounded

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

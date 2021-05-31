
import '../models/shop.dart';

Shop _shop1 = Shop(
  name: "Shop 1",
  rating: 3.8,
  category: "Category 2",
  shortDescription: "very short.",
  longDescription:
      "A longer description hahaha. testing... write longer ahhhhhhhhhhhhhh",
  email: "business@gmail.com",
  payments: {
    "PayMe": "http://www.googlejustfortesting.com",
    "Payment 2": "12345678"
  },
  phone: '12345678',
  imageUrl:
      "/data/user/0/com.example.online_shopping_4521/app_flutter/shopAvatar.png",
  owner: {
    "username": "business",
    "iconUrl": "assets/default_avatar.png",
    "email": "business@gmail.com",
    "fullname": "haha testing"
  },
);

Shop _shop2 = Shop(
  name: "Shop 2",
  category: "Category 2",
  shortDescription: "very short 2 .",
  longDescription:
      "A longer description 2 hahaha. testing... write longer ahhhhhhhhhhhhhh",
  email: "testing@email.com",
  payments: {"PayMe": "image link"},
  isSubscribed: true,
  imageUrl: "assets/default_avatar.png",
  owner: {
    "username": "business 2",
    "iconUrl": "assets/default_avatar.png",
    "email": "business2@gmail.com",
    "fullname": "hoho testing"
  },
);

Shop _shop3 = Shop(
  name: "Shop 3",
  category: "Sports",
  shortDescription: "very short 3 .",
  longDescription:
      "A longer description 3 hahaha. testing... write longer ahhhhhhhhhhhhhh",
  email: "testing3@email.com",
  payments: {"PayMe": "image link"},
  isSubscribed: true,
  imageUrl: "assets/default_avatar.png",
  owner: {
    "username": "business 3",
    "iconUrl": "assets/default_avatar.png",
    "email": "business3@gmail.com",
    "fullname": "hehe testing"
  },
);

List<Shop> shopData = [
  _shop1,
  _shop2,
  _shop3,
];

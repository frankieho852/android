

import '../models/users.dart';

Users _user1 = Users(
  username: "customer hahahah hohoho",
  iconUrl: 'assets/default_avatar.png',
  email: "customer@gmail.com",
  fullname: "testing haha",
  password: "haha123@CUS",
  accountIsCustomer: true,
);

Users _user2 = Users(
  username: "business",
  iconUrl: 'assets/default_avatar.png',
  email: "business@gmail.com",
  fullname: "haha testing",
  password: "haha123@BUS",
  hvShop: false,
  accountIsCustomer: false,
);

Users _user3 = Users(
  username: "business",
  iconUrl: 'assets/default_avatar.png',
  email: "business@gmail.com",
  fullname: "haha testing",
  password: "haha123@BUS",
  hvShop: true,
  accountIsCustomer: false,
);

Users _user4 = Users(
  username: "business 2",
  iconUrl: 'assets/default_avatar.png',
  email: "business2@gmail.com",
  fullname: "hoho testing",
  password: "hoho123@BUS",
  hvShop: true,
  accountIsCustomer: false,
);

Users _user5 = Users(
  username: "business 3",
  iconUrl: 'assets/default_avatar.png',
  email: "business3@gmail.com",
  fullname: "hehe testing",
  password: "hehe123@BUS",
  hvShop: true,
  accountIsCustomer: false,
);

List<Users> userData = [
  _user1,
  _user2,
  _user3,
  _user4,
  _user5,
];

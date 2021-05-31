
import '../models/comment.dart';

Comment _comment1 = Comment(
  username: "testing 1",
  rating: 3.8,
  userIconUrl: 'assets/default_product_image30.png',
  content:
      "A longer comment hahaha. testing... write longer ahhhhhhhhhhhhhh jdsfakljfdl;ncdja testing djsfakla;lkcaslck;a fasjafajl;swioaj hello dkjfalaocmal",
);

Comment _comment2 = Comment(
  username: "testing 2",
  rating: 2.6,
  userIconUrl: 'assets/default_product_image30.png',
  content:
      "Another longer comment hahaha. testing... write longer ahhhhhhhhhhhhhh",
);

Comment _comment3 = Comment(
  username: "user 3",
  rating: 4.5,
  userIconUrl: 'assets/default_product_image30.png',
  content: "Good ah!",
);

List<Comment> commentData = [
  _comment1,
  _comment2,
  _comment3,
];

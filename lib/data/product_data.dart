

import '../models/product.dart';

Product _product1 = Product(
    category: "Category 1",
    name: "Product 1",
    shopName: 'testing 1',
    price: 10.3,
    rating: 4.2,
    statusTagText: "Still have a lot",
    quantityLeft: 10,
    totalQuantity: 10,
    imagesUrl: [
      'assets/default_add_product_image.png',
      'assets/sample_product_image.png',
      'assets/sample_product_image.png',
      'assets/sample_product_image.png'
    ],
    isVisible: true,
    description:
        "A description hahaha. testing... write longer ahhhhhhhhhhhhhh");

Product _product2 = Product(
  category: "Category 2",
  name: "Product 2",
  shopName: 'testing 1',
  price: 4.3,
  rating: 2.2,
  statusTagText: "Sold Out",
  quantityLeft: 0,
  totalQuantity: 3,
  imagesUrl: [
    'assets/sample_product_image.png',
    'assets/default_add_product_image.png',
    'assets/sample_product_image.png',
    'assets/sample_product_image.png'
  ],
  isInCart: true,
  isVisible: true,
  orderQuantity: 3,
  description: "A shorter description",
);

Product _product3 = Product(
  category: "Sports",
  name: "Product 3",
  shopName: 'testing 1',
  price: 4.3,
  rating: 2.2,
  statusTagText: "Still have a lot",
  quantityLeft: 20,
  totalQuantity: 20,
  imagesUrl: [
    'assets/default_add_product_image.png',
    'assets/sample_product_image.png',
    'assets/sample_product_image.png',
    'assets/sample_product_image.png'
  ],
  isInCart: true,
  isVisible: true,
  description: "A shorter description",
);

Product _product4 = Product(
  category: "Sports",
  name: "Product 4",
  shopName: 'testing 1',
  price: 7,
  rating: 4,
  statusTagText: "Sold Out",
  quantityLeft: 4,
  totalQuantity: 10,
  imagesUrl: [
    'assets/sample_product_image.png',
    'assets/default_add_product_image.png',
    'assets/sample_product_image.png',
    'assets/sample_product_image.png'
  ],
  isInCart: true,
  isVisible: true,
  orderQuantity: 6,
  description: "A shorter description",
);

List<Product> productData = [
  _product1,
  _product2,
  _product3,
  _product4,
  _product2,
  _product1,
  _product2,
];

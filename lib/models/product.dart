import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String userId;
  String title;
  int stock;
  int price;
  String unit;
  String category;
  String description;
  String image;
  Timestamp createdAt;
  Timestamp updatedAt;

  Product();

  Product.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    userId = data['userId'];
    title = data['title'];
    stock = data['stock'];
    price = data['price'];
    unit = data['unit'];
    category = data['category'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'stock': stock,
      'price': price,
      'unit': unit,
      'category': category,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

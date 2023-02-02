import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  // String id = '';
  String name = '';
  String price = '';
  String category = '';

  Item.fromMap(Map<String, dynamic> data) {
    // id = data['id'];
    name = data['name'];
    price = data['price'];
    category = data['category'];
  }
}

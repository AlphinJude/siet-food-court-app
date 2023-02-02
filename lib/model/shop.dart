import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  // String id = '';
  String name = '';
  String displayName = '';
  String slogan = '';
  List<String> categories = [];

  Shop.fromMap(Map<String, dynamic> data) {
    // id = data['id'];
    name = data['name'];
    displayName = data['displayName'];
    slogan = data['slogan'];
    categories = List.from(data['categories']);

    print(categories);
  }
}

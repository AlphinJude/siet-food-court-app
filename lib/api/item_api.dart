import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_court/model/item.dart';
import 'package:food_court/notifier/item_notifier.dart';

getItems(ItemNotifier itemNotifier, String shop) async {
  List<Item> _itemList = [];

  FirebaseFirestore.instance
      .collection('shops/' + shop + '/menu')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      Item item = Item.fromMap(doc.data()! as Map<String, dynamic>);
      _itemList.add(item);
      itemNotifier.itemList = _itemList;
    });
  });
}

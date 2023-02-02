import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_court/model/shop.dart';
import 'package:food_court/notifier/shop_notifier.dart';

getShops(ShopNotifier shopNotifier) async {
  List<Shop> _shopList = [];

  FirebaseFirestore.instance
      .collection('shops')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      // print('Has reached this far');
      Shop shop = Shop.fromMap(doc.data()! as Map<String, dynamic>);
      _shopList.add(shop);
      // print(_shopList.toString());
      shopNotifier.shopList = _shopList;
    });
  });
}

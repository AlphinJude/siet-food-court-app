import 'dart:collection';
import 'package:flutter/material.dart';
import '/model/shop.dart';

class ShopNotifier with ChangeNotifier {
  List<Shop> _shopList = [];
  late Shop _currentShop;

  UnmodifiableListView<Shop> get shopList => UnmodifiableListView(_shopList);

  Shop get currentShop => _currentShop;

  set shopList(List<Shop> shopList) {
    _shopList = shopList;
    notifyListeners();
  }

  set currentFood(Shop shop) {
    _currentShop = shop;
    notifyListeners();
  }
}

import 'dart:collection';
import 'package:flutter/material.dart';
import '/model/item.dart';

class CartNotifier with ChangeNotifier {
  // List<Item> _itemList = [];
  late Item _currentItem;
  Map<Item, int> _itemList = {};
  double _total = 0.00;

  UnmodifiableListView<Item> get itemList =>
      UnmodifiableListView(_itemList.keys);

  Item get currentItem => _currentItem;

  int? getItemCount(Item item) {
    if (_itemList.containsKey(item)) {
      return _itemList[item] != null ? _itemList[item] : 0;
    } else
      return 0;
  }

  get length {
    return _itemList.length;
  }

  get allItems {
    return _itemList;
  }

  get total {
    return _total;
  }

  void addToCart(Item item) {
    if (_itemList.containsKey(item)) {
      _itemList.update(item, (value) => value + 1);
    } else
      _itemList.putIfAbsent(item, () => 1);

    _total += double.parse(item.price);
    notifyListeners();
  }

  void removeFromCart(Item item) {
    if (_itemList.containsKey(item)) {
      if (_itemList[item] == 1)
        _itemList.remove(item);
      else
        _itemList.update(item, (value) => value - 1);
    }

    _total -= double.parse(item.price);
    notifyListeners();
  }
}

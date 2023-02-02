import 'dart:collection';
import 'package:flutter/material.dart';
import '/model/item.dart';

class ItemNotifier with ChangeNotifier {
  List<Item> _itemList = [];
  late Item _currentItem;

  UnmodifiableListView<Item> get itemList => UnmodifiableListView(_itemList);

  Item get currentItem => _currentItem;

  set itemList(List<Item> itemList) {
    _itemList = itemList;
    notifyListeners();
  }

  set currentFood(Item item) {
    _currentItem = item;
    notifyListeners();
  }
}

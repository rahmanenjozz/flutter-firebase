import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:pertanian/models/product.dart';

class ProductNotifier with ChangeNotifier {
  List<Product> _productList = [];
  Product _currentProduct;

  UnmodifiableListView<Product> get productList =>
      UnmodifiableListView(_productList);

  Product get currentProduct => _currentProduct;

  set productList(List<Product> productList) {
    _productList = productList;
    notifyListeners();
  }

  set currentProduct(Product product) {
    _currentProduct = product;
    notifyListeners();
  }

  addProduct(Product product) {
    _productList.insert(0, product);
    notifyListeners();
  }

  deleteProduct(Product product) {
    _productList.removeWhere((_product) => _product.id == product.id);
    notifyListeners();
  }
}

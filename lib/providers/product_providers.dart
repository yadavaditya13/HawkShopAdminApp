import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  List<String> selectedColors = [];

  addColors(String color){
    selectedColors.add(color);
    notifyListeners();
  }

  removeColor(String color){
    selectedColors.remove(color);
    notifyListeners();
  }
}
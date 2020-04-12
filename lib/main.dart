 import 'package:flutter/material.dart';
import 'package:hawkshopadmin/providers/app_states.dart';
import 'package:hawkshopadmin/providers/product_providers.dart';
import 'package:hawkshopadmin/screen/dashboard.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppState()),
      ChangeNotifierProvider.value(value: ProductProvider()),
    ],
    child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
    ),
  ));
}
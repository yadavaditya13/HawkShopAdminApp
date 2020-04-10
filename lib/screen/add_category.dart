import 'package:flutter/material.dart';
import 'package:hawkshopadmin/database/category.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  TextEditingController categoryController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blueGrey,
        leading: FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Add Categories",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AlertDialog(
        content: Form(
          key: _categoryFormKey,
          child: TextFormField(
            controller: categoryController,
            // ignore: missing_return
            validator: (value) {
              if (value.isEmpty) {
                // ignore: missing_return
                return "Category cannot be Empty";
              }
            },
            decoration: InputDecoration(hintText: "Add Category"),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (categoryController.text != null) {
                  _categoryService.createCategory(categoryController.text);
                }
                Fluttertoast.showToast(msg: "Category Created");
                Navigator.pop(context);
              },
              child: Text("ADD")),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCEL")),
        ],
      ),
    );
  }
}

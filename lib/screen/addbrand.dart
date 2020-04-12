import 'package:flutter/material.dart';
import 'package:hawkshopadmin/database/brand.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBrand extends StatefulWidget {
  @override
  _AddBrandState createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {

  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();

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
          "Add Brand",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AlertDialog(
        content: Form(
          key: brandFormKey,
          child: TextFormField(
            controller: brandController,
            // ignore: missing_return
            validator: (value) {
              if (value.isEmpty) {
                // ignore: missing_return
                return "Brand cannot be Empty";
              }
            },
            decoration: InputDecoration(hintText: "Add Brand"),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (brandController.text != null) {
                  _brandService.createBrand(brandController.text);
                }
                Fluttertoast.showToast(msg: "Brand Created");
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

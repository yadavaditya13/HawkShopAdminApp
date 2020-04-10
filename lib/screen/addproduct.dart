import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawkshopadmin/database/product.dart';
import 'package:hawkshopadmin/providers/product_providers.dart';
import '../database/category.dart';
import '../database/brand.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final priceController = TextEditingController();

  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];

  String _currentCategory;
  String _currentBrand;

  Color white = Colors.white70;
  Color black = Colors.black45;
  Color grey = Colors.grey;
  Color red = Colors.redAccent;

  List<String> selectedSizes = <String>[];
  List<String> colors = <String>[];

  File _image1;

  bool isLoading = false;
  bool onSale = false;
  bool featured = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = List();

    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = List();

    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(brands[i].data['brand']),
              value: brands[i].data['brand'],
            ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
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
          "Add Product",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? Center(child: CircularProgressIndicator(backgroundColor: Colors.black45,))
              : Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120.0,
                              child: OutlineButton(
                                borderSide:
                                    BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                                onPressed: () {
                                  _selectedImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      );
                                },
                                child: _displayChild1()),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Product Name:",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: red, fontSize: 12),
                      ),
                    ),

                    Text('Available Colors'),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              if(productProvider.selectedColors.contains('red')){
                                productProvider.removeColor('red');
                              }
                              else{
                                productProvider.addColors('red');
                              }
                              setState(() {
                                colors = productProvider.selectedColors;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: productProvider.selectedColors.contains('red') ? Colors.blue : grey,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              if(productProvider.selectedColors.contains('yellow')){
                                productProvider.removeColor('yellow');
                              }
                              else{
                                productProvider.addColors('yellow');
                              }
                              setState(() {
                                colors = productProvider.selectedColors;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: productProvider.selectedColors.contains('yellow') ? red : grey,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.yellow,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              if(productProvider.selectedColors.contains('blue')){
                                productProvider.removeColor('blue');
                              }
                              else{
                                productProvider.addColors('blue');
                              }
                              setState(() {
                                colors = productProvider.selectedColors;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: productProvider.selectedColors.contains('blue') ? red : grey,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              if(productProvider.selectedColors.contains('green')){
                                productProvider.removeColor('green');
                              }
                              else{
                                productProvider.addColors('green');
                              }
                              setState(() {
                                colors = productProvider.selectedColors;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: productProvider.selectedColors.contains('green') ? red : grey,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              if(productProvider.selectedColors.contains('white')){
                                productProvider.removeColor('white');
                              }
                              else{
                                productProvider.addColors('white');
                              }
                              setState(() {
                                colors = productProvider.selectedColors;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: productProvider.selectedColors.contains('white') ? red : grey,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              if(productProvider.selectedColors.contains('black')){
                                productProvider.removeColor('black');
                              }
                              else{
                                productProvider.addColors('black');
                              }
                              setState(() {
                                colors = productProvider.selectedColors;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: productProvider.selectedColors.contains('black') ? red : grey,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text("Available Sizes"),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: selectedSizes.contains('XS'),
                          onChanged: (value) => changeSelectedSize('XS'),
                        ),
                        Text('XS'),
                        Checkbox(
                          value: selectedSizes.contains('S'),
                          onChanged: (value) => changeSelectedSize('S'),
                        ),
                        Text('S'),
                        Checkbox(
                          value: selectedSizes.contains('M'),
                          onChanged: (value) => changeSelectedSize('M'),
                        ),
                        Text('M'),
                        Checkbox(
                          value: selectedSizes.contains('L'),
                          onChanged: (value) => changeSelectedSize('L'),
                        ),
                        Text('L'),
                        Checkbox(
                          value: selectedSizes.contains('XL'),
                          onChanged: (value) => changeSelectedSize('XL'),
                        ),
                        Text('XL'),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('Sale'),
                            SizedBox(width: 10,),
                            Switch(value: onSale, onChanged: (value){
                              setState(() {
                                onSale = value;
                              });
                            }),
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Text('Featured'),
                            SizedBox(width: 10,),
                            Switch(value: featured, onChanged: (value){
                              setState(() {
                                featured = value;
                              });
                            }),
                          ],
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(hintText: 'Producr Name'),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return "Product Name Field is Empty!!!";
                          // ignore: missing_return
                          }
                          else if(value.length > 10){
                            return "Product Nmae must not exceed 10 characters!!!";
                          }
                        },
                      ),
                    ),

                    // select category
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Category:',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                        ),
// select brand
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Brand:',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: brandsDropDown,
                          onChanged: changeSelectedBrand,
                          value: _currentBrand,
                        ),
                      ],
                    ),
//
                    // quantity
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Quantity",
                        ),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the Product Quantity!!!";
                            // ignore: missing_return
                          }
                        },
                      ),
                    ),

                    //product price
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Price",
                        ),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the Product Price!!!";
                            // ignore: missing_return
                          }
                        },
                      ),
                    ),

                    FlatButton(
                        color: black,
                        textColor: white,
                        onPressed: () {
                          validateAndUpload();
                        },
                        child: Text('Add Product')),
                  ],
                ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0].data['brand'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectedImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() => _image1 = tempImg);
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null) {
        if (selectedSizes.isNotEmpty) {
          String imageUrl1;

          final FirebaseStorage storage = FirebaseStorage.instance;

          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
              storage.ref().child(picture1).putFile(_image1);

          StorageTaskSnapshot snapshot1 =
              await task1.onComplete.then((snapshot) => snapshot);

          task1.onComplete.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();

            _productService.uploadProduct({
              "name":productNameController.text,
              "price":double.parse(priceController.text),
              "sizes":selectedSizes,
              "colors": colors,
              "picture":imageUrl1,
              "quantity":int.parse(quantityController.text),
              "brand":_currentBrand,
              "category":_currentCategory,
              'sale':onSale,
              'featured':featured
            });
            _formKey.currentState.reset();
            setState(() => isLoading = false);
            Fluttertoast.showToast(msg: 'Product Added!');
            Navigator.pop(context);
          });
        } else {
          setState(() => isLoading = false);
          Fluttertoast.showToast(msg: 'Select a size!');
        }
      } else {
        setState(() => isLoading = false);
      }
    }
  }
}

//*************** Implementing flutter typehead :***************

//            Visibility(
//              visible: _currentBrand != null,
//              child: InkWell(
//                child: Material(
//                  borderRadius: BorderRadius.circular(20),
//                  color: black,
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Row(
//                      children: <Widget>[
//                        Expanded(
//                            child: Text(
//                              _currentBrand ?? '',
//                              style: TextStyle(color: white),
//                            )),
//                        IconButton(
//                            icon: Icon(
//                              Icons.close,
//                              color: white,
//                            ),
//                            onPressed: () {
//                              setState(() {
//                                _currentBrand = '';
//                              });
//                            })
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
//
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TypeAheadField(
//                textFieldConfiguration: TextFieldConfiguration(
//                    autofocus: false,
//                    decoration: InputDecoration(
//                      hintText: 'Add Brand',
//                      //border: OutlineInputBorder()
//                    )),
//                suggestionsCallback: (pattern) async {
//                  return await _brandService.getSuggestions(pattern);
//                },
//                itemBuilder: (context, suggestion) {
//                  return ListTile(
//                    leading: Icon(Icons.category),
//                    title: Text(suggestion['brand']),
//                    // subtitle: Text('\$${suggestion['price']}'),
//                  );
//                },
//                onSuggestionSelected: (suggestion) {
//                  setState(() {
//                    _currentBrand = suggestion['brand'];
//                  });
//                },
//              ),
//            ),

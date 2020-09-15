import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pertanian/api/product_api.dart';
import 'package:pertanian/models/product.dart';
import 'package:pertanian/notifier/auth_notifier.dart';
import 'package:pertanian/notifier/product_notifier.dart';
import 'package:provider/provider.dart';

class ProductForm extends StatefulWidget {
  final bool isUpdating;

  ProductForm({@required this.isUpdating});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Product _currentProduct;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);

    if (productNotifier.currentProduct != null) {
      _currentProduct = productNotifier.currentProduct;
    } else {
      _currentProduct = Product();
    }
    _imageUrl = _currentProduct.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildTitleField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Title',
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green))),
      initialValue: _currentProduct.title,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title is require';
        }
        if (value.length < 3) {
          return 'Name must be more than 3 character';
        }
        return null;
      },
      onSaved: (String value) {
        _currentProduct.title = value;
      },
    );
  }

  Widget _buildStockField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Stock',
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green))),
      initialValue: _currentProduct.stock.toString(),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Stock is require';
        }
        return null;
      },
      onSaved: (String value) {
        _currentProduct.stock = int.tryParse(value);
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Price Rp.',
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green))),
      initialValue: _currentProduct.price.toString(),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is require';
        }
        return null;
      },
      onSaved: (String value) {
        _currentProduct.price = int.tryParse(value);
      },
    );
  }

  String unitValue = 'Kg';
  List<String> typeUnit = [
    "Kg",
    "Gram",
    "Biji",
    "Ekor",
  ];

  Widget _buildUnitField() {
    return DropdownButtonFormField<String>(
        value: unitValue,
        hint: Text("Type of unit"),
        decoration: InputDecoration(
            labelText: 'Unit',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green))),
        //initialValue: _currentProduct.unit,
        style: TextStyle(fontSize: 20, color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
            unitValue = newValue;
          });
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Unit is require';
          }
          return null;
        },
        items: typeUnit.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onSaved: (String value) {
          _currentProduct.unit = value;
        });
  }

  _onProductUploaded(Product product) {
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    productNotifier.addProduct(product);
    Navigator.pop(context);
  }

  _saveProduct() {
    print('saveProduct Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    print('form save');

    uploadProductAndImage(
        _currentProduct, widget.isUpdating, _imageFile, _onProductUploaded);

    print("title: ${_currentProduct.title}");
    print("stock: ${_currentProduct.stock}");
    print("price: ${_currentProduct.price}");
    print("unit: ${_currentProduct.unit}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    _currentProduct.userId = authNotifier.user.uid;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Product Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.isUpdating ? "Edit Product" : "Create Product",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _getLocalImage(),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(height: 0),
            _buildTitleField(),
            _buildStockField(),
            _buildUnitField(),
            _buildPriceField(),
            SizedBox(height: 16),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveProduct();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}

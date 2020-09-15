import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pertanian/notifier/product_notifier.dart';
import 'package:provider/provider.dart';

import 'product_form.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(productNotifier.currentProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Image.network(
                  productNotifier.currentProduct.image,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productNotifier.currentProduct.title,
                      style: TextStyle(
                        fontSize: 28.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text(
                            "8.4/85 reviews",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.favorite_border),
                            color: Colors.pink,
                            onPressed: () {}),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Text(
                          NumberFormat.currency(name: 'Rp. ', decimalDigits: 0)
                                  .format(
                                      productNotifier.currentProduct.price) +
                              ' /' +
                              productNotifier.currentProduct.unit,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Stock: " +
                              productNotifier.currentProduct.stock.toString() +
                              " " +
                              productNotifier.currentProduct.unit,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("CONTACT:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0)),
                    Text("Telp, SMS, WA, Email, dll.",
                        style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ProductForm(
                isUpdating: true,
              );
            }),
          );
        },
        child: Icon(Icons.edit),
        foregroundColor: Colors.white,
      ),
    );
  }
}

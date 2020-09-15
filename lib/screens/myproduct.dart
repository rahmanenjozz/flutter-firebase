import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pertanian/api/product_api.dart';
import 'package:pertanian/notifier/auth_notifier.dart';
import 'package:pertanian/notifier/product_notifier.dart';
import 'package:pertanian/screens/detail.dart';
import 'package:pertanian/screens/product_form.dart';
import 'package:provider/provider.dart';

class MyProduct extends StatefulWidget {
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    String userId = authNotifier.user.uid;
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);

    getMyProducts(productNotifier, userId);
    super.initState();
  }

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    String userId = authNotifier.user.uid;
    Future<void> _refreshList() async {
      getMyProducts(productNotifier, userId);
    }

    print("building MyProduct Screen");
    return Scaffold(
      body: Container(
        child: new RefreshIndicator(
          child: Column(
            children: [
              new SizedBox(height: 10),
              new Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          productNotifier.productList[index].image != null
                              ? productNotifier.productList[index].image
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                          width: 120,
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(productNotifier.productList[index].title),
                        subtitle: Text(NumberFormat.currency(
                                    name: 'Rp. ', decimalDigits: 0)
                                .format(
                                    productNotifier.productList[index].price) +
                            ' /' +
                            productNotifier.productList[index].unit),
                        onTap: () {
                          productNotifier.currentProduct =
                              productNotifier.productList[index];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ProductDetail();
                          }));
                        },
                      ),
                    );
                  },
                  itemCount: productNotifier.productList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Color(0x00000000),
                      height: 0,
                    );
                  },
                ),
              )
            ],
          ),
          onRefresh: _refreshList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ProductForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}

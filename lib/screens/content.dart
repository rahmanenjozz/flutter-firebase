import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pertanian/api/product_api.dart';
import 'package:pertanian/notifier/product_notifier.dart';
import 'package:pertanian/screens/detail.dart';
import 'package:pertanian/screens/detailGuest.dart';
import 'package:provider/provider.dart';

class ContentFeed extends StatefulWidget {
  @override
  _ContentFeedState createState() => _ContentFeedState();
}

class _ContentFeedState extends State<ContentFeed> {
  @override
  void initState() {
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    getProducts(productNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    Future<void> _refreshList() async {
      getProducts(productNotifier);
    }

    return Scaffold(
      body: Container(
        child: new RefreshIndicator(
          child: Column(
            children: [
              new Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.headline4.fontSize * 1.1 +
                      15.0,
                ),
                padding: const EdgeInsets.all(15.0),
                color: Colors.grey[100],
                child: Text("All Product", style: TextStyle(fontSize: 20.0)),
              ),
              new SizedBox(height: 5),
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
                            return DetailGuest();
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
    );
  }
}

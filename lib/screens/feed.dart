import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pertanian/api/product_api.dart';
import 'package:pertanian/notifier/auth_notifier.dart';
import 'package:pertanian/notifier/product_notifier.dart';
import 'package:pertanian/screens/content.dart';
import 'package:pertanian/screens/detail.dart';
import 'package:pertanian/screens/myproduct.dart';
import 'package:pertanian/screens/myprofile.dart';
import 'package:pertanian/screens/product_form.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    getProducts(productNotifier);
    super.initState();
  }

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    Future<void> _refreshList() async {
      getProducts(productNotifier);
    }

    final _listAppBar = <Widget>[
      Text('Farmers Market'),
      Text('My Product'),
      Text('Profile'),
    ];

    final _listScreen = <Widget>[
      ContentFeed(),
      MyProduct(),
      //ProductForm(isUpdating: false),
      MyProfile(),
    ];

    print("building Feed");

    return Scaffold(
      appBar: AppBar(
        title: _listAppBar[_selectedTabIndex],
        actions: <Widget>[
          Center(
            child: Wrap(
              spacing: 4,
              children: <Widget>[
                Icon(
                  Icons.notifications_active, //Refresh Icon
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  margin: const EdgeInsets.only(top: 2.5),
                  child: Text(
                    "25",
                  ),
                ) //This container is to add further text like showing an icon and then showing test
              ],
            ),
          )
        ],
      ),
      body: _listScreen[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        //backgroundColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            title: Text("Market"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text("My Product"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Account"),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
            if (_selectedTabIndex == 0) {
              getProducts(productNotifier);
            }
            ;
            if (_selectedTabIndex == 1) {
              String userId = authNotifier.user.uid;
              getMyProducts(productNotifier, userId);
            }
            ;
          });
        },
      ),
    );
  }
}

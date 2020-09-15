import 'package:flutter/material.dart';
import 'package:pertanian/api/product_api.dart';
import 'package:pertanian/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    print("building MyProfile Screen");
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          Text(
            authNotifier.user != null
                ? authNotifier.user.displayName
                : "Profile",
          ),
          SizedBox(height: 16),
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      )),
    );
  }
}

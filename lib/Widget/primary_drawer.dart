import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/page/about_us.dart';
import 'package:rahbaran/page/freighter.dart';
import 'package:rahbaran/page/havale.dart';
import 'package:rahbaran/page/login.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/page/profile.dart';
import 'package:rahbaran/page/shipping_document.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrimaryDrawer extends StatelessWidget {
  //style
  final TextStyle versionTextStyle = TextStyle(fontSize: 14);

  //variable
  final UserModel currentUser;
  final void Function() logout;

  PrimaryDrawer({this.currentUser, this.logout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(Profile.routeName);
            },
            child: Container(
              padding: EdgeInsets.only(
                  bottom: 15, top: MediaQuery.of(context).padding.top + 15),
              color: StyleHelper.mainColor,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: min(85, MediaQuery.of(context).size.width / 2.5),
                    width: min(85, MediaQuery.of(context).size.width / 2.5),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: (currentUser == null ||
                              currentUser.userImageAddress == null ||
                              currentUser.userImageAddress.isEmpty)
                          ? Image.asset('assets/images/driverempty.png').image
                          : NetworkImage(currentUser.userImageAddress),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: (currentUser == null ||
                            currentUser.fullName == null ||
                            currentUser.fullName.isEmpty)
                        ? Text('')
                        : Text(currentUser.fullName +
                            ' / ' +
                            currentUser.userModeName()),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    if (News.routeName ==
                        ModalRoute.of(context).settings.name) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          News.routeName, (Route<dynamic> rout) => false);
                    }
                  },
                  title: Text(
                    'اخبار',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Icon(
                    Icons.mail,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (Freighter.routeName ==
                        ModalRoute.of(context).settings.name) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Freighter.routeName, (Route<dynamic> rout) => false);
                    }
                  },
                  title: Text(
                    'لیست ناوگان',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Icon(
                    Icons.local_shipping,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (Havale.routeName ==
                        ModalRoute.of(context).settings.name) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Havale.routeName, (Route<dynamic> rout) => false);
                    }
                  },
                  title: Text(
                    'لیست حواله',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Icon(
                    Icons.assignment,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (ShippingDocument.routeName ==
                        ModalRoute.of(context).settings.name) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ShippingDocument.routeName,
                          (Route<dynamic> rout) => false);
                    }
                  },
                  title: Text(
                    'لیست اسناد حمل',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Icon(
                    Icons.description,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(AboutUs.routeName);
                  },
                  title: Text(
                    'درباره ما',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Icon(
                    Icons.info,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    'خروج',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Icon(
                    Icons.power_settings_new,
                    color: StyleHelper.iconColor,
                  ),
                  onTap: () {
                    logout();
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 10,
            thickness: 1,
            endIndent: MediaQuery.of(context).size.width * .02,
            indent: MediaQuery.of(context).size.width * .02,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/images/pdnlogo.png",
                    scale: 1.4,
                    fit: BoxFit.contain,
                  ),
                ),
                Text('راهبران حمل و نقل (1.1.3)', style: versionTextStyle),
              ],
            ),
          )
        ],
      ),
    );
  }
}

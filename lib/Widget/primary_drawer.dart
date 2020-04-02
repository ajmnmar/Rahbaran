import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/page/login.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrimaryDrawer extends StatelessWidget {
  //style
  final TextStyle versionTextStyle=TextStyle(fontSize: 14);

  //variable
  final UserModel currentUser;

  PrimaryDrawer(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            color: StyleHelper.mainColor,
            height: 150,
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
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'اخبار',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  leading: Icon(
                    Icons.mail,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    'لیست ناوگان',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  leading: Icon(
                    Icons.local_shipping,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    'لیست اسناد حمل',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  leading: Icon(
                    Icons.description,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    'درباره ما',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  leading: Icon(
                    Icons.info,
                    color: StyleHelper.iconColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    'خروج',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  leading: Icon(
                    Icons.power_settings_new,
                    color: StyleHelper.iconColor,
                  ),
                  onTap: () {
                    SharedPreferences.getInstance().then((SharedPreferences val) {
                      val.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (BuildContext context) => Login()),
                              (Route<dynamic> rout) => false);
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text('راهبران حمل و نقل (1.0.0)',style:versionTextStyle),
          )
        ],
      ),
    );
  }
}

/*return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            color: StyleHelper.mainColor,
            height: 150,
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
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              'اخبار',
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.mail,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'لیست ناوگان',
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.local_shipping,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'لیست اسناد حمل',
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.description,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'درباره ما',
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.info,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'خروج',
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: StyleHelper.iconColor,
            ),
            onTap: () {
              SharedPreferences.getInstance().then((SharedPreferences val) {
                val.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => Login()),
                        (Route<dynamic> rout) => false);
              });
            },
          ),
        ],
      ),
    );*/



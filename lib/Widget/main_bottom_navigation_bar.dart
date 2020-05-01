import 'package:flutter/material.dart';
import 'package:rahbaran/page/freighter.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/page/shipping_document.dart';
import 'package:rahbaran/theme/style_helper.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int bottomNavigationSelectedIndex;
  final bool isActiveBottomNavigation;

  MainBottomNavigationBar([int bottomNavigationSelectedIndex])
      : this.bottomNavigationSelectedIndex =
            bottomNavigationSelectedIndex == null
                ? 0
                : bottomNavigationSelectedIndex,
        this.isActiveBottomNavigation =
            bottomNavigationSelectedIndex == null ? false : true;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: bottomNavigationSelectedIndex,
      selectedItemColor:
          isActiveBottomNavigation ? StyleHelper.iconColor : Colors.black,
      onTap: (index) {
        if (isActiveBottomNavigation && bottomNavigationSelectedIndex == index) return;
        switch (index) {
          case 0:
            Navigator.of(context).pushNamedAndRemoveUntil(News.routeName,
                (Route<dynamic> rout) => false);
            break;
          case 1:
            Navigator.of(context).pushNamed(Freighter.routeName);
            break;
          case 2:
            Navigator.of(context).pushNamed(ShippingDocument.routeName);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          title: Text('اخبار',style: Theme.of(context).textTheme.body1),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          title: Text('لیست ناوگان',style: Theme.of(context).textTheme.body1,),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          title: Text('اسنادحمل',style: Theme.of(context).textTheme.body1),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/app_const.dart';

import 'home/home.dart';
import 'housing_in_formation/housing_Information_page.dart';
import 'message/message.dart';
import 'my/my.dart';


class GuestHomePage extends StatefulWidget {
  static final String routeName = '/guestHomePageRoute';

  GuestHomePage({Key key}) : super(key: key);

  @override
  _GuestHomePageState createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _selectedIndex = 3; //先初始 化避免崩潰

  final List<String> _pageTitle = [
    '重要資訊',
    '房屋資訊',
    '待辦事項',
    '我的',
  ];
  final List<Widget> _pages = [
    HomePage(),
    HousingInformationPage(),
    Message(),
    MyPage(),
  ];

  BottomNavigationBarItem _buildNavigationBarItem({
    int index,
    IconData iconData,
    String text,
  }) {
    return BottomNavigationBarItem(
        icon: Icon(
          iconData,
          color: AppConstants.nonSelectedIcon,
        ),
        activeIcon: Icon(iconData, color: AppConstants.appBarAndFontColor),
        title: Text(
          text,
          style: TextStyle(
              color: _selectedIndex == index
                  ? AppConstants.appBarAndFontColor
                  : Colors.grey),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildNavigationBarItem(
              index: 0, iconData: Icons.pie_chart, text: _pageTitle[0]),
          _buildNavigationBarItem(
              index: 1, iconData: Icons.home, text: _pageTitle[1]),
          _buildNavigationBarItem(
              index: 2, iconData: Icons.message, text: _pageTitle[2]),
          _buildNavigationBarItem(
              index: 3, iconData: Icons.person_outline, text: _pageTitle[3]),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

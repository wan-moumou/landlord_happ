import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'home_tenant/tenant_home.dart';
import 'tenant_housing_Information/tenant_housing_Information.dart';
import 'tenant_message/tenant_message.dart';
import 'tenant_my/tenant_my_page.dart';

class TenantGuestHomePage extends StatefulWidget {
  static final String routeName = '/TenantGuestHomePage';

  TenantGuestHomePage({Key key}) : super(key: key);

  @override
  _TenantGuestHomePageState createState() => _TenantGuestHomePageState();
}

class _TenantGuestHomePageState extends State<TenantGuestHomePage> {


  int selectedIndex = 3; //先初始 化避免崩潰

  final List<String> _pageTitle = [
    '重要資料',
    '房屋資訊',
    '連絡房東',
    '我的',
  ];
  final List<Widget> _pages = [
    TenantHomePage(),
    TenantHousingInformationPage(),
    TenantMessage(),
    TenantMyPage(),
  ];

  BottomNavigationBarItem _buildNavigationBarItem({
    int index,
    iconData,
    String text,
  }) {
    return BottomNavigationBarItem(
        icon: Icon(
          iconData,
          color: AppConstants.nonSelectedIcon,
        ),
        activeIcon:
            Icon(iconData, color: AppConstants.tenantAppBarAndFontColor),
        title: Text(
          text,
          style: TextStyle(
              color: selectedIndex == index
                  ? AppConstants.tenantAppBarAndFontColor
                  : Colors.grey),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildNavigationBarItem(
              index: 0,
              iconData: Icons.pie_chart_outlined,
              text: _pageTitle[0]),
          _buildNavigationBarItem(
              index: 1, iconData: Icons.rate_review, text: _pageTitle[1]),
          _buildNavigationBarItem(
              index: 2, iconData: Icons.message, text: _pageTitle[2]),
          _buildNavigationBarItem(
              index: 3, iconData: Icons.person_outline, text: _pageTitle[3]),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

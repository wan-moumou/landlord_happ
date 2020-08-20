import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

import 'landlord/guestHomePage.dart';
import 'landlord/home/income.dart';
import 'tenant/home_tenant/tenant_income_and_expenses.dart';
import 'login.dart';
import 'tenant/tenant_guest_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.white),
      home: MyHomePage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        GuestHomePage.routeName: (context) => GuestHomePage(),
        TenantIncomeAndExpenses.routeName: (context) =>
            TenantIncomeAndExpenses(),
        TenantGuestHomePage.routeName: (context) => TenantGuestHomePage(),
        Income.routeName: (context) => Income(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String appVesion = "0.0.0";

  Future fetchAppVersion() async {
    PackageInfo pacakgeInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVesion = pacakgeInfo.version;
    });
  }

  @override
  void initState() {
    fetchAppVersion();
    getVersion();
    Timer(Duration(seconds: 6), () {
      Navigator.popAndPushNamed(context, LoginPage.routeName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                  data: data,
                  intnetVersion: intnetVersion,
                  appVesion: appVesion,
                  updeta: updeta)));
    });
    super.initState();
  }

  var _flatform;

  Map data = {};
  static String upDataContext1;
  static String upDataContext2;
  static String upDataContext3;
  static String upDataContext4;
  static bool updeta;
  static String updetaUrl;

  Future<String> getFlatForm() async {
    if (Platform.isAndroid) {
      _flatform = 'android';
    } else {
      _flatform = 'ios';
    }
    return _flatform;
  }

  String intnetVersion;

  ///從服務綺拉取版本信息
  void getVersion() async {
    await Firestore.instance
        .collection("/APP版本")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        intnetVersion = f['APP版本'];
        upDataContext1 = f['更新內容一'];
        upDataContext2 = f['更新內容二'];
        upDataContext3 = f['更新內容三'];
        upDataContext4 = f['更新內容四'];
        data.addAll({
          'content':
              '更新內容:\n$upDataContext1\n$upDataContext2\n$upDataContext3\n$upDataContext4',
        });
        updeta = f['強制更新'];
        updetaUrl = f['更新網址'];
        data.addAll({
          'isForceUpdate': updeta,
        });
        data.addAll({
          'url': updetaUrl,
        });

        setState(() {});
        print(intnetVersion);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        //
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/首頁.gif'),
                    Text('程式版本:$appVesion'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

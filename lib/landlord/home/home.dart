import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_const/app_const.dart';
import 'income.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> dataMap = Map();
  Map<String, double> dataMap1 = Map();
  List<int> waterData = [];
  List<int> electricityFeeData = [];
  List<int> expenditureData = [];
  List<int> homeMoneyData = [];
  final _auth = FirebaseAuth.instance;
  String loginUser = '';
  int water;
  int electricityFee;
  int expenditure;
  int homeMoney;
  bool upData;

  Future savePieData(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  Future getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      await Firestore.instance
          .collection("/房東/帳號資料/$loginUser")
          .document('帳務資料')
          .get()
          .then((value) => upData = value['帳務更新']);
      print(upData);
      if (upData||waterLocalData==null) {
        final pieWaterData = await Firestore.instance
            .collection('/房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
            .getDocuments();
        print('獲取水費資料');
        if (pieWaterData.documents.length == 0) {
          setState(() {
            water = 0;
            savePieData('水收入', water.toDouble());
          });
        } else {
          for (var data in pieWaterData.documents) {
            waterData.add(int.parse(data['總價']));
            print(waterData);
          }
          setState(() {
            water = waterData.reduce((value, element) {
              return value + element;
            });
            savePieData('水收入', water.toDouble());
            print(water);
          });
        }
        final pieHomeMoneyData = await Firestore.instance
            .collection('/房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
            .getDocuments();
        print('獲取房租資料');
        if (pieHomeMoneyData.documents.length == 0) {
          setState(() {
            homeMoney = 0;
            savePieData('房租收入', homeMoney.toDouble());
          });
        } else {
          for (var data in pieHomeMoneyData.documents) {
            homeMoneyData.add(int.parse(data['總價']));
            print(homeMoneyData);
          }
          setState(() {
            homeMoney = homeMoneyData.reduce((value, element) {
              return value + element;
            });
            savePieData('房租收入', homeMoney.toDouble());
            print(homeMoney);
          });
        }

        final pieElectricityFeeData = await Firestore.instance
            .collection('/房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
            .getDocuments();
        print('獲取電費資料');
        if (pieElectricityFeeData.documents.length == 0) {
          setState(() {
            electricityFee = 0;
            savePieData('電收入', electricityFee.toDouble());
          });
        } else {
          for (var data in pieElectricityFeeData.documents) {
            electricityFeeData.add(int.parse(data['總價']));
            print(electricityFeeData);
          }
          setState(() {
            electricityFee = electricityFeeData.reduce((value, element) {
              return value + element;
            });
            savePieData('電收入', electricityFee.toDouble());
            print(electricityFee);
          });
        }
        final pieExpenditureData = await Firestore.instance
            .collection('/房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}交易紀錄')
            .getDocuments();
        print('獲取交易紀錄');
        if (pieExpenditureData.documents.length == 0) {
          setState(() {
            expenditure = 0;
            savePieData('交易紀錄', expenditure.toDouble());
          });
        } else {
          for (var data in pieExpenditureData.documents) {
            expenditureData.add(int.parse(data['總價']));
            print(expenditureData);
          }
          setState(() {
            expenditure = expenditureData.reduce((value, element) {
              return value + element;
            });
            savePieData('交易紀錄', expenditure.toDouble());
            print(expenditure);
          });
        }
        print('帳務更新更改');
        await Firestore.instance
            .collection("/房東/帳號資料/$loginUser")
            .document('帳務資料')
            .updateData({'帳務更新': false});
        await getPieWaterData();
        await getPieExpenditureData();
        await getPieHouseMoneyData();
        await getPieEleData();
        await getPieData();
      } else if (upData == false || upData == null) {
        await getPieWaterData();
        await getPieExpenditureData();
        await getPieHouseMoneyData();
        await getPieEleData();
        await getPieData();
      }
    }
  }

  List<Color> colorList = [
    Colors.white,
    Color(0xFF435758),
    Color(0xFF779FA2),
    Color(0xFF8852A1),
    Color(0xFFA1E0E5),
  ];
  List<Color> colorList1 = [
    Colors.white,
    Color(0xFFB43F3F),
    Color(0xFFFFB7B7),
    Colors.white
  ];

  void getPieData() {
    print('更新圓餅圖');
    setState(() {
      dataMap.putIfAbsent("本月收入", () => 0);
      dataMap.putIfAbsent(
          "房租$houseMoneyLocalData", () => houseMoneyLocalData.toDouble());
      dataMap.putIfAbsent("水費$waterLocalData", () => waterLocalData.toDouble());
      dataMap.putIfAbsent("電費$electricityFeeLocalData",
          () => electricityFeeLocalData.toDouble());
      dataMap1.putIfAbsent("本月支出", () => 0);
      dataMap1.putIfAbsent("點數花費$expenditureLocalData", () => expenditureLocalData.toDouble());
      dataMap1.putIfAbsent("其他1500", () => 1500);
      dataMap1.putIfAbsent(" ", () => 0);
    });
  }

  @override
  void initState() {
    getPieWaterData();
    getData();
    super.initState();
  }

  void http(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IndexWeb(
                  index: index,
                )));
  }

  List<String> image = [
    "https://images.pexels.com/photos/3701434/pexels-photo-3701434.jpeg?cs=srgb&dl=pexels-3701434.jpg&fm=jpg",
    'https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg?cs=srgb&dl=pexels-323780.jpg&fm=jpg',
    'https://images.pexels.com/photos/53610/large-home-residential-house-architecture-53610.jpeg?cs=srgb&dl=pexels-53610.jpg&fm=jpg',
    'https://images.pexels.com/photos/1571459/pexels-photo-1571459.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'
  ];
  int waterLocalData;
  int electricityFeeLocalData;
  int houseMoneyLocalData;
  int expenditureLocalData;

  Future getPieWaterData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('水收入').toInt();

    if (userName != null) {
      print('開始獲取水費');
      return waterLocalData = userName;
    } else {}
  }
  Future getPieExpenditureData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('交易紀錄').toInt();

    if (userName != null) {
      print('開始獲取交易紀錄');
      return expenditureLocalData = userName;
    } else {}
  }

  Future getPieEleData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('電收入').toInt();

    if (userName != null) {
      print('開始獲取電費');

      return electricityFeeLocalData = userName;
    } else {}
  }

  Future getPieHouseMoneyData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('房租收入').toInt();

    if (userName != null) {
      print('開始獲取房租');

      return houseMoneyLocalData = userName;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstants.backColor,
        appBar: AppBar(
          backgroundColor: AppConstants.appBarAndFontColor,
          title: Text('重要資料'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Adapt.px(70),
                    ),
                    waterLocalData == null || electricityFeeLocalData == null
                        ? Container(
                            width: 400,
                            height: 285,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: PieChart(
                                    legendStyle: TextStyle(
                                        fontSize: Adapt.px(25),
                                        fontWeight: FontWeight.bold),
                                    chartRadius: Adapt.px(240),
                                    dataMap: dataMap,
                                    showChartValuesOutside: true,
                                    chartType: ChartType.disc,
                                    colorList: colorList,
                                    legendPosition: LegendPosition.bottom),
                              ),
                              SizedBox(
                                width: Adapt.px(50),
                              ),
                              Container(
                                child: PieChart(
                                    legendStyle: TextStyle(
                                        fontSize: Adapt.px(25),
                                        fontWeight: FontWeight.bold),
                                    chartRadius: Adapt.px(240),
                                    dataMap: dataMap1,
                                    showChartValuesOutside: true,
                                    chartType: ChartType.disc,
                                    colorList: colorList1,
                                    legendPosition: LegendPosition.bottom),
                              ),
                            ],
                          ),
                    MaterialButton(
                      color: AppConstants.appBarAndFontColor,
                      padding: EdgeInsets.fromLTRB(100, 16, 100, 16),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Income.routeName);
                      },
                      child: Text(
                        '查看詳細資料',
                        style: TextStyle(
                            color: Colors.white, fontSize: Adapt.px(25)),
                      ),
                    ),
                    SizedBox(
                      height: Adapt.px(50),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      image[index],
                      fit: BoxFit.fill,
                    );
                  },
                  onTap: (index) {
                    http(index);
                  },
                  autoplay: true,
                  itemCount: image.length,
                  itemHeight: Adapt.px(400),
                  itemWidth: Adapt.px(700),
                  layout: SwiperLayout.STACK,
                ),
              )
            ],
          ),
        ));
  }
}

class IndexWeb extends StatefulWidget {
  final int index;

  IndexWeb({this.index});

  @override
  _IndexWebState createState() => _IndexWebState();
}

class _IndexWebState extends State<IndexWeb> {
  List<String> indexWeb = [
    'https://kknews.cc/zh-tw/tech/2n82oee.html',
    'https://www.parallels.cn/landingpage/pd/windows-on-mac/?gclid=CjwKCAjwltH3BRB6EiwAhj0IUMFB7coq1ASNw8xOJvInwG2ZY76ORigu_QNSMIC8ulRU7htog60G3xoCeR8QAvD_BwE',
    'https://www.bilibili.com/video/av39709290?p=5',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: indexWeb[widget.index],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppConstants.appBarAndFontColor,
          title: Text(
            '最新消息',
            style: TextStyle(fontSize: Adapt.px(40)),
          ),
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        ignoreSSLErrors: false,
        initialChild: Container(
          color: AppConstants.tenantBackColor,
          child: const Center(
            child: Text('請稍等.....'),
          ),
        ),
      ),
    );
  }
}

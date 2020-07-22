import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/landlord/home/home.dart';
import 'package:landlord_happy/tenant/home_tenant/tenant_income_and_expenses.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantHomePage extends StatefulWidget {
  TenantHomePage({Key key}) : super(key: key);

  @override
  _TenantHomePageState createState() => _TenantHomePageState();
}

class _TenantHomePageState extends State<TenantHomePage> {
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
  Map<String, double> dataMap = Map();
  List<int> waterData = [];
  List<int> electricityFeeData = [];
  List<int> homeMoneyData = [];
  final _auth = FirebaseAuth.instance;
  String loginUser = '';
  int water;
  int electricityFee;
  int homeMoney;
  var remainingDegree;
  String houseName;
  String tenant;
  String electricity;
  String waterMoney;
  bool electricityStoredValue;
  int waterLocalData;
  int electricityFeeLocalData;
  int houseMoneyLocalData;
  bool upData;
  Future savePieData(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }
  Future getPieWaterData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('水收入').toInt();

    if (userName != null) {
      print('開始獲取水費');
      return waterLocalData = userName;
    }

  }

  Future getPieEleData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('電收入').toInt();

    if (userName != null) {
      print('開始獲取電費');

      return electricityFeeLocalData = userName;
    }
  }

  Future getPieHouseMoneyData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getDouble('房租收入').toInt();

    if (userName != null) {
      print('開始獲取房租');

      return houseMoneyLocalData = userName;
    }
  }
  void getPieData()async {
    print('更新圓餅圖');
    setState(() {
      dataMap.putIfAbsent("本月收入", () => 0);
      dataMap.putIfAbsent(
          "房租$houseMoneyLocalData", () => houseMoneyLocalData.toDouble());
      dataMap.putIfAbsent("水費$waterLocalData", () => waterLocalData.toDouble());
      dataMap.putIfAbsent("電費$electricityFeeLocalData",
              () => electricityFeeLocalData.toDouble());
    });

  }

  Future getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        houseName = f['房屋名稱'];
        tenant = f['房東姓名'];
        print(houseName);
      });
    });
    Firestore.instance
        .collection('房東/帳號資料/$tenant/資料/擁有房間')
        .document(houseName)
        .snapshots()
        .forEach((element) {
      electricityStoredValue = element['房屋費用設定']['電費儲值'];
      electricity = element['房屋費用設定']['電費'];
      waterMoney = element['房屋費用設定']['水費'];
      print(electricity);
    });

      await  Firestore.instance
          .collection("/房客/帳號資料/$loginUser")
          .document('帳務資料').get().then((value) => upData = value['帳務更新']);
      print(upData);
      await Firestore.instance
          .collection("/房客/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          remainingDegree = f['剩餘度數'];
        });
      });

      if (upData==true) {
        final pieHomeMoneyData = await Firestore.instance
            .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
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
          }
          setState(() {
            homeMoney = homeMoneyData.reduce((value, element) {
              return value + element;
            });
            savePieData('房租收入', homeMoney.toDouble());
          });
        }
        final pieWaterData = await Firestore.instance
            .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
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


        final pieElectricityFeeData = await Firestore.instance
            .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
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
        print('帳務更新更改');
        await Firestore.instance
            .collection("/房客/帳號資料/$loginUser")
            .document('帳務資料')
            .updateData({'帳務更新': false});
        await getPieWaterData();
        await getPieHouseMoneyData();
        await getPieEleData();
        await getPieData();
      } else if(upData ==false||upData == null){
        await  getPieWaterData();
        await getPieHouseMoneyData();
        await  getPieEleData();
        await  getPieData();
      }

    }
  }
//  Future getData() async {
//
//    final user = await _auth.currentUser();
//    if (user != null) {
//      loginUser = user.email;
//      await Firestore.instance
//          .collection("/房客/帳號資料/$loginUser")
//          .getDocuments()
//          .then((QuerySnapshot snapshot) {
//        snapshot.documents.forEach((f) {
//          remainingDegree = f['剩餘度數'];
//        });
//      });
//      final pieWaterData = await Firestore.instance
//          .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
//          .getDocuments();
//      if (pieWaterData.documents.length == 0) {
//        setState(() {
//          water = 0;
//        });
//      } else {
//        for (var data in pieWaterData.documents) {
//          waterData.add(int.parse(data['總價']));
//          print(waterData);
//        }
//        setState(() {
//          water = waterData.reduce((value, element) {
//            return value + element;
//          });
//          print(water);
//        });
//      }
//
//      final pieHomeMoneyData = await Firestore.instance
//          .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
//          .getDocuments();
//      if (pieHomeMoneyData.documents.length == 0) {
//        setState(() {
//          homeMoney = 0;
//        });
//      } else {
//        for (var data in pieHomeMoneyData.documents) {
//          homeMoneyData.add(int.parse(data['總價']));
//          print(homeMoneyData);
//        }
//        setState(() {
//          homeMoney = homeMoneyData.reduce((value, element) {
//            return value + element;
//          });
//          print(homeMoney);
//        });
//      }
//
//      final pieElectricityFeeData = await Firestore.instance
//          .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
//          .getDocuments();
//      if (pieElectricityFeeData.documents.length == 0) {
//        setState(() {
//          electricityFee = 0;
//        });
//      } else {
//        for (var data in pieElectricityFeeData.documents) {
//          electricityFeeData.add(int.parse(data['總價']));
//          print(electricityFeeData);
//        }
//        setState(() {
//          electricityFee = electricityFeeData.reduce((value, element) {
//            return value + element;
//          });
//          print(electricityFee);
//        });
//      }
//    }
//    water == null || electricityFee == null ? null : getPieData();
//  }



  void getUserName() async {

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstants.tenantBackColor,
        appBar: AppBar(
          backgroundColor: AppConstants.tenantAppBarAndFontColor,
          title: Text('重要資料'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                  height:
                      MediaQuery.of(context).size.height * .58, //确保pageview的高度
                  child: PageView(
                    controller: PageController(
                        initialPage: 0, //让初始页为第一个pageview的实例
                        viewportFraction: 1.0 //让页面视图充满整个视图窗口 即充满400px高的视图窗口
                        ),
                    children: <Widget>[
                      waterLocalData == null || electricityFeeLocalData == null
                          ? Container(
                        width: 400,
                        height: 285,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          :
                      Pie(
                        dataMap: dataMap,
                        water: waterLocalData,
                        waterData: waterData,
                        electricityFeeData: electricityFeeData,
                        electricityFee: electricityFeeLocalData,
                        homeMoney: houseMoneyLocalData,
                        homeMoneyData: homeMoneyData,
                      ),
                      Water(
                        water: waterLocalData,
                        electricityFee: electricityFeeLocalData,
                        homeMoney: houseMoneyLocalData,
                        tenant: tenant,
                        houseName: houseName,
                        remainingDegree: remainingDegree,
                        electricityStoredValue: electricityStoredValue,
                        waterMoney: waterMoney,
                        electricity: electricity,
                      )
                    ],
                    scrollDirection: Axis.horizontal, //左右滾動
                    reverse: false, //不反轉順序
                  )),
            ),
            Expanded(
              flex: 2,
              child: Container(
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
              ),
            )
          ],
        ));
  }
}

class Pie extends StatefulWidget {
  final int water;
  final int electricityFee;
  final int homeMoney;
  final List<int> waterData;
  final List<int> electricityFeeData;

  final List<int> homeMoneyData;
  final Map<String, double> dataMap;

  Pie(
      {this.homeMoney,
      this.electricityFee,
      this.water,
      this.electricityFeeData,
      this.homeMoneyData,
      this.waterData,
      this.dataMap});

  @override
  _PieState createState() => _PieState();
}

class _PieState extends State<Pie> {
  List<Color> colorList = [
    Colors.white,
    Color(0xFF435758),
    Color(0xFF779FA2),
    Color(0xFFA1E0E5),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.water == null || widget.electricityFee == null
                    ? Container(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : PieChart(
                        chartRadius: MediaQuery.of(context).size.width / 2,
                        dataMap: widget.dataMap,
                        showChartValuesOutside: true,
                        chartType: ChartType.disc,
                        colorList: colorList,
                        legendPosition: LegendPosition.right),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: MaterialButton(
              color: AppConstants.tenantAppBarAndFontColor,
              padding: EdgeInsets.fromLTRB(100, 16, 100, 16),
              onPressed: () {
                Navigator.pushNamed(context, TenantIncomeAndExpenses.routeName);
              },
              child: Text(
                '查看詳細資料',
                style: TextStyle(color: Colors.white, fontSize: Adapt.px(24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Water extends StatefulWidget {
  final int water;
  final int electricityFee;
  final int homeMoney;
  final String houseName;
  final String tenant;
  final String waterMoney;
  final String remainingDegree;
  final String electricity;
  final bool electricityStoredValue;

  Water(
      {this.homeMoney,
      this.electricityFee,
      this.waterMoney,
      this.electricityStoredValue,
      this.electricity,
      this.remainingDegree,
      this.water,
      this.houseName,
      this.tenant});

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {});
      print('object');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.houseName == ''
        ? Card(
            margin: EdgeInsets.all(10),
            child: Center(
                child: Container(
              child: Text('請連絡房東加入房間'),
            )))
        : Stack(
            alignment: const Alignment(0.0, 0.7),
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '儲值餘額',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('水費${widget.waterMoney}/月'),
                            Text('本月儲值${widget.water}元'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            widget.electricityStoredValue
                                ? Text('電費${widget.electricity}/度')
                                : Text('電費${widget.electricity}/月'),
                            Text('本月儲值${widget.electricityFee}元'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 62),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.asset('assets/images/紅色花.png'),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '水費剩餘',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "∞",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 62),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.asset('assets/images/綠色花.png'),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '電費剩餘',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.electricityStoredValue
                                          ? widget.remainingDegree
                                          : "∞",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "度",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          );
  }
}

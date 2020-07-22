import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeAndExpenses extends StatefulWidget {
  static final String routeName = '/IncomeAndExpenses';

  @override
  _IncomeAndExpensesState createState() => _IncomeAndExpensesState();
}

class _IncomeAndExpensesState extends State<IncomeAndExpenses> {
  bool day = false;
  bool userName = true;
  String loginUser = '';
  int items = 0;
  final _auth = FirebaseAuth.instance;
  List<String> buyTime = [];

  List<String> roomName = [];

  List<String> tenantName = [];

  List<String> money = [];

  List<String> type = [];

  Future savePieData(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  bool upData;

  Future getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      final aa = await Firestore.instance
          .collection('/房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
          .getDocuments();
      items = aa.documents.length;
      await Firestore.instance
          .collection("/房東/帳號資料/$loginUser")
          .document('帳務資料')
          .get()
          .then((value) => upData = value['詳細資料更新']);
      if (upData) {
        final pieHomeMoneyData = await Firestore.instance
            .collection('/房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
            .getDocuments();
        for (var data in pieHomeMoneyData.documents) {
          buyTime.add(data.data['購買時間']);
          print(buyTime);
          savePieData('購買時間', buyTime);
        }
        for (var data in pieHomeMoneyData.documents) {
          roomName.add(data.data['房間名稱']);
          print(roomName);
          savePieData('房間名稱', roomName);
        }
        for (var data in pieHomeMoneyData.documents) {
          tenantName.add(data.data['付款人']);
          print(tenantName);
          savePieData('付款人', tenantName);
        }
        for (var data in pieHomeMoneyData.documents) {
          money.add(data.data['總價']);
          print(money);
          savePieData('金額', money);
        }
        for (var data in pieHomeMoneyData.documents) {
          type.add(data.data['類型']);
          print(type);
          savePieData('購買類型', type);
        }
      }
      await Firestore.instance
          .collection("/房東/帳號資料/$loginUser")
          .document('帳務資料')
          .updateData({'詳細資料更新': false});
      await getBuyTimeData();
      await getMoneyData();
      await getRoomNameData();
      await getTenantNameData();
      await getTypeData();
      scrollMsgBottom(100);
      setState(() {

      });
    } else {
      await getBuyTimeData();
      await getMoneyData();
      await getRoomNameData();
      await getTenantNameData();
      await getTypeData();
      scrollMsgBottom(100);
      setState(() {

      });
    }
  }

  Future getBuyTimeData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getStringList('購買時間');

    if (userName != null) {
      return buyTime = userName;
    }
  }

  Future getRoomNameData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getStringList('房間名稱');

    if (userName != null) {
      return roomName = userName;
    }
  }

  Future getTenantNameData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getStringList('付款人');

    if (userName != null) {
      return tenantName = userName;
    }
  }

  Future getMoneyData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getStringList('金額');

    if (userName != null) {
      return money = userName;
    }
  }

  Future getTypeData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getStringList('購買類型');

    if (userName != null) {
      return type = userName;
    }
  }

  ScrollController _msgController = ScrollController();

  void scrollMsgBottom(int time) {
    Timer(
        Duration(milliseconds: time),
        () => _msgController.jumpTo(day
            ? _msgController.position.maxScrollExtent
            : _msgController.position.minScrollExtent));

    _msgController.addListener(() => print(_msgController.offset));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  String value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.appBarAndFontColor,
        title: Text('帳務收支明細'),
        centerTitle: true,
      ),
      body: Card(
        child: Column(
          children: <Widget>[
            Row(
              //選項名稱
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: FlatButton(
                      onPressed: items < 10
                          ? null
                          : () {
                              setState(() {
                                scrollMsgBottom(300);
                                day = !day;
                                print(day);
                              });
                            },
                      child: Row(
                        children: <Widget>[
                          Text('日期'),
                          Icon(
                              day ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                        ],
                      )),
                ),
                Expanded(flex: 2, child: Text('房間名')),
                Expanded(flex: 2, child: Text('房客名')),
                Expanded(flex: 2, child: Text('價格')),
                Expanded(flex: 2, child: Text('類型')),
              ],
            ),
            SingleChildScrollView(
                child: Container(
                    color: AppConstants.backColor,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        controller: _msgController,
                        reverse: day,
                        shrinkWrap: true,
                        itemCount: items,
                        itemBuilder: (context, index) => Container(
                              color: index.isEven
                                  ? AppConstants.backColor
                                  : Colors.white,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height / 10,
                              child: OutlineButton(
                                splashColor: Colors.blueGrey[100],
                                onPressed: () {},
                                child: Card(
                                  margin: EdgeInsets.all(0.0),
                                  elevation: 0.0,
                                  color: index.isEven
                                      ? AppConstants.backColor
                                      : Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3, child: Text(buyTime[index])),
                                      Expanded(
                                        flex: 2,
                                        child: Text(roomName[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(tenantName[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(money[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(type[index]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))))
          ],
        ),
      ),
    );
  }
}

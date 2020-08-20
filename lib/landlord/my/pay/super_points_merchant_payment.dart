import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';

import '../../../rules_of_user.dart';

class SuperMerchantPayment extends StatefulWidget {
  final buyNum;
  final money;
  final points;


  SuperMerchantPayment({this.money, this.buyNum, this.points});

  @override
  _SuperMerchantPaymentState createState() => _SuperMerchantPaymentState();
}

class _SuperMerchantPaymentState extends State<SuperMerchantPayment> {
  String loginUser = '';
  final _auth = FirebaseAuth.instance;
  String landlordID = '';
  String houseName = '';
  String myName = '';

  void wait(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return; // 检测到返回键直接返回
            },
            child: AlertDialog(
              title: Text('資料加密傳輸中..請稍後'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
              elevation: 4,
              content: StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  child: SingleChildScrollView(
                    child: Text(
                      '請勿關閉視窗',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }),
            ),
          );
        });
  }

  void getUserName() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
  }

  String remainingDegree = '';

  Future setData(String money, String buyNum) async {
    wait(context);
    int documentLength;
    final aa = await Firestore.instance
        .collection('房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}交易紀錄')
        .getDocuments();
    documentLength = aa.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$loginUser/帳務資料/${DateTime.now().month}交易紀錄')
        .document(
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-第$documentLength筆")
        .setData({
      '類型': '儲值點數',
      '購買點數': "$buyNum",
      '總價': "${int.parse(widget.money)+15}",
      '購買時間': nowTime,
      '藍新金流支付方式': '超商付款'
    });
    final bb = await Firestore.instance
        .collection('房東/帳號資料/$loginUser/帳務資料/交易紀錄')
        .getDocuments();
    documentLength = bb.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$loginUser/帳務資料/交易紀錄')
        .document(
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-第$documentLength筆")
        .setData({
      '類型': '儲值點數',
      '購買點數': "$buyNum",
      '總價': "${int.parse(widget.money)+15}",
      '購買時間': nowTime,
      '藍新金流支付方式': '超商付款'
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true,'詳細收入資料更新':false,'詳細支出資料更新':true});
    await Firestore.instance
        .collection('房東/帳號資料/$loginUser')
        .document("資料")
        .updateData({
      '剩餘點數': '${int.parse(widget.points) + int.parse(buyNum)}',
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }
  String nowTime;

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  int time = DateTime.now().day + 1;
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('付款'),
          centerTitle: true,
          backgroundColor: AppConstants.appBarAndFontColor,
        ),
        body:  Container(
                color: AppConstants.backColor,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              color: AppConstants.backColor,
                              width: double.infinity,
                              height: 100,
                              child: Image.asset('assets/images/LOGO藍.jpg')),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '應付金額:NT\$${int.parse(widget.money)+15}元',
                              style: TextStyle(
                                  fontSize: Adapt.px(40),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                color: AppConstants.backColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text('點數價格:NT\$${widget.money}元'),
                                    ),
                                    SizedBox(
                                      child: Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text('購買點數:\$${widget.buyNum}點'),
                                    ),
                                    SizedBox(
                                      child: Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text(
                                          '手續費: 15'),
                                    ),
                                     SizedBox(
                                      child: Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text(
                                          '應付金額:${int.parse(widget.money)+15}'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text('藍新金流支付方式:'),
                                  Container(
                                    color: Colors.yellow,
                                    child: Text('超商條碼繳費'),
                                  )
                                ],
                              ),
                              SizedBox(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('1.確認送出交易後您將取得超商繳費代碼,您可以至全台'
                                    '[7-11,全家,OK超商,萊爾富]店內之多美體機台'
                                    '(ibon,FamiPort,OK-go,Life-ET)上列印繳費單至超商櫃檯繳費.'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '3.繳費期限:${DateTime.now().year}-${DateTime.now().month}-$time  23:59:59',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '您的警覺是防範詐騙交易最有效的防線,請務必確認您目前要付款的對象與商品交易的對象是一致的,以免被有心詐騙者利用.',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('填寫付款人信箱:'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    height: 50,
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '信箱'),
                                    )),
                              ),
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    onChanged: (bool value) {
                                      setState(() {
                                        check = value;
                                      });
                                    },
                                    value: check,
                                  ),
                                  Expanded(
                                      child: Text(
                                    '請再次確認您的[訂單資訊]及[付款資訊],付款完成後藍新金流將發送通知信至您的信箱',
                                    style: TextStyle(
                                      color:
                                          check ? Colors.black54 : Colors.red,
                                    ),
                                  )),
                                ],
                              ),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BlueNew()));
                                  },
                                  child: Text(
                                    '查看藍新金流第三方支付金流平台服務條款',
                                    style: TextStyle(color: Colors.blueAccent),
                                  )),
                              SizedBox(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                      color:
                                          AppConstants.appBarAndFontColor,
                                      onPressed: !check
                                          ? null
                                          : () {
                                              setState(() {
                                                nowTime =
                                                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                                              });
                                              setData(widget.money, widget.buyNum);
                                            },
                                      child: Text(
                                        '以閱讀定同意服務條款,確認送出',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ]),
                  ),
                )));
  }
}

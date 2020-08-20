import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/landlord/my/pay/ATM_points_payIng.dart';
import 'file:///D:/FlutterProjects/landlord_happy_copy/lib/landlord/my/pay/transaction_record.dart';
import 'package:landlord_happy/landlord/my/pay/super_points_merchant_payment.dart';

class Pay extends StatelessWidget {
  final loginUser;

  Pay({this.loginUser});

  String points;
  bool aTM = true;
  bool superBusiness = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('點數中心'),
        actions: <Widget>[
          FlatButton(
              child: Text(
                '交易紀錄',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionRecord(
                              loginUser: loginUser,
                            )));
              }),
        ],
        backgroundColor: AppConstants.appBarAndFontColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            color: Color(0xFF1E3C6E),
            child: Container(
              height: Adapt.px(200),
              width: double.infinity,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('/房東/帳號資料/$loginUser')
                      .document('資料')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    points = data['剩餘點數'];
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '可用點數',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Adapt.px(40),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.fiber_smart_record,
                              color: Colors.white,
                              size: Adapt.px(70),
                            ),
                            Text(
                              data['剩餘點數'],
                              style: TextStyle(
                                  fontSize: Adapt.px(60), color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StatefulBuilder(builder: (context, StateSetter setState) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Text(
                              '購買點數',
                              style: TextStyle(
                                  color: AppConstants.appBarAndFontColor,
                                  fontSize: Adapt.px(40)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: <Widget>[
                                Text('ATM付款'),
                                Checkbox(
                                    value: aTM,
                                    onChanged: (v) {
                                      setState(() {
                                        aTM = v;
                                        superBusiness = !v;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: <Widget>[
                                Text('超商付款'),
                                Checkbox(
                                    value: superBusiness,
                                    onChanged: (v) {
                                      setState(() {
                                        superBusiness = v;
                                        aTM = !v;
                                      });
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                          leading: Icon(
                            Icons.fiber_smart_record,
                            color: AppConstants.appBarAndFontColor,
                            size: Adapt.px(70),
                          ),
                          title: Text('30'),
                          trailing: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => aTM
                                          ? ATMPointsPayIng(
                                        buyNum: '30',
                                        money: '1500',
                                        points: points,
                                      )
                                          : SuperMerchantPayment(
                                        buyNum: '30',
                                        money: '1500',
                                        points: points,
                                      )));
                            },
                            child: Text(
                              '\$1,500',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: AppConstants.appBarAndFontColor,
                          )),
                      ListTile(
                          leading: Icon(
                            Icons.fiber_smart_record,
                            color: AppConstants.appBarAndFontColor,
                            size: Adapt.px(70),
                          ),
                          title: Text('100'),
                          trailing: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => aTM
                                          ? ATMPointsPayIng(
                                        buyNum: '100',
                                        money: '4900',
                                        points: points,
                                      )
                                          : SuperMerchantPayment(
                                        buyNum: '100',
                                        money: '4900',
                                        points: points,
                                      )));
                            },
                            child: Text(
                              '\$4,900',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: AppConstants.appBarAndFontColor,
                          )),
                      ListTile(
                          leading: Icon(
                            Icons.fiber_smart_record,
                            color: AppConstants.appBarAndFontColor,
                            size: Adapt.px(70),
                          ),
                          title: Text('250'),
                          trailing: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => aTM
                                          ? ATMPointsPayIng(
                                              buyNum: '250',
                                              money: '12100',
                                              points: points,
                                            )
                                          : SuperMerchantPayment(
                                              buyNum: '250',
                                              money: '12100',
                                              points: points,
                                            )));
                            },
                            child: Text(
                              '\$12,100',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: AppConstants.appBarAndFontColor,
                          )),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

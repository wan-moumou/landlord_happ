import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/payData.dart';
import 'package:landlord_happy/app_const/user.dart';
import 'package:landlord_happy/rules_of_user.dart';
import 'package:landlord_happy/tenant/tenant_my/pay/super_merchant_payment.dart';

import 'ATM_payIng.dart';

class TenantPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          width: double.infinity,
          height: 70,
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PayPag2()));
            },
            child: Text(
              '下一步',
              style: TextStyle(color: Colors.white),
            ),
            color: AppConstants.tenantAppBarAndFontColor,
          ),
        ),
        appBar: AppBar(
          title: Text('儲值'),
          centerTitle: true,
          backgroundColor: AppConstants.tenantAppBarAndFontColor,
        ),
        body: SingleChildScrollView(
            child: Container(
          color: AppConstants.tenantBackColor,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .8,
          child: Card(
            margin: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '為什麼要用儲值的?',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '用多少存多少,出門在外理財觀念不可少,房東安心房客也安心',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '流程',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(Icons.looks_one),
                          Text('選擇儲值類型'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.looks_two),
                          Text('輸入儲值金額'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.looks_3),
                          Text('選擇付款方式'),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(Icons.looks_4),
                          Text('進行繳費'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.looks_5),
                          Text('完成'),
                        ],
                      )
                    ],
                  ),
                ]),
          ),
        )));
  }
}

class PayPag2 extends StatefulWidget {
  @override
  _PayPag2State createState() => _PayPag2State();
}

class _PayPag2State extends State<PayPag2> {
  String landlordID = '';
  String houseName = '';
  String loginUser = '';
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  User userData = User();

  PayData payData = PayData();

  void getUserName() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    print(loginUser);

    await _firestore
        .collection("/房客/帳號資料/$loginUser")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        User newUserData = User(
          name: f['name'],
        );
        userData.name = newUserData.name;
        landlordID = f['房東姓名'];
        houseName = f['房屋名稱'];
      });
    });
    setState(() {});
  }

  TextEditingController electricityType;

  void http() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Http()));
  }

  @override
  void initState() {
    electricityType = TextEditingController();
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('儲值'),
          centerTitle: true,
          backgroundColor: AppConstants.tenantAppBarAndFontColor,
        ),
        body: landlordID == "" || houseName == ""
            ? Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Card(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('房東')
                        .document('帳號資料')
                        .collection(landlordID)
                        .document('資料')
                        .collection('擁有房間')
                        .document(houseName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(houseName);
                      final data = snapshot.data;
                      return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: SingleChildScrollView(
                            child: Container(
                              color: AppConstants.tenantBackColor,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .88,
                              child: Card(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: 130,
                                        child: Image.asset(
                                            'assets/images/LOGO.jpg')),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => HouseMoney(
                                                          waterMoney:
                                                              data['房屋費用設定']
                                                                  ['水費'],
                                                          eleMoney:
                                                              data['房屋費用設定']
                                                                  ['電費'],
                                                          type: data['房屋費用設定']
                                                                  ['電費儲值']
                                                              ? "房租(含水費)"
                                                              : !data['房屋費用設定']
                                                                      ['電費儲值']
                                                                  ? "房租(含水電費)"
                                                                  : "房租",
                                                          price: data['房屋費用設定']
                                                                  ['電費儲值']
                                                              ? "${int.parse(data['房屋費用設定']['房租']) + int.parse(data['房屋費用設定']['水費'])}"
                                                              : !data['房屋費用設定']
                                                                      ['電費儲值']
                                                                  ? "${int.parse(data['房屋費用設定']['房租']) + int.parse(data['房屋費用設定']['電費']) + int.parse(data['房屋費用設定']['水費'])}"
                                                                  : null)));
                                            },
                                            child: Container(
                                                width: 150,
                                                height: 150,
                                                child: Card(
                                                  color: AppConstants
                                                      .tenantBackColor,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  FontAwesome
                                                                      .home,
                                                                  size: 60,
                                                                ),
                                                                Text('房租'),
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Container(
                                                              child: data['房屋費用設定']
                                                                      ['電費儲值']
                                                                  ? Text(
                                                                      "${int.parse(data['房屋費用設定']['房租']) + int.parse(data['房屋費用設定']['水費'])}/月")
                                                                  : !data['房屋費用設定']
                                                                          [
                                                                          '電費儲值']
                                                                      ? Text(
                                                                          "${int.parse(data['房屋費用設定']['房租']) + int.parse(data['房屋費用設定']['水費']) + int.parse(data['房屋費用設定']['電費'])}/月")
                                                                      : Text(
                                                                          "${data['房屋費用設定']['房租']}/月"),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          FlatButton(
                                            onPressed: null,
                                            child: Container(
                                                width: 150,
                                                height: 150,
                                                child: Card(
                                                  color: AppConstants
                                                      .tenantBackColor,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Entypo.water,
                                                                  size: 60,
                                                                ),
                                                                Text('水費'),
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Text(
                                                                    '${data['房屋費用設定']['水費']}/月\n包含至房租')
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: !data['房屋費用設定']['電費儲值']
                                                ? null
                                                : () {
                                                    Navigator.pop(context);

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    HouseMoney(
                                                                      type:
                                                                          "電費",
                                                                      price: data[
                                                                              '房屋費用設定']
                                                                          [
                                                                          '電費'],
                                                                    )));
                                                  },
                                            child: Container(
                                                width: 150,
                                                height: 150,
                                                child: Card(
                                                  color: AppConstants
                                                      .tenantBackColor,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  MaterialIcons
                                                                      .power,
                                                                  size: 60,
                                                                ),
                                                                Text('電費'),
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: data['房屋費用設定']
                                                                    ['電費儲值']
                                                                ? Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Text(
                                                                      "${data['房屋費用設定']['電費']}/度"),
                                                                )
                                                                : Text(
                                                                    '${data['房屋費用設定']['電費']}/月\n包含至房租'),
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          FlatButton(
                                            onPressed: null,
                                            child: Container(
                                                width: 150,
                                                height: 150,
                                                child: Card(
                                                  color: AppConstants
                                                      .tenantBackColor,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  AntDesign
                                                                      .creditcard,
                                                                  size: 60,
                                                                ),
                                                                Text('自動續費'),
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Container(
                                                              child:
                                                                  Text('敬啟期待'),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    })));
  }
}

class HouseMoney extends StatefulWidget {
  final String type;
  final String price;
  final String waterMoney;
  final String eleMoney;

  HouseMoney({this.type, this.price, this.waterMoney, this.eleMoney});

  @override
  _HouseMoneyState createState() => _HouseMoneyState();
}

class _HouseMoneyState extends State<HouseMoney> {
  TextEditingController electricityType = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  TextEditingController checkCode = TextEditingController();
  PayData payData = PayData();

  @override
  void initState() {
    electricityType = TextEditingController();
    paymentMethod = TextEditingController();
    checkCode = TextEditingController();
    super.initState();
  }

  void creditCard(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Container(
                  height: 70, child: Image.asset("assets/images/LOGO.jpg")),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
              elevation: 4,
              content: Text(
                  '房東天堂採用藍新金流交易系統,消費者刷卡時直接在銀行端系統中交易,房東天堂不會留下您的信用卡資料,以保障您的權益,資料傳輸過程採用嚴密的SSL2048bit加密技術保護'));
        });
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool check = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        width: double.infinity,
        height: 70,
        child: FlatButton(
            onPressed: () {
              if (widget.type == "房租" ||
                  widget.type == "房租(含水電費)" ||
                  widget.type == "房租(含水費)" ||
                  widget.type == "房租(含電費)") {
                if (payData.payTypeView == '信用卡' &&
                    cardNumber != '' &&
                    expiryDate != '' &&
                    cardHolderName != '' &&
                    cvvCode != '') {
                  print('a123');
                } else if (payData.payTypeView == 'ATM') {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ATMPayIng(
                                price: int.parse(widget.price),
                                type: widget.type,
                                eleMoney: widget.eleMoney,
                                waterMoney: widget.waterMoney,
                              )));
                  print('www');
                } else if (payData.payTypeView == '超商繳費') {
                  print(widget.type);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuperMerchantPayment(
                                price: int.parse(widget.price),
                                type: widget.type,
                                eleMoney: widget.eleMoney,
                                waterMoney: widget.waterMoney,
                              )));
                  print('qqq');
                }
              } else {
                if (payData.payTypeView == '信用卡' &&
                    cardNumber != '' &&
                    expiryDate != '' &&
                    cardHolderName != '' &&
                    cvvCode != '') {
                  print('asd');
                } else if (payData.payTypeView == 'ATM' &&
                    electricityType.text != '') {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ATMPayIng(
                                price: int.parse(widget.price),
                                totalPrice: int.parse(widget.price) *
                                    int.parse(electricityType.text),
                                type: widget.type,
                                buyNum: int.parse(electricityType.text),
                              )));
                  print('www');
                } else if (payData.payTypeView == '超商繳費' &&
                    electricityType.text != '') {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuperMerchantPayment(
                                price: int.parse(widget.price),
                                totalPrice: int.parse(widget.price) *
                                    int.parse(electricityType.text),
                                type: widget.type,
                                buyNum: int.parse(electricityType.text),
                              )));
                  print('qqq');
                }
              }
            },
            child: Text(
              '結帳',
              style: TextStyle(color: Colors.white),
            )),
        color: AppConstants.tenantAppBarAndFontColor,
      ),
      appBar: AppBar(
        title: Text('確認價格'),
        centerTitle: true,
        backgroundColor: AppConstants.tenantAppBarAndFontColor,
      ),
      body: widget.type == '房租' ||
              widget.type == '房租(含水費)' ||
              widget.type == '房租(含電費)' ||
              widget.type == '房租(含水電費)'
          ? Container(
              height: MediaQuery.of(context).size.height * .8,
              color: AppConstants.tenantBackColor,
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                icon: Icon(Icons.threesixty),
                                labelText: '繳費方式',
                              ),
                              // isEmpty: _group['color'] == Colors.black,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: payData.data['繳費方式'],
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      payData.data['繳費方式'] = newValue;
                                      payData.payTypeView = newValue;
                                      print(payData.payTypeView);
                                    });
                                  },
                                  items: payData.payType.map((dynamic color) {
                                    return DropdownMenuItem(
                                      value: color['繳費方式'],
                                      child: Text(color['繳費方式']),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )),
                      ),
//發票相關
//                      Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: Container(
//                            width: MediaQuery.of(context).size.width * 0.8,
//                            child: InputDecorator(
//                              decoration: InputDecoration(
//                                icon: Icon(Icons.threesixty),
//                                labelText: '付款資訊',
//                              ),
//                              // isEmpty: _group['color'] == Colors.black,
//                              child: DropdownButtonHideUnderline(
//                                child: DropdownButton(
//                                  value: payData.data['付款資訊'],
//                                  isDense: true,
//                                  onChanged: (newValue) {
//                                    setState(() {
//                                      FocusScope.of(context)
//                                          .requestFocus(FocusNode());
//                                      payData.data['付款資訊'] = newValue;
//                                      payData.paymentInformationView = newValue;
//                                      print(payData.paymentInformationView);
//                                    });
//                                  },
//                                  items: payData.paymentInformation
//                                      .map((dynamic color) {
//                                    return DropdownMenuItem(
//                                      value: color['付款資訊'],
//                                      child: Text(color['付款資訊']),
//                                    );
//                                  }).toList(),
//                                ),
//                              ),
//                            )),
//                      ),

                      payData.payTypeView == '信用卡'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('信用卡資訊'),
                                        IconButton(
                                          icon: Icon(
                                            Icons.info,
                                            color: Colors.grey[500],
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            creditCard(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        width: 400,
                                        child: CreditCardWidget(
                                          cardNumber: cardNumber,
                                          expiryDate: expiryDate,
                                          cardHolderName: cardHolderName,
                                          cvvCode: cvvCode,
                                          showBackView: isCvvFocused,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        child: CreditCardForm(
                                          onCreditCardModelChange:
                                              onCreditCardModelChange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: check,
                                        onChanged: (c) {
                                          setState(() {
                                            check = c;
                                          });
                                        },
                                        checkColor:
                                            AppConstants.tenantBackColor,
                                        activeColor: AppConstants
                                            .tenantAppBarAndFontColor,
                                      ),
                                      Expanded(
                                          child:
                                              Text('同意紀錄本次付款資訊,作為訂單成立時之扣款依據')),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text('按下結帳,表示您已同意'),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImTenant()));
                                            },
                                            child: Text(
                                              '服務條款',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                        Text('與'),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImTenant()));
                                            },
                                            child: Text(
                                              '隱私權',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : payData.payTypeView == 'ATM'
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('ATM'),
                                      Row(
                                        children: <Widget>[
                                          Text('按下結帳,表示您已同意'),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImTenant()));
                                              },
                                              child: Text(
                                                '服務條款',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )),
                                          Text('與'),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImTenant()));
                                              },
                                              child: Text(
                                                '隱私權',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : payData.payTypeView == '超商繳費'
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('超商繳費'),
                                          Row(
                                            children: <Widget>[
                                              Text('按下結帳,表示您已同意'),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ImTenant()));
                                                  },
                                                  child: Text(
                                                    '服務條款',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )),
                                              Text('與'),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ImTenant()));
                                                  },
                                                  child: Text(
                                                    '隱私權',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : payData.payTypeView == '' ||
                                          payData.payTypeView == '請選擇'
                                      ? Container()
                                      : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('消費明細:'),
                      ),
                      Container(
                        width: double.infinity,
                        color: AppConstants.tenantBackColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              child: Text('購買項目:${widget.type}'),
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
                              child: Text('購買月分:${DateTime.now().month}月房租'),
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
                                child: Text('總價:${int.parse(widget.price)}')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * .8,
              color: AppConstants.tenantBackColor,
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('請輸入想要儲值度數'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: electricityType,
                          decoration: InputDecoration(
                              hintText: '請輸入購買度數',
                              labelText: widget.type,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            setState(() {
                              electricityType.text;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                icon: Icon(Icons.threesixty),
                                labelText: '繳費方式',
                              ),
                              // isEmpty: _group['color'] == Colors.black,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: payData.data['繳費方式'],
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      payData.data['繳費方式'] = newValue;
                                      payData.payTypeView = newValue;
                                      print(payData.payTypeView);
                                    });
                                  },
                                  items: payData.payType.map((dynamic color) {
                                    return DropdownMenuItem(
                                      value: color['繳費方式'],
                                      child: Text(color['繳費方式']),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )),
                      ),
//發票相關
//                      Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: Container(
//                            width: MediaQuery.of(context).size.width * 0.8,
//                            child: InputDecorator(
//                              decoration: InputDecoration(
//                                icon: Icon(Icons.threesixty),
//                                labelText: '付款資訊',
//                              ),
//                              // isEmpty: _group['color'] == Colors.black,
//                              child: DropdownButtonHideUnderline(
//                                child: DropdownButton(
//                                  value: payData.data['付款資訊'],
//                                  isDense: true,
//                                  onChanged: (newValue) {
//                                    setState(() {
//                                      FocusScope.of(context)
//                                          .requestFocus(FocusNode());
//                                      payData.data['付款資訊'] = newValue;
//                                      payData.paymentInformationView = newValue;
//                                      print(payData.paymentInformationView);
//                                    });
//                                  },
//                                  items: payData.paymentInformation
//                                      .map((dynamic color) {
//                                    return DropdownMenuItem(
//                                      value: color['付款資訊'],
//                                      child: Text(color['付款資訊']),
//                                    );
//                                  }).toList(),
//                                ),
//                              ),
//                            )),
//                      ),

                      payData.payTypeView == '信用卡'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('信用卡資訊'),
                                        IconButton(
                                          icon: Icon(
                                            Icons.info,
                                            color: Colors.grey[500],
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            creditCard(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        width: 400,
                                        child: CreditCardWidget(
                                          cardNumber: cardNumber,
                                          expiryDate: expiryDate,
                                          cardHolderName: cardHolderName,
                                          cvvCode: cvvCode,
                                          showBackView: isCvvFocused,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        child: CreditCardForm(
                                          onCreditCardModelChange:
                                              onCreditCardModelChange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: check,
                                        onChanged: (c) {
                                          setState(() {
                                            check = c;
                                          });
                                        },
                                        checkColor:
                                            AppConstants.tenantBackColor,
                                        activeColor: AppConstants
                                            .tenantAppBarAndFontColor,
                                      ),
                                      Expanded(
                                          child:
                                              Text('同意紀錄本次付款資訊,作為訂單成立時之扣款依據')),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text('按下結帳,表示您已同意'),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImTenant()));
                                            },
                                            child: Text(
                                              '服務條款',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                        Text('與'),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImTenant()));
                                            },
                                            child: Text(
                                              '隱私權',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : payData.payTypeView == 'ATM'
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('ATM'),
                                      Row(
                                        children: <Widget>[
                                          Text('按下結帳,表示您已同意'),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImTenant()));
                                              },
                                              child: Text(
                                                '服務條款',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )),
                                          Text('與'),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImTenant()));
                                              },
                                              child: Text(
                                                '隱私權',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : payData.payTypeView == '超商繳費'
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('超商繳費'),
                                          Row(
                                            children: <Widget>[
                                              Text('按下結帳,表示您已同意'),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ImTenant()));
                                                  },
                                                  child: Text(
                                                    '服務條款',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )),
                                              Text('與'),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ImTenant()));
                                                  },
                                                  child: Text(
                                                    '隱私權',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : payData.payTypeView == '' ||
                                          payData.payTypeView == '請選擇'
                                      ? Container()
                                      : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('消費明細:'),
                      ),
                      Container(
                        width: double.infinity,
                        color: AppConstants.tenantBackColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              child: Text('購買項目:${widget.type}'),
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
                              child: Text('購買度數:${electricityType.text}'),
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
                              child:
                                  Text('每度價格:${int.parse(widget.price) * 1}'),
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
                                  '總價:${int.parse(widget.price) * int.parse(electricityType.text == '' ? '0' : electricityType.text)}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class Http extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: 'https://www.google.com/',
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: AppConstants.tenantAppBarAndFontColor,
          title: const Text('付款頁面'),
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

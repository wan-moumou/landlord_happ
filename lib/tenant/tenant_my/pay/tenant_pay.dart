import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/payData.dart';
import 'package:landlord_happy/app_const/user.dart';
import 'package:landlord_happy/rules_of_user.dart';

import '../../../http_post.dart';
import 'payIng.dart';

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
  String phoneNUM = '';
  String loginUser = '';
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  User userData = User();
  String nowMonth;
  PayData payData = PayData();

  void getUserName() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection("/房客/帳號資料/$loginUser")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        User newUserData = User(
          name: f['name'],
        );
        setState(() {
          userData.name = newUserData.name;
          landlordID = f['房東姓名'];
          houseName = f['房屋名稱'];
          phoneNUM = f['手機號碼'];
        });
      });
      print(phoneNUM);
    });
  }

  @override
  void initState() {
    nowMonth = DateTime.now().month.toString();
    getUserName();
    super.initState();
  }

  String text;

  Future<String> getA(A, B, C, D, E, F, G) async {
    if (await G) {
      text = nowMonth == '6' ||
              nowMonth == '7' ||
              nowMonth == '8' ||
              nowMonth == '9'
          ? "${int.parse(B) + int.parse(C) + int.parse(D)}"
          : "${int.parse(B) + int.parse(C) + int.parse(F)}";
      setState(() {});
    } else {
      if (await A) {
        text = "${int.parse(B) + int.parse(C)}";
        setState(() {});
      } else {
        text = nowMonth == '6' ||
                nowMonth == '7' ||
                nowMonth == '8' ||
                nowMonth == '9'
            ? text =
                "${int.parse(B) + (int.parse(D) * int.parse(E)) + int.parse(C)}"
            : "${int.parse(B) + int.parse(F) + int.parse(C)}";
        setState(() {});
      }
    }

    return text;
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
                      final data = snapshot.data;
                      getA(
                          data['房屋費用設定']['有電表儲值單位'],
                          data['房屋費用設定']['房租'],
                          data['房屋費用設定']['水費'],
                          data['房屋費用設定']['夏季電費'],
                          data['網關相關']['使用度數'],
                          data['房屋費用設定']['電費'],
                          data['房屋費用設定']['電費每月固定']);
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
                                                      builder: (context) =>
                                                          HouseMoney(
                                                            phoneNUM: phoneNUM,
                                                            waterMoney:
                                                                data['房屋費用設定']
                                                                    ['水費'],
                                                            eleMoney: nowMonth ==
                                                                        '6' ||
                                                                    nowMonth ==
                                                                        '7' ||
                                                                    nowMonth ==
                                                                        '8' ||
                                                                    nowMonth ==
                                                                        '9'
                                                                ? data['房屋費用設定']
                                                                        [
                                                                        '電費每月固定']
                                                                    ? "${int.parse(data['房屋費用設定']['夏季電費'])}"
                                                                    : "${int.parse(data['房屋費用設定']['夏季電費']) * int.parse(data['網關相關']['使用度數'])}"
                                                                : data['房屋費用設定']
                                                                        [
                                                                        '電費每月固定']
                                                                    ? "${int.parse(data['房屋費用設定']['電費'])}"
                                                                    : "${int.parse(data['房屋費用設定']['電費']) * int.parse(data['網關相關']['使用度數'])}",
                                                            type: data['房屋費用設定']
                                                                    ['有電表儲值單位']
                                                                ? "房租(含水費)"
                                                                : !data['房屋費用設定']
                                                                        [
                                                                        '有電表儲值單位']
                                                                    ? "房租(含水電費)"
                                                                    : "房租",
                                                            price: text,
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
                                                                child:
                                                                    Text(text)),
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
                                                                  '${data['房屋費用設定']['水費']}/月\n包含至房租'))),
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
                                            onPressed:
                                                !data['房屋費用設定']['有電表儲值單位']
                                                    ? null
                                                    : () {
                                                        Navigator.pop(context);

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HouseMoney(
                                                                          phoneNUM:
                                                                              phoneNUM,
                                                                          type:
                                                                              "電費",
                                                                          price: nowMonth == '6' || nowMonth == '7' || nowMonth == '8' || nowMonth == '9'
                                                                              ? data['房屋費用設定']['夏季電費']
                                                                              : data['房屋費用設定']['電費'],
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
                                                                    ['有電表儲值單位']
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child: Text(nowMonth == '6' ||
                                                                            nowMonth ==
                                                                                '7' ||
                                                                            nowMonth ==
                                                                                '8' ||
                                                                            nowMonth ==
                                                                                '9'
                                                                        ? "${data['房屋費用設定']['夏季電費']}/度"
                                                                        : "${data['房屋費用設定']['電費']}/度"),
                                                                  )
                                                                : Text(nowMonth == '6' ||
                                                                        nowMonth ==
                                                                            '7' ||
                                                                        nowMonth ==
                                                                            '8' ||
                                                                        nowMonth ==
                                                                            '9'
                                                                    ? "${data['房屋費用設定']['夏季電費']}/度\n包含至房租"
                                                                    : '${data['房屋費用設定']['電費']}/月\n包含至房租'),
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
  final String phoneNUM;

  HouseMoney(
      {this.type, this.price, this.waterMoney, this.eleMoney, this.phoneNUM});

  @override
  _HouseMoneyState createState() => _HouseMoneyState();
}

class _HouseMoneyState extends State<HouseMoney> {
  TextEditingController electricityType = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  TextEditingController checkCode = TextEditingController();
  PayData payData = PayData();
  var loginUser;

  @override
  void initState() {
    electricityType = TextEditingController();
    paymentMethod = TextEditingController();
    checkCode = TextEditingController();
    getUser();
    super.initState();
  }

  void getUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      loginUser = user.email;
      print(loginUser);
    }
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
                  '房東天堂採用藍新金流交易系統,消費者刷卡時直接在銀行端系統中交易,房東天堂不會留下您的信用卡資料,以保障您的權益,資料傳輸過程採用嚴密的AES-CBC256加密技術以及SHA256加密技術保護'));
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
                if (payData.payTypeView == '信用卡' && check) {
                  Navigator.pop(context);

                  HttpPost().postData(
                      'ItemDesc=${widget.type}&',
                      'CREDIT=1',
                      "Email=$loginUser&",
                      "Amt=${(1.028 * int.parse(widget.price)).round()}&",
                      'MerchantOrderNo=A01${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}&',
                      widget.eleMoney,
                      widget.waterMoney,
                      "${int.parse(widget.price) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paying(
                                merchantOrderNo:
                                    'A01${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}',
                                type: widget.type,
                                price: int.parse(widget.price),
                                waterMoney: widget.waterMoney,
                                eleMoney: widget.eleMoney,
                                payType: '信用卡',
                              )));
                } else if (payData.payTypeView == 'ATM') {
                  Navigator.pop(context);
                  HttpPost().postData(
                      'ItemDesc=${widget.type}&',
                      'VACC=1',
                      "Email=$loginUser&",
                      "Amt=${int.parse('20') + int.parse(widget.price)}&",
                      'MerchantOrderNo=A01${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}&',
                      widget.eleMoney,
                      widget.waterMoney,
                      "${int.parse(widget.price) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paying(
                                merchantOrderNo:
                                    'A01${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}',
                                type: widget.type,
                                price: int.parse(widget.price),
                                waterMoney: widget.waterMoney,
                                eleMoney: widget.eleMoney,
                                payType: "ATM",
                              )));
                } else if (payData.payTypeView == '超商繳費') {
                  Navigator.pop(context);
                  HttpPost().postData(
                      'ItemDesc=${widget.type}&',
                      'CVS=1',
                      "Email=$loginUser&",
                      "Amt=${int.parse('28') + int.parse(widget.price)}&",
                      'MerchantOrderNo=A01${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}&',
                      widget.eleMoney,
                      widget.waterMoney,
                      "${int.parse(widget.price) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paying(
                                merchantOrderNo:
                                    'A01${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}',
                                type: widget.type,
                                price: int.parse(widget.price),
                                waterMoney: widget.waterMoney,
                                eleMoney: widget.eleMoney,
                                payType: '超商繳費',
                              )));
                }
              } else {
                if (payData.payTypeView == '信用卡' && check) {
                  Navigator.pop(context);
                  HttpPost().postData(
                      'ItemDesc=${widget.type}&',
                      'CREDIT=1',
                      "Email=$loginUser&",
                      "Amt=${(1.028 * int.parse(electricityType.text == '' ? '0' : electricityType.text)).round()}&",
                      'MerchantOrderNo=A03${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}&',
                      '0',
                      '0',
                      "0");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paying(
                                merchantOrderNo:
                                    'A03${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}',
                                type: widget.type,
                                totalPrice: int.parse(electricityType.text),
                                waterMoney: widget.waterMoney,
                                eleMoney: widget.eleMoney,
                                buyNum: int.parse(electricityType.text),
                                payType: '信用卡',
                              )));
                } else if (payData.payTypeView == 'ATM' &&
                    electricityType.text != '') {
                  Navigator.pop(context);
                  HttpPost().postData(
                      'ItemDesc=${widget.type}&',
                      'VACC=1',
                      "Email=$loginUser&",
                      "Amt=${int.parse('20') + int.parse(electricityType.text)}&",
                      'MerchantOrderNo=A03${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}&',
                      '0',
                      '0',
                      "0");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paying(
                                merchantOrderNo:
                                    'A03${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}',
                                type: widget.type,
                                totalPrice: int.parse(electricityType.text),
                                waterMoney: widget.waterMoney,
                                eleMoney: widget.eleMoney,
                                buyNum: int.parse(electricityType.text),
                                payType: "ATM",
                              )));
                } else if (payData.payTypeView == '超商繳費' &&
                    electricityType.text != '') {
                  Navigator.pop(context);
                  HttpPost().postData(
                      'ItemDesc=${widget.type}&',
                      'CVS=1',
                      "Email=$loginUser&",
                      "Amt=${int.parse('28') + int.parse(electricityType.text)}&",
                      'MerchantOrderNo=A03${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}&',
                      '0',
                      '0',
                      "0");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paying(
                                merchantOrderNo:
                                    'A03${widget.phoneNUM}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}',
                                type: widget.type,
                                totalPrice: int.parse(electricityType.text),
                                waterMoney: widget.waterMoney,
                                eleMoney: widget.eleMoney,
                                buyNum: int.parse(electricityType.text),
                                payType: '超商繳費',
                              )));
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
                            payData.payTypeView == '超商繳費'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    child: Text('手續費: 28'),
                                  )
                                : payData.payTypeView == 'ATM'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, bottom: 10),
                                        child: Text('手續費: 20'),
                                      )
                                    : payData.payTypeView == '信用卡'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10, bottom: 10),
                                            child: Text('手續費: 2.8%'),
                                          )
                                        : Container(),
                            payData.payTypeView == '超商繳費'
                                ? SizedBox(
                                    child: Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                : payData.payTypeView == 'ATM'
                                    ? SizedBox(
                                        child: Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    : Container(),
                            payData.payTypeView == '超商繳費'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    child: Text(
                                        '應付金額:${int.parse('28') + int.parse(widget.price)}'),
                                  )
                                : payData.payTypeView == 'ATM'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, bottom: 10),
                                        child: Text(
                                            '應付金額:${int.parse('20') + int.parse(widget.price)}'),
                                      )
                                    : payData.payTypeView == '信用卡'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10, bottom: 10),
                                            child: Text(
                                                '應付金額:${(1.028 * int.parse(widget.price == '' ? '0' : widget.price)).round()}'))
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10, bottom: 10),
                                            child:
                                                Text(" 應付金額: ${widget.price}"),
                                          ),
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
                        child: Text('請輸入想要儲值金額'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: electricityType,
                          decoration: InputDecoration(
                              hintText: '請輸入金額',
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
                              child: Text('購買項目:${widget.type}預儲值'),
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
                              child: Text('儲值金額:${electricityType.text}'),
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
                              child: Row(
                                children: <Widget>[
                                  Text('預估每度價格:${int.parse(widget.price) * 1}'),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      '(非夏季電費與夏季電費會有差別)',
                                      style: TextStyle(
                                          fontSize: Adapt.px(20),
                                          color: Colors.grey),
                                    ),
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
                            payData.payTypeView == '超商繳費'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    child: Text('手續費: 28'),
                                  )
                                : payData.payTypeView == 'ATM'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, bottom: 10),
                                        child: Text('手續費: 20'),
                                      )
                                    : payData.payTypeView == '信用卡'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10, bottom: 10),
                                            child: Text('手續費: 2.8%'),
                                          )
                                        : Container(),
                            payData.payTypeView == '超商繳費'
                                ? SizedBox(
                                    child: Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                : payData.payTypeView == 'ATM'
                                    ? SizedBox(
                                        child: Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    : Container(),
                            payData.payTypeView == '超商繳費'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    child: Text(
                                        '應付金額:${int.parse('28') + int.parse(electricityType.text == '' ? '0' : electricityType.text)}'),
                                  )
                                : payData.payTypeView == 'ATM'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, bottom: 10),
                                        child: Text(
                                            '應付金額:${int.parse('20') + int.parse(electricityType.text == '' ? '0' : electricityType.text)}'),
                                      )
                                    : payData.payTypeView == '信用卡'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10, bottom: 10),
                                            child: Text(
                                                '應付金額:${(1.028 * int.parse(electricityType.text == '' ? '0' : electricityType.text)).round()}'),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10, bottom: 10),
                                            child: Text(electricityType.text ==
                                                    ''
                                                ? " 應付金額:'0'"
                                                : " 應付金額: ${electricityType.text}"),
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

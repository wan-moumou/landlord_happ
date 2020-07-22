import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/rules_of_user.dart';

class ATMPayIng extends StatefulWidget {
  final int buyNum;
  final int price;
  final int totalPrice;
  final String type;
  final String waterMoney;
  final String eleMoney;

  ATMPayIng(
      {this.buyNum,
      this.price,
      this.totalPrice,
      this.type,
      this.eleMoney,
      this.waterMoney});

  @override
  _ATMPayIngState createState() => _ATMPayIngState();
}

class _ATMPayIngState extends State<ATMPayIng> {
  String loginUser = '';
  String landlordID = '';
  String houseName = '';
  String remainingDegree = '';
  String myName = '';
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  @override
  void initState() {
    getUserName();
    super.initState();
  }

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
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
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
    print(loginUser);

    await _firestore
        .collection("/房客/帳號資料/$loginUser")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        landlordID = f['房東姓名'];
        houseName = f['房屋名稱'];
        myName = f['name'];
        remainingDegree = f['剩餘度數'];
      });
    });
    setState(() {});
  }

  var ss;

//一般結帳
  Future setData() async {
    wait(context);
    int documentLength;
    int documentLengthType;
    final aa = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = aa.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser')
        .document("資料")
        .updateData({
      '剩餘度數':
          "${int.parse(remainingDegree == '' ? '0' : remainingDegree) + int.parse(widget.buyNum.toString())}",
    });
    ss =
        "${int.parse(remainingDegree == '' ? '0' : remainingDegree) + int.parse(widget.buyNum.toString())}";
    print(ss);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '購買度數': widget.buyNum.toString(),
      '每度價格': widget.price.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });

    final bb = await Firestore.instance
        .collection(
            '房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月${widget.type}')
        .getDocuments();
    documentLengthType = bb.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月${widget.type}')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '購買度數': widget.buyNum.toString(),
      '每度價格': widget.price.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //同步加入房東資料
    final dd = await Firestore.instance
        .collection(
            '房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月${widget.type}')
        .getDocuments();
    documentLengthType = dd.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月${widget.type}')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '購買度數': widget.buyNum.toString(),
      '每度價格': widget.price.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ee = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ee.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '購買度數': widget.buyNum.toString(),
      '每度價格': widget.price.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //房間內新增資料
    final qq = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月${widget.type}')
        .getDocuments();
    documentLengthType = qq.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月${widget.type}')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '購買度數': widget.buyNum.toString(),
      '每度價格': widget.price.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ww = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ww.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '購買度數': widget.buyNum.toString(),
      '每度價格': widget.price.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    Navigator.pop(context);
    Navigator.pop(context);
  }

//純房租
  Future housePay() async {
    wait(context);
    int documentLength;
    int documentLengthType;
    int documentLengthHouseMoney;

    final dd = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = dd.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });

    final cc = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = cc.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final aa = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = aa.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });

    final ee = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = ee.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //房間內資料
    final qq = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthType = qq.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月${widget.type}')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ww = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ww.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    Navigator.pop(context);
    Navigator.pop(context);
  }

  //房租(含水費)
  Future waterMoney() async {
    wait(context);
    int documentLength;
    int documentLengthType;
    int documentLengthHouseMoney;

    final aa = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = aa.documents.length + 1;
    print(documentLength);
    final cc = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = cc.documents.length + 1;
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final bb = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
        .getDocuments();
    documentLengthType = bb.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //加入房東資料
    final dd = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = dd.documents.length + 1;
    print(documentLength);
    final ee = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = ee.documents.length + 1;
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ff = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月水費')
        .getDocuments();
    documentLengthType = ff.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月水費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //房間內資料
    final qq = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月水費')
        .getDocuments();
    documentLengthType = qq.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月水費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final uu = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthType = uu.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ww = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ww.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': "${int.parse(widget.price.toString())}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    Navigator.pop(context);
    Navigator.pop(context);
  }

  //房租(含電費)
  Future eleMoney() async {
    wait(context);
    int documentLength;
    int documentLengthType;
    int documentLengthHouseMoney;

    final aa = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = aa.documents.length + 1;
    print(documentLength);
    final cc = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = cc.documents.length + 1;
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser')
        .document("資料")
        .updateData({
      '剩餘度數':
          "${int.parse(remainingDegree) + int.parse(widget.buyNum.toString())}",
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final bb = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
        .getDocuments();
    documentLengthType = bb.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //加入房東資料
    final dd = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = dd.documents.length + 1;
    print(documentLength);
    final ee = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = ee.documents.length + 1;
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ff = await Firestore.instance
        .collection('v${DateTime.now().month}月電費')
        .getDocuments();
    documentLengthType = ff.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月電費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //房間資料

    final qq = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月電費')
        .getDocuments();
    documentLengthType = qq.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月電費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final uu = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthType = uu.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ww = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ww.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': "${int.parse(widget.price.toString())}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    Navigator.pop(context);
    Navigator.pop(context);
  }

//含水電
  Future eleMoneyAddWaterMoney() async {
    wait(context);
    int documentLength;
    int documentLengthType;
    int documentLengthHouseMoney;

    final aa = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = aa.documents.length + 1;
    print(documentLength);
    final cc = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = cc.documents.length + 1;
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final bb = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
        .getDocuments();
    documentLengthType = bb.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final dd = await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
        .getDocuments();
    documentLengthType = dd.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //加入房東資料
    final ee = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ee.documents.length + 1;
    print(documentLength);
    final ff = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthHouseMoney = ff.documents.length + 1;
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthHouseMoney")
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final gg = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月電費')
        .getDocuments();
    documentLengthType = gg.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月電費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final hh = await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月水費')
        .getDocuments();
    documentLengthType = hh.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月水費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    //房間資料
    final qq = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月水費')
        .getDocuments();
    documentLengthType = qq.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月水費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ii = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月電費')
        .getDocuments();
    documentLengthType = ii.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月電費')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final uu = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .getDocuments();
    documentLengthType = uu.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLengthType")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    final ww = await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .getDocuments();
    documentLength = ww.documents.length + 1;
    print(documentLength);
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$documentLength")
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': "${int.parse(widget.price.toString())}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '藍新金流支付方式': 'ATM轉帳'
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String nowTime;

  void _changed(value) {
    groupValue = value;
    print(value);
    setState(() {});
  }

  String groupValue = "華南銀行";
  String value1 = "華南銀行";
  String value2 = "台新銀行";
  String value3 = "兆豐銀行";
  String value4 = "台灣銀行";
  int time = DateTime.now().day + 1;
  bool check = false;

  Future goPay() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('付款'),
          centerTitle: true,
          backgroundColor: AppConstants.tenantAppBarAndFontColor,
        ),
        body: widget.type == "房租" ||
                widget.type == "房租(含水電費)" ||
                widget.type == "房租(含水費)" ||
                widget.type == "房租(含電費)"
            ? Container(
                color: AppConstants.tenantBackColor,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              color: AppConstants.tenantBackColor,
                              width: double.infinity,
                              height: 100,
                              child: Image.asset('assets/images/LOGO綠.jpg')),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '應付金額:NT\$${widget.price}元',
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
                                color: AppConstants.tenantBackColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text(
                                          '購買月份:${DateTime.now().month}月${widget.type}'),
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
                                      child: Text('總價:NT\$${widget.price}元'),
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
                                    child: Text('ATM轉帳'),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('華南銀行'),
                                        value: value1,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('台新銀行'),
                                        value: value2,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('兆豐銀行'),
                                        value: value3,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('台灣銀行'),
                                        value: value4,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
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
                                child: Text('1.如您持有以上金融機構發行之新榮卡,'
                                    '您可以選擇取得該金融機構之ATM轉帳帳號,'
                                    '並至該金融機構之ATM自動櫃員機或透過網路'
                                    'ATM進行交易轉帳可享有轉帳免跨行轉帳手續費.'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '2.若無以上金融機構之行之金融卡,可依您喜好選擇其中一家金融機構取得ATM轉帳帳號.'),
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
                                          AppConstants.tenantAppBarAndFontColor,
                                      onPressed: !check
                                          ? null
                                          : () {
                                              setState(() {
                                                nowTime =
                                                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                                              });
                                              if (widget.type == '房租(含水費)') {
                                                waterMoney();
                                              } else if (widget.type ==
                                                  '房租(含電費)') {
                                                eleMoney();
                                              } else if (widget.type ==
                                                  '房租(含水電費)') {
                                                eleMoneyAddWaterMoney();
                                              } else if (widget.type == '房租') {
                                                housePay();
                                                print('object');
                                              } else {}
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
                ))
            : Container(
                color: AppConstants.tenantBackColor,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              color: AppConstants.tenantBackColor,
                              width: double.infinity,
                              height: 100,
                              child: Image.asset('assets/images/LOGO綠.jpg')),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '應付金額:NT\$${widget.totalPrice}元',
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
                                color: AppConstants.tenantBackColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text('購買項目:${widget.type}儲值'),
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
                                      child: Text('購買度數:${widget.buyNum}度'),
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
                                      child: Text('每度價格:NT\$${widget.price}元'),
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
                                          Text('總價:NT\$${widget.totalPrice}元'),
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
                                    child: Text('ATM轉帳'),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('華南銀行'),
                                        value: value1,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('台新銀行'),
                                        value: value2,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('兆豐銀行'),
                                        value: value3,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                        title: Text('台灣銀行'),
                                        value: value4,
                                        groupValue: groupValue,
                                        onChanged: _changed),
                                  ),
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
                                child: Text('1.如您持有以上金融機構發行之新榮卡,'
                                    '您可以選擇取得該金融機構之ATM轉帳帳號,'
                                    '並至該金融機構之ATM自動櫃員機或透過網路'
                                    'ATM進行交易轉帳可享有轉帳免跨行轉帳手續費.'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '2.若無以上金融機構之行之金融卡,可依您喜好選擇其中一家金融機構取得ATM轉帳帳號.'),
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
                                          AppConstants.tenantAppBarAndFontColor,
                                      onPressed: !check
                                          ? null
                                          : () {
                                              setState(() {
                                                nowTime =
                                                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                                              });
                                              setData();
//                                              Navigator.push(
//                                                  context,
//                                                  MaterialPageRoute(
//                                                      builder: (context) =>
//                                                          Http()));
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

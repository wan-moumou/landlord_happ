import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/tenant/tenant_my/tenant_my_page.dart';

class Paying extends StatefulWidget {
  final int buyNum;
  final int price;
  final int totalPrice;
  final String type;
  final String waterMoney;
  final String eleMoney;
  final String merchantOrderNo;
  final payType;

  Paying(
      {this.buyNum,
      this.price,
      this.payType,
      this.merchantOrderNo,
      this.totalPrice,
      this.type,
      this.eleMoney,
      this.waterMoney});

  @override
  _PayingState createState() => _PayingState();
}

class _PayingState extends State<Paying> {
  String loginUser = '';
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
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
        remainingDegree = f['剩餘金額'];
      });
    });
    setState(() {});
  }

  String remainingDegree = '';

//一般結帳
  Future setData() async {
    wait(context);
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser')
        .document("資料")
        .updateData({
      '剩餘金額':
          "${int.parse(remainingDegree) + int.parse(widget.buyNum.toString())}",
    });

    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection(
            '房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月${widget.type}')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //同步加入房東資料

    await Firestore.instance
        .collection(
            '房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月${widget.type}')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //房間內新增資料

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月${widget.type}')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.totalPrice.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細收入資料更新': true, '詳細支出資料更新': false});

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
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //房間內資料

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月${widget.type}')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細收入資料更新': true, '詳細支出資料更新': false});
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
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //加入房東資料
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月水費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //房間內資料
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月水費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': "${int.parse(widget.price.toString())}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細收入資料更新': true, '詳細支出資料更新': false});
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
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //加入房東資料
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月電費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //房間資料
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月電費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': "${int.parse(widget.price.toString())}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細收入資料更新': true, '詳細支出資料更新': false});
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
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月電費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月水費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //加入房東資料

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價': widget.price.toString(),
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': widget.type.toString(),
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月電費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection('房東/帳號資料/$landlordID/帳務資料/${DateTime.now().month}月水費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    //房間資料

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月水費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.waterMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月電費')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': widget.eleMoney,
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月房租')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價':
          "${int.parse(widget.price.toString()) - int.parse(widget.eleMoney) - int.parse(widget.waterMoney)}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });

    await Firestore.instance
        .collection(
            '/房東/帳號資料/$landlordID/資料/擁有房間/$houseName/${DateTime.now().month}月')
        .document(widget.merchantOrderNo)
        .setData({
      '類型': "${DateTime.now().month}月${widget.type}",
      '總價': "${int.parse(widget.price.toString())}",
      '付款人': myName,
      '房間名稱': houseName,
      '購買時間': nowTime,
      '排列': DateTime.now().toUtc(),
      '訂單編號': widget.merchantOrderNo,
      '藍新金流支付方式': widget.payType,
      '已繳款': widget.payType == '信用卡' ? true : false
    });
    await Firestore.instance
        .collection("/房東/帳號資料/$landlordID")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細收入資料更新': true, '詳細支出資料更新': false});
    await Firestore.instance
        .collection("/房客/帳號資料/$loginUser")
        .document('帳務資料')
        .setData({'帳務更新': true, '詳細資料更新': true});
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String nowTime;

  @override
  void initState() {
    getUserName();
    Timer(Duration(seconds: 2), () {
      setState(() {
        title = '準備完成...加密中..';
      });

      widget.type == "房租" ||
              widget.type == "房租(含水電費)" ||
              widget.type == "房租(含水費)" ||
              widget.type == "房租(含電費)"
          ? saveRentData()
          : saveData();
    });
    super.initState();
  }

  Future saveRentData() async {
    setState(() {
      nowTime =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    });
    if (widget.type == '房租(含水費)') {
      await waterMoney();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Web()));
    } else if (widget.type == '房租(含電費)') {
      await eleMoney();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Web()));
    } else if (widget.type == '房租(含水電費)') {
      await eleMoneyAddWaterMoney();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Web()));
    } else if (widget.type == '房租') {
      housePay();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Web()));
      print('object');
    } else {}
  }

  Future saveData() async {
    setState(() {
      nowTime =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    });
    await setData();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Web()));
  }

  int time = DateTime.now().day + 1;
  bool check = false;
  String title = '正在準備...請勿關閉視窗';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.tenantBackColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/LOGO綠.jpg'),
              Text(title),
            ],
          ),
        ),
      ),
    );
//      Scaffold(
//        appBar: AppBar(
//          title: Text('付款'),
//          centerTitle: true,
//          backgroundColor: AppConstants.tenantAppBarAndFontColor,
//        ),
//        body: widget.type == "房租" ||
//                widget.type == "房租(含水電費)" ||
//                widget.type == "房租(含水費)" ||
//                widget.type == "房租(含電費)"
//            ? Container(
//                color: AppConstants.tenantBackColor,
//                width: double.infinity,
//                height: MediaQuery.of(context).size.height * 1,
//                child: SingleChildScrollView(
//                  child: Card(
//                    margin: EdgeInsets.all(10),
//                    child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Container(
//                              color: AppConstants.tenantBackColor,
//                              width: double.infinity,
//                              height: 100,
//                              child: Image.asset('assets/images/LOGO綠.jpg')),
//                          Padding(
//                            padding: const EdgeInsets.all(20),
//                            child: Text(
//                              '應付金額:NT\$${widget.price}元',
//                              style: TextStyle(
//                                  fontSize: Adapt.px(40),
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ),
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                width: double.infinity,
//                                color: AppConstants.tenantBackColor,
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child: Text(
//                                          '購買月份:${DateTime.now().month}月${widget.type}'),
//                                    ),
//                                    SizedBox(
//                                      child: Container(
//                                        width: double.infinity,
//                                        height: 1,
//                                        color: Colors.grey[400],
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child: Text('總價:NT\$${widget.price}元'),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Text('藍新金流支付方式:'),
//                                  Container(
//                                    color: Colors.yellow,
//                                    child: Text('超商條碼繳費'),
//                                  )
//                                ],
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text('1.確認送出交易後您將取得超商繳費代碼,您可以至全台'
//                                    '[7-11,全家,OK超商,萊爾富]店內之多美體機台'
//                                    '(ibon,FamiPort,OK-go,Life-ET)上列印繳費單至超商櫃檯繳費.'),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text(
//                                  '3.繳費期限:${DateTime.now().year}-${DateTime.now().month}-$time  23:59:59',
//                                  style: TextStyle(color: Colors.red),
//                                ),
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text(
//                                  '您的警覺是防範詐騙交易最有效的防線,請務必確認您目前要付款的對象與商品交易的對象是一致的,以免被有心詐騙者利用.',
//                                  style: TextStyle(
//                                      color: Colors.red,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text('填寫付款人信箱:'),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Container(
//                                    width:
//                                        MediaQuery.of(context).size.width * .4,
//                                    height: 50,
//                                    child: TextField(
//                                      keyboardType: TextInputType.emailAddress,
//                                      decoration: InputDecoration(
//                                          border: OutlineInputBorder(),
//                                          labelText: '信箱'),
//                                    )),
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Checkbox(
//                                    onChanged: (bool value) {
//                                      setState(() {
//                                        check = value;
//                                      });
//                                    },
//                                    value: check,
//                                  ),
//                                  Expanded(
//                                      child: Text(
//                                    '請再次確認您的[訂單資訊]及[付款資訊],付款完成後藍新金流將發送通知信至您的信箱',
//                                    style: TextStyle(
//                                      color:
//                                          check ? Colors.black54 : Colors.red,
//                                    ),
//                                  )),
//                                ],
//                              ),
//                              FlatButton(
//                                  onPressed: () {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) => BlueNew()));
//                                  },
//                                  child: Text(
//                                    '查看藍新金流第三方支付金流平台服務條款',
//                                    style: TextStyle(color: Colors.blueAccent),
//                                  )),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  FlatButton(
//                                      color:
//                                          AppConstants.tenantAppBarAndFontColor,
//                                      onPressed: !check
//                                          ? null
//                                          : () {
//                                              setState(() {
//                                                nowTime =
//                                                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
//                                              });
//                                              if (widget.type == '房租(含水費)') {
//                                                waterMoney();
//                                              } else if (widget.type ==
//                                                  '房租(含電費)') {
//                                                eleMoney();
//                                              } else if (widget.type ==
//                                                  '房租(含水電費)') {
//                                                eleMoneyAddWaterMoney();
//                                              } else if (widget.type == '房租') {
//                                                housePay();
//                                              } else {
//                                                setData();
//                                              }
//                                            },
//                                      child: Text(
//                                        '以閱讀定同意服務條款,確認送出',
//                                        style: TextStyle(color: Colors.white),
//                                      )),
//                                ],
//                              )
//                            ],
//                          ),
//                        ]),
//                  ),
//                ))
//            : Container(
//                color: AppConstants.tenantBackColor,
//                width: double.infinity,
//                height: MediaQuery.of(context).size.height * 1,
//                child: SingleChildScrollView(
//                  child: Card(
//                    margin: EdgeInsets.all(10),
//                    child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Container(
//                              color: AppConstants.tenantBackColor,
//                              width: double.infinity,
//                              height: 100,
//                              child: Image.asset('assets/images/LOGO綠.jpg')),
//                          Padding(
//                            padding: const EdgeInsets.all(20),
//                            child: Text(
//                              '應付金額:NT\$${widget.totalPrice}元',
//                              style: TextStyle(
//                                  fontSize: Adapt.px(40),
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ),
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                width: double.infinity,
//                                color: AppConstants.tenantBackColor,
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child: Text('購買項目:${widget.type}預儲值'),
//                                    ),
//                                    SizedBox(
//                                      child: Container(
//                                        width: double.infinity,
//                                        height: 1,
//                                        color: Colors.grey[400],
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child: Text('儲值金額:${widget.buyNum}'),
//                                    ),
//                                    SizedBox(
//                                      child: Container(
//                                        width: double.infinity,
//                                        height: 1,
//                                        color: Colors.grey[400],
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child:
//                                      Row(
//                                        children: <Widget>[
//                                          Text('預估每度價格:${widget.price}'),
//                                          Padding(
//                                            padding: const EdgeInsets.only(left: 10),
//                                            child: Text('(非夏季電費與夏季電費會有差別)', style: TextStyle(
//                                                fontSize: Adapt.px(20), color: Colors.grey),),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                    SizedBox(
//                                      child: Container(
//                                        width: double.infinity,
//                                        height: 1,
//                                        color: Colors.grey[400],
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child: Text(
//                                          '手續費: 15'),
//                                    ),
//                                     SizedBox(
//                                      child: Container(
//                                        width: double.infinity,
//                                        height: 1,
//                                        color: Colors.grey[400],
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 15, top: 10, bottom: 10),
//                                      child: Text(
//                                          '應付金額:${widget.totalPrice}'),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Text('藍新金流支付方式:'),
//                                  Container(
//                                    color: Colors.yellow,
//                                    child: Text('超商條碼繳費'),
//                                  )
//                                ],
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text('1.確認送出交易後您將取得超商繳費代碼,您可以至全台'
//                                    '[7-11,全家,OK超商,萊爾富]店內之多美體機台'
//                                    '(ibon,FamiPort,OK-go,Life-ET)上列印繳費單至超商櫃檯繳費.'),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text(
//                                  '3.繳費期限:${DateTime.now().year}-${DateTime.now().month}-$time  23:59:59',
//                                  style: TextStyle(color: Colors.red),
//                                ),
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text(
//                                  '您的警覺是防範詐騙交易最有效的防線,請務必確認您目前要付款的對象與商品交易的對象是一致的,以免被有心詐騙者利用.',
//                                  style: TextStyle(
//                                      color: Colors.red,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                              ),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text('填寫付款人信箱:'),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Container(
//                                    width:
//                                        MediaQuery.of(context).size.width * .4,
//                                    height: 50,
//                                    child: TextField(
//                                      keyboardType: TextInputType.emailAddress,
//                                      decoration: InputDecoration(
//                                          border: OutlineInputBorder(),
//                                          labelText: '信箱'),
//                                    )),
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Checkbox(
//                                    onChanged: (bool value) {
//                                      setState(() {
//                                        check = value;
//                                      });
//                                    },
//                                    value: check,
//                                  ),
//                                  Expanded(
//                                      child: Text(
//                                    '請再次確認您的[訂單資訊]及[付款資訊],付款完成後藍新金流將發送通知信至您的信箱',
//                                    style: TextStyle(
//                                      color:
//                                          check ? Colors.black54 : Colors.red,
//                                    ),
//                                  )),
//                                ],
//                              ),
//                              FlatButton(
//                                  onPressed: () {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) => BlueNew()));
//                                  },
//                                  child: Text(
//                                    '查看藍新金流第三方支付金流平台服務條款',
//                                    style: TextStyle(color: Colors.blueAccent),
//                                  )),
//                              SizedBox(
//                                child: Container(
//                                  width: double.infinity,
//                                  height: 1,
//                                  color: Colors.grey[400],
//                                ),
//                              ),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  FlatButton(
//                                      color:
//                                          AppConstants.tenantAppBarAndFontColor,
//                                      onPressed: !check
//                                          ? null
//                                          : () {
//                                              setState(() {
//                                                nowTime =
//                                                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
//                                              });
//                                              setData();
//                                            },
//                                      child: Text(
//                                        '以閱讀定同意服務條款,確認送出',
//                                        style: TextStyle(color: Colors.white),
//                                      )),
//                                ],
//                              )
//                            ],
//                          ),
//                        ]),
//                  ),
//                )));
  }
}

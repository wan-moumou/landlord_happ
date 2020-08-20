import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/messages_data.dart';
import 'package:screenshot/screenshot.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  void initState() {
    getData();
    getCurrentTenantEmail();
    print(tenantEmail);
    super.initState();
  }

  String ok = '提交';

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * .1,
            child: Text(
              '傳送完成',
              style: TextStyle(
                  fontSize: Adapt.px(50),
                  color: AppConstants.appBarAndFontColor),
            ),
          );
        });
  }

  TextEditingController replyController = TextEditingController();

  void getCurrentTenantEmail() async {
    await Firestore.instance
        .collection('/房東/帳號資料/$loginUser/資料/擁有房間')
        .document(currentRoomName)
        .get()
        .then((value) => tenantEmail = value['房客帳號']);
  }

  void upData() async {
    try {
      await Firestore.instance
          .collection('/房東/帳號資料/$loginUser/資料/聯絡房客/$currentID/對話內容')
          .document(DateTime.now().toUtc().toIso8601String())
          .setData({
        '回覆內容': replyController.text ?? '',
        '生成時間': DateTime.now(),
        '我是房東': true,
        '回報時間':
            "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
      });
    } catch (e) {}
    await Firestore.instance
        .collection('/房客/帳號資料/$tenantEmail/資料/聯絡房東/$currentID/對話內容')
        .document(DateTime.now().toUtc().toIso8601String())
        .setData({
      '回覆內容': replyController.text ?? '',
      '生成時間': DateTime.now(),
      '我是房東': true,
      '回報時間':
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
    });

    replyController.clear();
  }

  Future saveData() async {
    await saveImages();
    await Firestore.instance
        .collection('房東')
        .document('帳號資料')
        .collection(loginUser)
        .document('資料')
        .collection('聯絡房客')
        .document(nowTime)
        .setData({
      '回報類型': returnTY,
      '房客姓名': tenantName,
      '房間名稱': selectRoomName,
      '回報內容': description.text,
      'url': imageUrl,
      '處理標籤': false,
      '回覆內容': replyController.text ?? '',
      '生成時間': DateTime.now(),
      '回報時間':
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日",
      '房東帳號': loginUser,
      '房客帳號': tenantEmail,
      '退租': false
    });
    await Firestore.instance
        .collection('房客')
        .document('帳號資料')
        .collection(tenantEmail)
        .document('資料')
        .collection('聯絡房東')
        .document(nowTime)
        .setData({
      '回報類型': returnTY,
      '房客姓名': tenantName,
      '房間名稱': selectRoomName,
      '回報內容': description.text,
      'url': imageUrl,
      '處理標籤': false,
      '回覆內容': replyController.text ?? '',
      '生成時間': DateTime.now(),
      '回報時間':
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日",
      '房東帳號': loginUser,
      '房客帳號': tenantEmail,
      '退租': false
    });
  }

  File _imageFromGallery;

  final _picker = ImagePicker();

  Future _getImageFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      _imageFromGallery = File(image.path);
      print(_imageFromGallery);
    });
  }

  String imageUrl = '';

  void saveImages() async {
    if (_imageFromGallery != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child(loginUser)
          .child('回報照片')
          .child("個人資料${DateTime.now().second}");

      await ref.putFile(_imageFromGallery).onComplete;

      final url = await ref.getDownloadURL();
      imageUrl = url;
    } else {
      imageUrl = '';
    }
  }

  ScrollController _msgController = ScrollController();

  void scrollMsgBottom(int time) {
    Timer(Duration(milliseconds: time),
        () => _msgController.jumpTo(_msgController.position.maxScrollExtent));

    _msgController.addListener(() => print(_msgController.offset));
  }

  MessageData _messageData = MessageData();
  var informationQuery;
  int items;
  var data;
  String currentID;
  String nowTime;
  String tenantName;
  String returnTY;
  String tenantEmail;
  String currentRoomName;
  String selectRoomName;
  final _auth = FirebaseAuth.instance;
  var loginUser;
  bool check1 = false;
  bool check2 = false;
  final List<Map<String, dynamic>> roomName = [
    {'聯絡房客': '選擇房間名稱'}
  ];
  Map<String, dynamic> returnType = {'回報類型': '請選擇', '聯絡房客': '選擇房間名稱'};
  TextEditingController description = TextEditingController();

  Future getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      final aa = await Firestore.instance
          .collection('房東/帳號資料/$loginUser/資料/聯絡房客')
          .getDocuments();
      items = aa.documents.length;
      data = aa.documents;
      final bb = await Firestore.instance
          .collection('房東/帳號資料/$loginUser/資料/擁有房間')
          .getDocuments();
      for (var cc in bb.documents) {
        roomName.add({'聯絡房客': cc.documentID});
        print(cc.data);
      }
      Timer(Duration(seconds: 1), () {
        setState(() {});
      });
    }
  }

  Future onRefreshData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      final aa = await Firestore.instance
          .collection('房東/帳號資料/$loginUser/資料/聯絡房客')
          .getDocuments();
      items = aa.documents.length;
      data = aa.documents;
      setState(() {});
    }
  }

  final List<Tab> tabCard = <Tab>[
    Tab(
      text: '信息查詢',
    ),
    Tab(
      text: "聯絡房客",
    ),
  ];
  bool awaitButton = false;
  bool login = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                '信息通知',
                style: TextStyle(
                  fontSize: Adapt.px(40),
                ),
              ),
              backgroundColor: AppConstants.appBarAndFontColor,
              bottom: TabBar(
                unselectedLabelColor: Colors.white70,
                labelColor: Colors.white,
                tabs: tabCard,
              ),
            ),
            body: TabBarView(children: [
              Container(
                color: AppConstants.backColor,
                child: EasyRefresh(
                  topBouncing: true,
                  onRefresh: login
                      ? () async {
                          await Future.delayed(Duration(seconds: 2), () {
                            onRefreshData();
                            setState(() {
                              login = false;
                            });
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              login = true;
                            });
                          });
                        }
                      : null,
                  onLoad: login
                      ? () async {
                          await Future.delayed(Duration(seconds: 2), () {
                            onRefreshData();
                            setState(() {
                              login = false;
                            });
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              login = true;
                            });
                          });
                        }
                      : null,
                  child: items == null
                      ? Container()
                      : StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('房東/帳號資料/$loginUser/資料/聯絡房客')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: 300,
                                height: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              final data = snapshot.data.documents;
                              return ListView.builder(
                                  controller: _msgController,
                                  shrinkWrap: true,
                                  addRepaintBoundaries: true,
                                  reverse: items < 6 ? false : true,
                                  itemCount:
                                      items == null || items == 0 ? 0 : items,
                                  itemBuilder: (context, index) {
                                    scrollMsgBottom(150);
                                    return Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            color: data[index]['退租']
                                                ? Colors.grey
                                                : Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                    leading: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        Container(
                                                            child: data[index][
                                                                        '回覆內容'] ==
                                                                    ""
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            2.0),
                                                                    child: Text(
                                                                      '未回覆',
                                                                      style: TextStyle(
                                                                          fontSize: Adapt.px(
                                                                              22),
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : data[index][
                                                                            '回覆內容'] ==
                                                                        "取消"
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(2.0),
                                                                        child:
                                                                            Text(
                                                                          '已取消',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.white),
                                                                        ),
                                                                      )
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(2.0),
                                                                        child:
                                                                            Text(
                                                                          '已回覆',
                                                                          style: TextStyle(
                                                                              fontSize: Adapt.px(22),
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    7),
                                                              ),
                                                              color: data[index]
                                                                          [
                                                                          '回覆內容'] ==
                                                                      ""
                                                                  ? Colors
                                                                      .redAccent
                                                                  : AppConstants
                                                                      .appBarAndFontColor,
                                                            )),
                                                        Container(
                                                            child:
                                                                data[index]
                                                                        ['處理標籤']
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(2.0),
                                                                        child:
                                                                            Text(
                                                                          '已完成',
                                                                          style: TextStyle(
                                                                              fontSize: Adapt.px(22),
                                                                              color: Colors.white),
                                                                        ),
                                                                      )
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(2.0),
                                                                        child:
                                                                            Text(
                                                                          '未完成',
                                                                          style: TextStyle(
                                                                              fontSize: Adapt.px(22),
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    7),
                                                              ),
                                                              color: data[index]
                                                                      ['處理標籤']
                                                                  ? AppConstants
                                                                      .appBarAndFontColor
                                                                  : Colors.red,
                                                            )),
                                                      ],
                                                    ),
                                                    title: data[index]['退租']
                                                        ? Text(
                                                            '『${data[index]['房間名稱']}』-已退租',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Adapt.px(
                                                                        25),
                                                                color:
                                                                    Colors.red),
                                                          )
                                                        : Text(
                                                            '『${data[index]['房間名稱']}』',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Adapt.px(
                                                                        25)),
                                                          ),
                                                    subtitle: Text(
                                                      data[index]['回報類型'],
                                                      style: TextStyle(
                                                          fontSize:
                                                              Adapt.px(25)),
                                                    ),
                                                    trailing: Text(
                                                      data[index]['回報時間'],
                                                      style: TextStyle(
                                                          fontSize:
                                                              Adapt.px(18)),
                                                    ),
                                                    onTap: data[index]['退租']
                                                        ? null
                                                        : () async {
                                                            try {
                                                              setState(() {
                                                                currentRoomName =
                                                                    data[index][
                                                                        '房間名稱'];
                                                                currentID = data[
                                                                        index]
                                                                    .documentID;
                                                              });
//                                                              await getCurrentTenantEmail();
//                                                              print(
//                                                                  tenantEmail);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MyCard(
                                                                            index:
                                                                                index,
                                                                            returnType:
                                                                                data[index]['回報類型'],
                                                                            roomName:
                                                                                data[index]['房間名稱'],
                                                                            handlingTags:
                                                                                data[index]['處理標籤'],
                                                                            url:
                                                                                data[index]['url'],
                                                                            tenantName:
                                                                                data[index]['房客姓名'],
                                                                            content:
                                                                                data[index]['回報內容'],
                                                                            reply:
                                                                                data[index]['回覆內容'],
                                                                            replyController:
                                                                                replyController,
                                                                            upData:
                                                                                upData,
                                                                            currentID:
                                                                                currentID,
                                                                            loginUser:
                                                                                loginUser,
                                                                            upLengthData:
                                                                                onRefreshData,
                                                                            tenantEmail:
                                                                                data[index]['房客帳號'],
                                                                          )));
                                                              print(data[index]
                                                                  ['房客帳號']);
                                                              print(currentID);
                                                            } catch (e) {
                                                              print(e);
                                                              await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      '房東')
                                                                  .document(
                                                                      '帳號資料')
                                                                  .collection(
                                                                      loginUser)
                                                                  .document(
                                                                      '資料')
                                                                  .collection(
                                                                      '聯絡房客')
                                                                  .document(
                                                                      currentID)
                                                                  .updateData({
                                                                '退租': true
                                                              });
                                                              await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      '房客')
                                                                  .document(
                                                                      '帳號資料')
                                                                  .collection(
                                                                      tenantEmail)
                                                                  .document(
                                                                      '資料')
                                                                  .collection(
                                                                      '聯絡房東')
                                                                  .document(
                                                                      currentID)
                                                                  .updateData({
                                                                '退租': true
                                                              });
                                                              await onRefreshData();
                                                            }
                                                          }),
                                                Container(
                                                  height: 1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1,
                                                  color: Colors.grey[400],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }),
                ),
              ),
              GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Container(
                    color: AppConstants.backColor,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Container(
                                  margin: EdgeInsets.all(30),
                                  width:
                                      MediaQuery.of(context).size.width * 0.74,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: FormField(
                                          builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(
                                              Icons.wc,
                                              color: AppConstants
                                                  .appBarAndFontColor,
                                            ),
                                            labelText: '回報類型',
                                            labelStyle: TextStyle(
                                                fontSize: Adapt.px(26)),
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: returnType['回報類型'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  newValue != '請選擇'
                                                      ? check1 = true
                                                      : check1 = false;
                                                  returnType['回報類型'] = newValue;
                                                  state.didChange(newValue);
                                                  returnTY = newValue;
                                                  print(returnTY);
                                                });
                                              },
                                              items: _messageData.returnTypeList
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['回報類型'],
                                                  child: Text(color['回報類型']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    InputDecorator(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.wc,
                                          color:
                                              AppConstants.appBarAndFontColor,
                                        ),
                                        labelText: '聯絡房客',
                                      ),
                                      // isEmpty: _group['color'] == Colors.black,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: returnType['聯絡房客'],
                                          isDense: true,
                                          onChanged: (newValue) {
                                            setState(() {
                                              newValue != '選擇房間名稱'
                                                  ? check2 = true
                                                  : check2 = false;
                                              returnType['聯絡房客'] = newValue;

                                              selectRoomName = newValue;
                                            });
                                          },
                                          items: roomName.map((dynamic color) {
                                            return DropdownMenuItem(
                                              value: color['聯絡房客'],
                                              child: Text(color['聯絡房客']),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ), //
                                    selectRoomName == '選擇房間名稱' ||
                                            selectRoomName == null
                                        ? Container()
                                        : StreamBuilder<DocumentSnapshot>(
                                            stream: Firestore.instance
                                                .collection('房東')
                                                .document('帳號資料')
                                                .collection(loginUser)
                                                .document('資料')
                                                .collection('擁有房間')
                                                .document(selectRoomName)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final data = snapshot.data;
                                              tenantName = data['房客名稱'] ?? '';
                                              tenantEmail = data['房客帳號'] ?? '';
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: ListTile(
                                                  leading: Text(
                                                    "房客姓名：",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  title: Text(tenantName),
                                                ),
                                              );
                                            }),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: '描述',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(7),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                                borderSide: BorderSide(
                                                    color: AppConstants
                                                        .appBarAndFontColor,
                                                    width: 2)),
                                          ),
                                          controller: description,
                                          maxLength: 100,
                                          maxLines: 7),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: OutlineButton(
                                        onPressed: _getImageFromGallery,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.add,
                                                size: Adapt.px(26),
                                              ),
                                              Text(
                                                '附加照片',
                                                style: TextStyle(
                                                    fontSize: Adapt.px(23)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: !check1
                                          ? null
                                          : !check2
                                              ? null
                                              : awaitButton
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        ok = '傳送中請稍等．．．';
                                                        awaitButton = true;
                                                      });

                                                      nowTime = DateTime.now()
                                                          .toString();
                                                      print(nowTime);

                                                      await saveData();

                                                      showBottomSheet();
                                                      onRefreshData();
                                                      setState(() {
                                                        ok = '提交';
                                                        awaitButton = false;
                                                        _imageFromGallery =
                                                            null;
                                                        description.clear();
                                                        check1 = false;
                                                        check2 = false;
                                                      });
                                                    },
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: AppConstants.appBarAndFontColor,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .05,
                                        child: Text(
                                          ok,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ]))
                            ])),
                      ),
                    )),
              )
            ])));
  }
}

// ignore: must_be_immutable
class MyCard extends StatefulWidget {
  final int index;
  final String roomName;
  final String returnType;
  final String url;
  final String tenantName;
  final String content;
  final String reply;
  final String loginUser;
  final String currentID;
  final String tenantEmail;
  final bool handlingTags;
  final Function upData;
  final Function upLengthData;

  TextEditingController replyController;

  MyCard({
    this.url,
    this.reply,
    this.currentID,
    this.tenantEmail,
    this.upLengthData,
    this.loginUser,
    this.replyController,
    this.upData,
    this.content,
    this.tenantName,
    this.index,
    this.roomName,
    this.returnType,
    this.handlingTags,
  });

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool awaitButton = false;
  int contentLength = 0;
  ScrollController _msgController = ScrollController();

  void scrollMsgBottom() {
    Timer(Duration(milliseconds: 100),
        () => _msgController.jumpTo(_msgController.position.maxScrollExtent));

    _msgController.addListener(() => print(_msgController.offset));
  }

  Future upData() async {
    await Firestore.instance
        .collection('/房東/帳號資料/${widget.loginUser}/資料/聯絡房客')
        .document(widget.currentID)
        .updateData({'處理標籤': true});
    await Firestore.instance
        .collection('/房客/帳號資料/${widget.tenantEmail}/資料/聯絡房東')
        .document(widget.currentID)
        .updateData({'處理標籤': true});
    Navigator.pop(context);
    Navigator.pop(context);
    widget.upLengthData();
  }

  Future upReplyData() async {
    await Firestore.instance
        .collection('/房東/帳號資料/${widget.loginUser}/資料/聯絡房客')
        .document(widget.currentID)
        .updateData({'回覆內容': '已回復'});
    await Firestore.instance
        .collection('/房客/帳號資料/${widget.tenantEmail}/資料/聯絡房東')
        .document(widget.currentID)
        .updateData({'回覆內容': '已回復'});
    widget.upLengthData();
  }

  void deleteNotRentedData(BuildContext context) {
    showDialog(
      //通过showDialog方法展示alert弹框
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(AntDesign.delete),
              ),
              Text('提示'),
            ],
          ),
          content: Text('結案後不可復原'),
          actions: <Widget>[
            //操作控件
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              textStyle: TextStyle(fontSize: 18, color: Colors.blueAccent),
              //按钮上的文本风格
              child: Text('取消'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                upData();
              },
              textStyle: TextStyle(fontSize: 18, color: Colors.grey),
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backColor,
      appBar: AppBar(
        backgroundColor: AppConstants.appBarAndFontColor,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Text(widget.roomName),
                  Text(
                    widget.handlingTags ? '完成' : '處理中',
                    style: TextStyle(fontSize: Adapt.px(25)),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: widget.handlingTags
                        ? null
                        : () {
                            deleteNotRentedData(context);
                          },
                    child: Text(
                      widget.handlingTags ? '已結案' : '結案',
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
      body: widget.returnType == '簽約'
          ? Card(
              margin: EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection(
                                '/房東/帳號資料/${widget.loginUser}/資料/擁有房間/${widget.roomName}/合約')
                            .document('房間合約')
                            .snapshots(),
                        builder: (context, snapshot) {
                          final data = snapshot.data.data;
                          print(data);
                          if(data['停車位']==null){
                            return Container(child: Center(child: Text('已退租')),);
                          }{
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                  "中華民國107年6月27日內政部內授中辦地字第1071304160號函立契約書人出租人 ${data['房東名稱']} ，承租人${widget.tenantName}，茲為住宅租賃事宜，雙方同意本契約條款如下："),
                              Text(
                                "第一條 租賃標的",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('一.租賃住宅標示：\n'
                                  '1.門牌 ${data['城市']}${data['地址']} '
                                  '2.專有部分建號__  ，權利範圍 ，面積共計${data['面積']}坪。\n'
                                  '1.主建物面積： __層 __坪，__層 __坪， __層 __坪共計${data['面積']}坪，用途__ 。\n'
                                  '2.附屬建物用途__ ，面積 __坪。\n3.共有部分建號__，權利範圍__ ，持分面積 __坪。\n'),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 2, child: Text('4.車位：')),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Text('有'),
                                        Checkbox(
                                            value: data['停車位'],
                                            onChanged: (v) {
                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: Text('（汽車停車位 個、機車停車位 個）')),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 1, child: Text('5.有')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['權力'],
                                        onChanged: (v) {
                                          setState(() {});
                                        }),
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: Text('設定他項權利，若有，權利種類：___ 。')),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 1, child: Text('6.有')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['查封登記'],
                                        onChanged: (v) {
                                          setState(() {});
                                        }),
                                  ),
                                  Expanded(flex: 7, child: Text('查封登記。')),
                                ],
                              ),
                              Text('二.租賃範圍:'),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 2, child: Text('1.租賃住宅:')),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Text('全部'),
                                        Checkbox(
                                            value: data['租賃範圍'],
                                            onChanged: (v) {
                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: <Widget>[
                                        Text('部分'),
                                        Checkbox(
                                            value: !data['租賃範圍'],
                                            onChanged: (v) {
                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '第 ${data['樓層']}層 房間__間 第__室，面積 ${data['面積']}坪(如「租賃住宅位置格局示意圖」標註之租賃範圍)。'),
                              Text('2.車位(如無則免填)：'),
                              Text('1.汽車停車位種類及編號：地上(下）第__層'),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 4, child: Text('平面式停車位')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['平面停車位'],
                                        onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 4, child: Text('機械式停車位')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['立體停車位'],
                                        onChanged: (v) {}),
                                  ),
                                ],
                              ),
                              Text('2.機車停車位：地上(下）第__層編號第__號或其位置示意圖'),
                              Text('3.使用時間：'),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 2, child: Text('全日')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['整天'], onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 2, child: Text('日間')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['白天'], onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 2, child: Text('夜間')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['晚上'], onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 2, child: Text('其他')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['其他'], onChanged: (v) {}),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Text('3.租賃附屬設備：有'),
                                        Checkbox(
                                            value: true, onChanged: (v) {}),
                                        Text('附屬設備')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text('附屬設備，若有，除另有附屬設備清單外，詳如後附租賃標的現況確認書（如附件一）。。'),
                              Text('4.其他：_____'),
                              Text(
                                '第二條 租賃期間',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '租賃期間自民國${data['現在年']}年${data['現在月']}月${data['現在日']}日起至民國${data['到期年']}年${data['到期月']}月${data['到期日']}日止。(租賃期間至少三十日以上)'),
                              Text(
                                '第三條 租金約定及支付',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '承租人每月租金為新臺幣${data['每月租金']}元整，每期應繳納1個月租金，並於每月${data['繳款時間']}日前支付，不得藉任何理由拖延或拒絕，出租人於租賃期間亦不得任意要求調整租金。'),
                              Text('租金支付方式：依據房東天堂規定之繳費方式繳費'),
                              Text(
                                '第四條 押金約定及返還',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '押金由租賃雙方約定為${data['押金']}個月租金，金額為${data['押金金額']}'
                                  '元整(最高不得超過二個月租金之總額)。'
                                  '承租人應於簽訂住宅租賃契約（以下簡稱本契約）之同時給付出租人。'
                                  '前項押金，除有第十三條第三項、第十四條第四項及第十八條第二項之情形外，'
                                  '出租人應於租期屆滿或租賃契約終止，承租人返還租賃住宅時'
                                  '，返還押金或抵充本契約所生債務後之賸餘押金。'),
                              Text(
                                '第五條 租賃期間相關費用之支付',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('租賃期間，使用租賃住宅所生之相關費用如下：'),
                              Text(
                                  data['管理費'] ? '一.管理費：包含至房租' : '一.管理費：由出租人負擔'),
                              Text(
                                  data['第四台'] ? '二.第四台：包含至房租' : '二.第四台：由出租人負擔'),
                              Text(
                                  data['瓦斯費'] ? '三.瓦斯費：包含至房租' : '三.瓦斯費：由出租人負擔'),
                              Text(
                                  data['網路費'] ? '四.網路費：包含至房租' : '四.網路費：由出租人負擔'),
                              Text('五.水費：包含至房租'),
                              Text(data['開啟電費儲值']
                                  ? '六.電費：夏季電費每度${data['夏季電費']}元,非夏季電費每度${data['非夏季電費']}元'
                                  : '六.電費：包含至房租'),
                              Text('七.其他費用及其支付方式： 。'),
                              Text(
                                '第六條 稅費負擔之約定',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('本契約有關稅費、代辦費，依下列約定辦理:'),
                              Text('一.租賃住宅之房屋稅、地價稅由出租人負擔。'),
                              Text('二.出租人收取現金者，其銀錢收據應貼用之印花稅票由出租人負擔。'),
                              Text(
                                  '三.簽約代辦費__元整。☐由出租人負擔。☐由承租人負擔。☐由租賃雙方平均負擔。其他：__'),
                              Text(
                                  '四.公證費__元整。☐由出租人負擔。☐由承租人負擔。☐由租賃雙方平均負擔。其他：__'),
                              Text(
                                  '五.公證代辦費__元整。☐由出租人負擔。☐由承租人負擔。☐由租賃雙方平均負擔。其他：__'),
                              Text('六.其他稅費及其支付方式:___'),
                              Text(
                                '第七條 使用租賃住宅之限制',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('本租賃標的係供居住使用，承租人不得變更用途。'
                                  '承租人同意遵守公寓大廈規約或其他住戶應遵循事項，'
                                  '不得違法使用、存放有爆炸性或易燃性物品，影響公共安全、'
                                  '公共衛生或居住安寧。出租人 ☐同意☑不同意承租人將本租賃標的之全部或一部分轉租、'
                                  '出借或以其他方式供他人使用，或將租賃權轉讓於他人。前項出租人同意轉租者，'
                                  '應出具同意書(如附件二)載明同意轉租之範圍、期間及得終止本契約之事由，'
                                  '供承租人轉租時向次承租人提示。'),
                              Text(
                                '第八條 修繕',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('租賃住宅或附屬設備損壞時，應由出租人負責修繕。但租賃雙方另有約定、'
                                  '習慣或因可歸責於承租人之事由者，不在此限。'
                                  '前項由出租人負責修繕者，如出租人未於承租人所定相當期限內修繕時，'
                                  '承租人得自行修繕，並請求出租人償還其費用或於第三條約定之租金中扣除。'
                                  '出租人為修繕租賃住宅所為之必要行為，承租人不得拒絕。前項出租人於修繕期間，'
                                  '致租賃標的全部或一部不能居住使用者，承租人得請求出租人扣除該期間全部或一部之租金。'),
                              Text(
                                '第九條 室內裝修',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('租賃住宅有室內裝修之必要，承租人應經出租人同意，'
                                  '始得依相關法令自行裝修，且不得損害原有建築之結構安全。承租人經出租人同意裝修者，'
                                  '其裝修增設部分若有損壞，由承租人負責修繕。第一項情形承租人返還租賃住宅時，應負責'),
                              Row(
                                children: <Widget>[
                                  Expanded(flex: 2, child: Text('回復原狀')),
                                  Expanded(
                                    flex: 2,
                                    child: Checkbox(
                                        value: data['恢復原狀'], onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 2, child: Text('現況返還')),
                                  Expanded(
                                    flex: 2,
                                    child: Checkbox(
                                        value: !data['恢復原狀'],
                                        onChanged: (v) {}),
                                  ),
                                ],
                              ),
                              Text('其他 ☐ : ___'),
                              Text(
                                '第十條 出租人之義務及責任',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('出租人應出示有權出租本租賃標的之證明文件及國民身份證或其他足資證明身份之文件，'
                                  '供承租人核對。出租人應以合於所約定居住使用之租賃住宅，'
                                  '交付承租人，並應於租賃期間保持其合於居住使用之狀態。'
                                  '出租人與承租人簽訂本契約，應先向承租人說明租賃住宅由出租人負責修繕項目及範圍（如附件三）'
                                  '，並提供有修繕必要時之聯絡方式。'),
                              Text(
                                '第十一條 承租人之義務及責任',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('承租人應於簽訂本契約時，'
                                  '出示國民身份證或其他足資證明身份之文件，'
                                  '供出租人核對。承租人應以善良管理人之注意義務保管、'
                                  '使用、收益租賃住宅。承租人違反前項義務，致租賃住宅毀損或滅失者'
                                  '，應負損害賠償責任。但依約定之方法或依租賃住宅之性質使用、收益，'
                                  '致有變更或毀損者，不在此限。承租人經出租人同意轉租者，應於簽訂轉租契約後三十日內，'
                                  '以書面將轉租範圍、期間、次承租人之姓名及通訊住址等相關資料通知出租人。'),
                              Text(
                                '第十二條 租賃住宅部分滅失',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '租賃關係存續中，因不可歸責於承租人之事由，致租賃住宅之一部滅失者，承租人得按滅失之部分，請求減少租金。'),
                              Text('第十三條 提前終止租約之約定',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  Text('本契約於期限屆滿前，出租人得'),
                                  Checkbox(
                                      value: data['出租人'], onChanged: (v) {}),
                                  Text('承租人得'),
                                  Checkbox(
                                      value: data['承租人'], onChanged: (v) {}),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('終止租約。依約定得終止租約者，租賃之一方應於'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('一個月'),
                                  Expanded(flex: 1, child: Text('前')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: true, onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 6, child: Text('通知他方。')),
                                ],
                              ),
                              Text(
                                  '一方未為先期通知而逕行終止租約者，應賠償他方 1 個月(最高不得超過一個月)租金額之違約金。'
                                  '前項承租人應賠償之違約金得由第四條之押金中扣抵。'
                                  '租期屆滿前，依第二項終止租約者，出租人已預收之租金應返還予承租人。'),
                              Text(
                                '第十四條 租賃住宅之返還',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '租期屆滿或租賃契約終止時，出租人應結算承租人第五條約定之相關費用，承租人應即將租賃住宅返還出租人並遷出戶籍或其他登記。'
                                  '前項租賃住宅之返還，應由租賃雙方共同完成屋況及附屬設備之點交手續。租賃之一方未會同點交，經他方定相當期限催告仍不會同者，視為完成點交。'
                                  '承租人未依第一項規定返還租賃住宅時，出租人除按日向承租人請求未返還租賃住宅期間之相當月租金額外，並得請求相當月租金額計算之違約金(未足一個月者，以日租金折算)至返還為止。'
                                  '前項金額及承租人未繳清之相關費用，出租人得由第四條之押金中扣抵。'),
                              Text(
                                '第十五條 租賃住宅所有權之讓與',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '出租人於租賃住宅交付後，承租人占有中，縱將其所有權讓與第三人，本契約對於受讓人仍繼續存在。'
                                  '前項情形，出租人應移交押金及已預收之租金與受讓人，並以書面通知承租人。'
                                  '本契約如未經公證，其期限逾五年者，不適用第一項之規定。'),
                              Text(
                                '第十六條 出租人提前終止租約',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('''租賃期間有下列情形之一者，出租人得提前終止租約，且承租人不得要求任何賠償：
一.出租人為重新建築而必要收回。
二.承租人遲付租金之總額達二個月之金額，並經出租人定相當期限催告，仍不為支付。
三.承租人積欠管理費或其他應負擔之費用達相當二個月之租金額，經出租人定相當期限催告，仍不為支付。
四.承租人違反第七條第二項規定而違法使用、存放有爆炸性或易燃性物品，經出租人阻止，仍繼續使用。
五.承租人違反第七條第三項勾選不同意之約定，擅自轉租、出借或以其他方式供他人使用或將租賃權轉讓予他人。
六.承租人毀損租賃住宅或附屬設備，經出租人限期催告修繕而不為修繕或相當之賠償。
七.承租人違反第九條第一項規定，未經出租人同意，擅自進行室內裝修。
八.承租人違反第九條第一項規定，未依相關法令規定進行室內裝修，經出租人阻止仍繼續為之。
九.承租人違反第九條第一項規定，進行室內裝修，損害原有建築之結構安全。
出租人依前項規定提前終止租約者，應依下列規定期限，檢附相關事證，以書面通知承租人：
一.依前項第一款規定終止者，於終止前三個月。
二.依前項第二款至第九款規定終止者，於終止前三十日。'''),
                              Text(
                                '第十七條 承租人提前終止租約',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '''租賃期間有下列情形之一，致難以繼續居住者，承租人得提前終止租約，出租人不得要求任何賠償：

一.租賃住宅未合於居住使用，並有修繕之必要，經承租人依第八條第二項規定催告，仍不於期限內修繕。
二.租賃住宅因不可歸責承租人之事由致一部滅失，且其存餘部分不能達租賃之目的。
三.租賃住宅有危及承租人或其同居人之安全或健康之瑕疵；承租人於簽約時已明知該瑕疵或拋棄終止租約權利者，亦同。
四.承租人因疾病、意外產生有長期療養之需要。
五.因第三人就租賃住宅主張其權利，致承租人不能為約定之居住使用。
承租人依前項規定提前終止租約者，應於終止前三十日，檢附相關事證，以書面通知出租人。
承租人死亡，其繼承人得主張終止租約，其通知期限及方式，適用前項規定。'''),
                              Text(
                                '第十八條 遺留物之處理',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('本契約租期屆滿或提前終止租約，依第十四條完成點交或視為完成點交之手續後，'
                                  '承租人仍於本租賃住宅有遺留物者，除租賃雙方另有約定外，經出租人定相當期限向承租人催告'
                                  '，逾期仍不取回時，視為拋棄其所有權。'
                                  '出租人處理前項遺留物所生費用，得由第四條之押金先行扣抵，如有不足，'
                                  '並得向承租人請求給付不足之費用。'),
                              Text(
                                '第十九條 履行本契約之通知',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('除本契約另有約定外，租賃雙方相互間之通知，以郵寄為之者，'
                                  '應以本契約所記載之地址為準；如因地址變更或拒收，致通知無法到達他方時，'
                                  '以第一次郵遞之日期推定為到達日。'),
                              Text('前項之通知得經租賃雙方約定以 '),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['信箱有效'], onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 2, child: Text('電子郵件。')),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['簡訊有效'], onChanged: (v) {}),
                                  ),
                                  Expanded(flex: 2, child: Text('簡訊。')),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                        value: data['通訊軟體有效'],
                                        onChanged: (v) {}),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: Text('通訊軟體(例如 房東天堂訊息文字顯示)。')),
                                ],
                              ),
                              Text(
                                  '為之；如因不可歸責於雙方之事由，致通知無法到達時，以通知之一方提出他方確已知悉通知之日期推定為到達日。'),
                              Text(
                                '第二十條 其他約定',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('本契約租賃雙方 ☐ 同意 ☐ 不同意辦理公證。'),
                              Text(
                                  '本契約經辦理公證者，租賃雙方 ☐ 同意 ☐ 不同意公證書載明下列事項應逕受強制執行：'),
                              Text('承租人如於租期屆滿後不返還租賃住宅。'
                                  '承租人未依約給付之欠繳租金、費用及出租人或租賃標的所有權人代繳之管理費，'
                                  '或違約時應支付之金額。出租人如於租期屆滿或本契約終止時，應返還之全部或一部押金。'
                                  '公證書載明金錢債務逕受強制執行時，如有保證人者，前項後段第___款之效力及於保證人。'),
                              Text(
                                '第二十一條 契約及其相關附件效力',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('本契約自簽約日起生效，租賃雙方各執一份契約正本。'
                                  '本契約廣告及相關附件視為本契約之一部分。'
                                  '本契約所定之權利義務對租賃雙方之契約繼受人均有效力。'),
                              Text(
                                '第二十二條 未盡事宜之處置',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('本契約如有未盡事宜，依有關法令、習慣、平等互惠及誠實信用原則公平解決之。'),
                              Text(
                                '附件',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('建物所有權狀影本或其他有權出租之證明文件'
                                  '使用執照影本'
                                  '雙方身份證明文件影本'
                                  '授權代理人簽約同意書'
                                  '租賃標的現況確認書'
                                  '出租人同意轉租範圍、租賃期間及終止租約事由確認書'
                                  '出租人負責修繕項目及範圍確認書'
                                  '附屬設備清單'
                                  '租賃住宅位置格局示意圖'
                                  '其他（測量成果圖、室內空間現狀照片、稅籍證明等）'),
                              Text(
                                '立契約書人',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              MyAndTenantData(
                                  loginUser: widget.loginUser,
                                  tenantEmail: widget.tenantEmail),
                              Text('附屬設備項目如下：'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['電視'] ? ' ☑ 電視' : " ☐ 電視"),
                                  Text(data['附屬設備']['冰箱'] ? ' ☑ 冰箱' : " ☐ 冰箱"),
                                  Text(data['附屬設備']['洗衣機']
                                      ? ' ☑ 洗衣機'
                                      : " ☐ 洗衣機"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['有線網路']
                                      ? ' ☑ 有線網路'
                                      : " ☐ 有線網路"),
                                  Text(data['附屬設備']['冷氣'] ? ' ☑ 冷氣' : " ☐ 冷氣"),
                                  Text(data['附屬設備']['熱水器']
                                      ? ' ☑ 熱水器'
                                      : " ☐ 熱水器"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['油煙機']
                                      ? ' ☑ 排油煙機'
                                      : " ☐ 排油煙機"),
                                  Text(data['附屬設備']['電話'] ? ' ☑ 電話' : " ☐ 電話"),
                                  Text(data['附屬設備']['微波爐']
                                      ? ' ☑ 微波爐'
                                      : " ☐ 微波爐"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['洗碗機']
                                      ? ' ☑ 洗碗機'
                                      : " ☐ 洗碗機"),
                                  Text(data['附屬設備']['瓦斯']
                                      ? ' ☑ 天然瓦斯'
                                      : " ☐ 天然瓦斯"),
                                  Text(data['附屬設備']['保全設備']
                                      ? ' ☑ 保全設施'
                                      : " ☐ 保全設施"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['電視櫃']
                                      ? ' ☑ 電視櫃'
                                      : " ☐ 電視櫃"),
                                  Text(data['附屬設備']['沙發'] ? ' ☑ 沙發' : " ☐ 沙發"),
                                  Text(data['附屬設備']['茶几'] ? ' ☑ 茶几' : " ☐ 茶几"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['餐桌']
                                      ? ' ☑ 餐桌(椅)'
                                      : " ☐ 餐桌(椅)"),
                                  Text(data['附屬設備']['鞋櫃'] ? ' ☑ 鞋櫃' : " ☐ 鞋櫃"),
                                  Text(data['附屬設備']['書櫃'] ? ' ☑ 書櫃' : " ☐ 書櫃"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['床頭組']
                                      ? ' ☑ 床組(頭)'
                                      : " ☐ 床組(頭)"),
                                  Text(data['附屬設備']['衣櫃'] ? ' ☑ 衣櫃' : " ☐ 衣櫃"),
                                  Text(data['附屬設備']['梳妝台']
                                      ? ' ☑ 梳妝台'
                                      : " ☐ 梳妝台"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['附屬設備']['書桌']
                                      ? ' ☑ 書桌椅'
                                      : " ☐ 書桌椅"),
                                  Text(data['附屬設備']['置物櫃']
                                      ? ' ☑ 置物櫃'
                                      : " ☐ 置物櫃"),
                                  Text(data['附屬設備']['流理台']
                                      ? ' ☑ 流理台'
                                      : " ☐ 流理台"),
                                ],
                              ),
                              Text(
                                  '出租人：${data['房東名稱']}(簽章)\n承租人： ${widget.tenantName}(簽章)\n簽章日期：${data['現在年']} 年${data['現在月']} 月 ${data['現在日']}日'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    height: 250,
                                    child: Column(
                                      children: <Widget>[
                                        Text('房客簽名'),
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: Firestore.instance
                                                .collection(
                                                    '/房客/帳號資料/${widget.tenantEmail}/資料/合約')
                                                .document('簽名')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final data = snapshot.data.data;
                                              return Image.network(
                                                  data['${widget.roomName}簽名']);
                                            }),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: Firestore.instance
                                          .collection(
                                              '/房東/帳號資料/${widget.loginUser}/資料/合約')
                                          .document('${widget.roomName}簽名')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        final data = snapshot.data.data;
                                        return Container(
                                          width: 100,
                                          height: 250,
                                          child: Column(
                                            children: <Widget>[
                                              Text('房東簽名'),
                                              Image.network(
                                                  data['${widget.roomName}簽名']),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ],
                          );
                        }}),
                  ),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: AppConstants.backColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image(
                              image: widget.url == ''
                                  ? AssetImage('assets/images/3.jpg')
                                  : NetworkImage(widget.url),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          color: AppConstants.backColor,
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    '房客姓名:',
                                    style: TextStyle(
                                        fontSize: Adapt.px(25),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.tenantName,
                                    style: TextStyle(
                                        fontSize: Adapt.px(23),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Expanded(child: SizedBox())
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: AppConstants.backColor,
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    '聯絡內容:',
                                    style: TextStyle(
                                        fontSize: Adapt.px(25),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.content,
                                    style: TextStyle(
                                        fontSize: Adapt.px(23),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Expanded(child: SizedBox())
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('房東')
                                .document("帳號資料")
                                .collection(widget.loginUser)
                                .document("資料")
                                .collection("聯絡房客")
                                .document(widget.currentID)
                                .collection("對話內容")
                                .snapshots(),
                            builder: (context, snapshot) {
                              final data = snapshot.data;
                              contentLength = data.documents.length;
                              contentLength == 0
                                  ? null
                                  : widget.reply == '已回復'
                                      ? null
                                      : upReplyData();
                              return contentLength == 0
                                  ? Container()
                                  : Container(
                                      height: contentLength < 3
                                          ? contentLength.toDouble() * 70
                                          : MediaQuery.of(context).size.height *
                                              .2,
                                      child: ListView.builder(
                                          controller: _msgController,
                                          shrinkWrap: true,
                                          itemCount: data.documents.length,
                                          itemBuilder: (context, index) {
                                            scrollMsgBottom();

                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                    child: ListTile(
                                                        title:
                                                            data.documents[
                                                                        index]
                                                                    ['我是房東']
                                                                ? Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        '我 : ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Adapt.px(28),
                                                                            fontWeight: FontWeight.bold,
                                                                            color: AppConstants.appBarAndFontColor),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          data.documents[index]
                                                                              [
                                                                              '回覆內容'],
                                                                          softWrap:
                                                                              true,
                                                                          maxLines:
                                                                              3,
                                                                          style: TextStyle(
                                                                              fontSize: Adapt.px(28),
                                                                              color: Colors.grey[700]),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "${widget.tenantName} : ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Adapt.px(28),
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey[700]),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          data.documents[index]
                                                                              [
                                                                              '回覆內容'],
                                                                          softWrap:
                                                                              true,
                                                                          maxLines:
                                                                              3,
                                                                          style: TextStyle(
                                                                              fontSize: Adapt.px(28),
                                                                              color: Colors.grey[700]),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )))
                                              ],
                                            );
                                          }),
                                    );
                            }),
                        widget.handlingTags
                            ? Container()
                            : Container(
                                color: AppConstants.backColor,
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              controller:
                                                  widget.replyController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: '回覆',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(7),
                                                        ),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                        borderSide: BorderSide(
                                                            color: AppConstants
                                                                .appBarAndFontColor,
                                                            width: 2)),
                                              ),
                                              maxLength: 50,
                                              maxLines: 4),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(Icons.border_color),
                                              onPressed: awaitButton
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        awaitButton = true;
                                                      });

                                                      widget.upData();
                                                    }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class MyAndTenantData extends StatefulWidget {
  final loginUser;
  final tenantEmail;

  MyAndTenantData({this.loginUser, this.tenantEmail});

  @override
  _MyAndTenantDataState createState() => _MyAndTenantDataState();
}

class _MyAndTenantDataState extends State<MyAndTenantData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('/房東/帳號資料/${widget.loginUser}')
                .document('資料')
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('出租人：'),
                  Text('姓名（名稱）：${data['name']}（簽章）'),
                  Text('統一編號或身份證明文件編號：__'),
                  Text('戶籍地址：${data['地址']}'),
                  Text('通訊地址：：${data['地址']}'),
                  Text('聯絡電話：${data['手機號碼']}'),
                  Text('電子郵件信箱：${data['帳號']}'),
                ],
              );
            }),
        StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('/房客/帳號資料/${widget.tenantEmail}')
                .document('資料')
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('承租人：\n'
                      '姓名（名稱）：${data['name']}（簽章）\n'
                      '統一編號或身份證明文件編號：\n'
                      '戶籍地址：${data['地址']}\n'
                      '通訊地址：${data['地址']}\n'
                      '聯絡電話：${data['手機號碼']}\n'
                      '電子郵件信箱：${data['帳號']}'),
                  Text('保證人：\n姓名（名稱）：（簽章）\n'
                      '統一編號或身份證明文件編號：\n'
                      '戶籍地址：\n'
                      '通訊地址：\n'
                      '聯絡電話：\n'
                      '電子郵件信箱：'),
                  Text('不動產經紀人：\n姓名（名稱）：（簽章）\n'
                      '統一編號或身份證明文件編號：\n'
                      '戶籍地址：\n'
                      '通訊地址：\n'
                      '聯絡電話：\n'
                      '電子郵件信箱：'),
                  Text('不動產經紀業：\n名稱（公司或商號）：\n'
                      '地址：\n'
                      '負責人：（簽章）\n'
                      '統一編號或身份證明文件編號：\n'
                      '聯絡電話：\n'
                      '電子郵件信箱：'),
                ],
              );
            })
      ],
    );
  }
}

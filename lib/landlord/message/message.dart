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
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
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
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
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
                      : ListView.builder(
                          controller: _msgController,
                          shrinkWrap: true,
                          addRepaintBoundaries: true,
                          reverse: items < 6 ? false : true,
                          itemCount: items == null || items == 0 ? 0 : items,
                          itemBuilder: (context, index) {
                            scrollMsgBottom(150);
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                  child:
                                                      data[index]['回覆內容'] == ""
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Text(
                                                                '未回覆',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Adapt.px(
                                                                            22),
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Text(
                                                                '已回覆',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Adapt.px(
                                                                            22),
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(7),
                                                    ),
                                                    color: data[index]
                                                                ['回覆內容'] ==
                                                            ""
                                                        ? Colors.redAccent
                                                        : AppConstants
                                                            .appBarAndFontColor,
                                                  )),
                                              Container(
                                                  child: data[index]['處理標籤']
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            '已完成',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Adapt.px(
                                                                        22),
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            '未完成',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Adapt.px(
                                                                        22),
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(7),
                                                    ),
                                                    color: data[index]['處理標籤']
                                                        ? AppConstants
                                                            .appBarAndFontColor
                                                        : Colors.red,
                                                  )),
                                            ],
                                          ),
                                          title: Text(
                                            '『${data[index]['房間名稱']}』',
                                            style: TextStyle(
                                                fontSize: Adapt.px(25)),
                                          ),
                                          subtitle: Text(
                                            data[index]['回報類型'],
                                            style: TextStyle(
                                                fontSize: Adapt.px(25)),
                                          ),
                                          trailing: Text(
                                            data[index]['回報時間'],
                                            style: TextStyle(
                                                fontSize: Adapt.px(18)),
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              currentRoomName =
                                                  data[index]['房間名稱'];
                                              currentID =
                                                  data[index].documentID;
                                            });
                                            await getCurrentTenantEmail();
                                            print(tenantEmail);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyCard(
                                                          index: index,
                                                          roomName: data[index]
                                                              ['房間名稱'],
                                                          handlingTags:
                                                              data[index]
                                                                  ['處理標籤'],
                                                          url: data[index]
                                                              ['url'],
                                                          tenantName:
                                                              data[index]
                                                                  ['房客姓名'],
                                                          content: data[index]
                                                              ['回報內容'],
                                                          reply: data[index]
                                                              ['回覆內容'],
                                                          replyController:
                                                              replyController,
                                                          upData: upData,
                                                          currentID: currentID,
                                                          loginUser: loginUser,
                                                          upLengthData:
                                                              onRefreshData,
                                                          tenantEmail:
                                                              tenantEmail,
                                                        )));
                                            print(currentID);
                                          },
                                        ),
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

  MyCard(
      {this.url,
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
      this.handlingTags});

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
      body: Container(
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
                            : widget.reply == '已回復' ? null : upReplyData();
                        return contentLength == 0
                            ? Container()
                            : Container(
                                height: contentLength < 3
                                    ? contentLength.toDouble() * 70
                                    : MediaQuery.of(context).size.height * .2,
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
                                                  title: data.documents[index]
                                                          ['我是房東']
                                                      ? Row(
                                                          children: <Widget>[
                                                            Text(
                                                              '我 : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Adapt.px(
                                                                          28),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppConstants
                                                                      .appBarAndFontColor),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                data.documents[
                                                                        index]
                                                                    ['回覆內容'],
                                                                softWrap: true,
                                                                maxLines: 3,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Adapt.px(
                                                                            28),
                                                                    color: Colors
                                                                            .grey[
                                                                        700]),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "${widget.tenantName} : ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Adapt.px(
                                                                          28),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                data.documents[
                                                                        index]
                                                                    ['回覆內容'],
                                                                softWrap: true,
                                                                maxLines: 3,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Adapt.px(
                                                                            28),
                                                                    color: Colors
                                                                            .grey[
                                                                        700]),
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
                                        controller: widget.replyController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: '回覆',
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

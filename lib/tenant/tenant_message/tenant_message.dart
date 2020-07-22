import 'dart:async';
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

class TenantMessage extends StatefulWidget {
  @override
  _TenantMessageState createState() => _TenantMessageState();
}

class _TenantMessageState extends State<TenantMessage> {
  File _imageFromGallery;
  final _auth = FirebaseAuth.instance;

  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _imageFromGallery = image;
    });
  }

  MessageData _messageData = MessageData();
  int items;
  var data;
  String returnTY = '';

  String landlordName;
  String houseName;
  String myName;
  String currentRoomName;
  String currentID;
  bool login = true;
  bool status1 = true;
  bool status2 = false;
  bool check1 = false;
  bool awaitButton = false;
  String nowTime;
  String imageUrl = '';
  String ok = '提交';
  var loginUser;

  TextEditingController description = TextEditingController();
  TextEditingController replyController = TextEditingController();
  ScrollController _msgController = ScrollController();

  void scrollMsgBottom() {
    Timer(Duration(microseconds: 150),
        () => _msgController.jumpTo(_msgController.position.maxScrollExtent));

    _msgController.addListener(() => print(_msgController.offset));
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future saveData() async {
    await saveImages();
    await Firestore.instance
        .collection('/房東/帳號資料/$landlordName/資料/聯絡房客')
        .document(nowTime)
        .setData({
      '回報類型': returnTY,
      '房客姓名': myName,
      '房間名稱': houseName,
      '回報內容': description.text,
      'url': imageUrl,
      '處理標籤': replyController.text == '' ? false : true,
      '回覆內容': replyController.text ?? '',
      '生成時間': DateTime.now(),
      '回報時間':
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
    });
    await Firestore.instance
        .collection('/房客/帳號資料/$loginUser/資料/聯絡房東')
        .document(nowTime)
        .setData({
      '回報類型': returnTY,
      '房客姓名': myName,
      '房間名稱': houseName,
      '回報內容': description.text,
      'url': imageUrl,
      '處理標籤': replyController.text == '' ? false : true,
      '回覆內容': replyController.text ?? '',
      '生成時間': DateTime.now(),
      '回報時間':
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
    });
  }

  void upData() async {
    try {
      await Firestore.instance
          .collection('/房東/帳號資料/$landlordName/資料/聯絡房客/$currentID/對話內容')
          .document(DateTime.now().toUtc().toIso8601String())
          .setData({
        '回覆內容': replyController.text ?? '',
        '生成時間': DateTime.now(),
        '我是房東': false,
        '回報時間':
            "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
      });
    } catch (e) {}
    await Firestore.instance
        .collection('/房客/帳號資料/$loginUser/資料/聯絡房東/$currentID/對話內容')
        .document(DateTime.now().toUtc().toIso8601String())
        .setData({
      '回覆內容': replyController.text ?? '',
      '生成時間': DateTime.now(),
      '我是房東': false,
      '回報時間':
          "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日"
    });
    replyController.clear();
  }

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
                  fontSize: 20, color: AppConstants.tenantAppBarAndFontColor),
            ),
          );
        });
  }

  Map<String, dynamic> returnType = {'回報類型': '請選擇', '聯絡房東': '選擇房間名稱'};

  Future onRefreshData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      final aa = await Firestore.instance
          .collection('房客/帳號資料/$loginUser/資料/聯絡房東')
          .getDocuments();
      items = aa.documents.length;
      data = aa.documents;

      setState(() {});
    }
  }

  Future getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      final aa = await Firestore.instance
          .collection('房客/帳號資料/$loginUser/資料/聯絡房東')
          .getDocuments();
      items = aa.documents.length;
      data = aa.documents;
      final bb = await Firestore.instance
          .collection('房客/帳號資料/$loginUser')
          .getDocuments();
      landlordName = bb.documents[1]['房東姓名'];
      houseName = bb.documents[1]['房屋名稱'];
      myName = bb.documents[1]['name'];
      print(myName);
      print(houseName);
      print(landlordName);
      setState(() {});
    }
  }

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

  final List<Tab> tabCard = <Tab>[
    Tab(
      text: '信息查詢',
    ),
    Tab(
      text: "聯絡房東",
    ),
  ];

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
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppConstants.tenantAppBarAndFontColor,
              bottom: TabBar(
                unselectedLabelColor: Colors.white70,
                labelColor: Colors.white,
                tabs: tabCard,
              ),
            ),
            body: TabBarView(children: [
              Container(
                color: AppConstants.tenantBackColor,
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
                            scrollMsgBottom();
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
                                                  child: data[index]['回覆內容'] ==
                                                          ""
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            '未回覆',
                                                            style: TextStyle(
                                                                fontSize: 12,
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
                                                                fontSize: 12,
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
                                                                fontSize: 12,
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
                                                                fontSize: 12,
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
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          subtitle: Text(
                                            data[index]['回報類型'],
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          trailing: Text(
                                            data[index]['回報時間'],
                                            style: TextStyle(fontSize: 8),
                                          ),
                                          onTap: () {
                                            currentRoomName =
                                                data[index]['房間名稱'];
                                            currentID = data[index].documentID;

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
                                                          currentID: currentID,
                                                          loginUser: loginUser,
                                                          upData: upData,
                                                          replyController:
                                                              replyController,
                                                          upLengthData:
                                                              onRefreshData,
                                                          landlordName:
                                                              landlordName,
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
              houseName == ''
                  ? Container(color: AppConstants.tenantBackColor,
                      child: Center(
                          child: Container(
                      child: Text('請連絡房東並加入房間'),
                    )))
                  : Container(
                      color: AppConstants.tenantBackColor,
                      child: GestureDetector(
                        onTap: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        child: SingleChildScrollView(
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(20),
                            child: Column(children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: FormField(
                                    builder: (FormFieldState state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.wc,
                                            color:
                                                AppConstants.appBarAndFontColor,
                                          ),
                                          labelText: '回報類型',
                                        ),
                                        // isEmpty: _group['color'] == Colors.black,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: returnType['回報類型'],
                                            isDense: true,
                                            onChanged: (newValue) {
                                              setState(() {
                                                newValue != '請選擇'
                                                    ? check1 = false
                                                    : check1 = true;
                                                returnType['回報類型'] = newValue;
                                                state.didChange(newValue);
                                                returnTY = newValue;
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
                                    },
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: '描述',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1)),
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
                                padding: const EdgeInsets.only(bottom: 10),
                                child: OutlineButton(
                                  onPressed: _getImageFromGallery,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.add),
                                        Text('附加照片'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              OutlineButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: check1
                                    ? null
                                    : awaitButton
                                        ? null
                                        : () async {
                                            setState(() {
                                              ok = '傳送中請稍等．．．';
                                              awaitButton = true;
                                            });

                                            nowTime = DateTime.now().toString();

                                            await saveData();
                                            onRefreshData();
                                            showBottomSheet();
                                            setState(() {
                                              ok = '提交';
                                              awaitButton = false;
                                              _imageFromGallery = null;
                                              description.clear();
                                              check1 = false;
                                            });
                                          },
                                child: Container(
                                  alignment: Alignment.center,
                                  color: AppConstants.tenantAppBarAndFontColor,
                                  width: MediaQuery.of(context).size.width * .5,
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  child: Text(
                                    ok,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
            ])));
  }
}

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
  final String landlordName;
  final bool handlingTags;
  final Function upData;
  final Function upLengthData;
  TextEditingController replyController;
  bool awaitButton = false;

  MyCard(
      {this.url,
      this.reply,
      this.currentID,
      this.landlordName,
      this.loginUser,
      this.upLengthData,
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
  int contentLength = 0;
  ScrollController _msgController = ScrollController();

  void scrollMsgBottom() {
    Timer(Duration(milliseconds: 100),
        () => _msgController.jumpTo(_msgController.position.maxScrollExtent));

    _msgController.addListener(() => print(_msgController.offset));
  }

  Future upReplyData() async {
    await Firestore.instance
        .collection('/房東/帳號資料/${widget.landlordName}/資料/聯絡房客')
        .document(widget.currentID)
        .updateData({'回覆內容': '已回復'});
    await Firestore.instance
        .collection('/房客/帳號資料/${widget.loginUser}/資料/聯絡房東')
        .document(widget.currentID)
        .updateData({'回覆內容': '已回復'});
    widget.upLengthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.tenantAppBarAndFontColor,
        centerTitle: true,
        title: Column(
          children: <Widget>[
            Text(widget.roomName),
            Text(
              widget.handlingTags ? '完成' : '處理中',
              style: TextStyle(fontSize: Adapt.px(25)),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppConstants.tenantBackColor,
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
                      color: AppConstants.tenantBackColor,
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '房客姓名:',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.tenantName,
                                style: TextStyle(
                                    fontSize: 12,
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
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '聯絡內容:',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.content,
                                style: TextStyle(
                                    fontSize: 12,
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
                            .collection('房客')
                            .document("帳號資料")
                            .collection(widget.loginUser)
                            .document("資料")
                            .collection("聯絡房東")
                            .document(widget.currentID)
                            .collection("對話內容")
                            .snapshots(),
                        builder: (context, snapshot) {
                          final data = snapshot.data;
                          contentLength = data.documents.length;
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
                                      itemCount: contentLength,
                                      itemBuilder: (context, index) {
                                        scrollMsgBottom();
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                                child: ListTile(
                                                    title: !data.documents[
                                                            index]['我是房東']
                                                        ? Row(
                                                            children: <Widget>[
                                                              Text(
                                                                '我 : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
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
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 3,
                                                                  style: TextStyle(
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
                                                                "房東 : ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
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
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: AppConstants
                                                                          .appBarAndFontColor),
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
                            color: AppConstants.tenantBackColor,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(Icons.border_color),
                                          onPressed: widget.awaitButton
                                              ? null
                                              : () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  setState(() {
                                                    widget.awaitButton = true;
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
      ),
    );
  }
}

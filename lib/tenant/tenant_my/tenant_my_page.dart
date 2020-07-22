import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';
import 'pay/tenant_pay.dart';
import 'tenant_view_profile.dart';

class TenantMyPage extends StatefulWidget {
  TenantMyPage({Key key}) : super(key: key);

  @override
  _TenantMyPageState createState() => _TenantMyPageState();
}

class _TenantMyPageState extends State<TenantMyPage> {
  @override
  void initState() {
    getUserID();
    super.initState();
  }

  void _logout() {
    Navigator.popAndPushNamed(context, LoginPage.routeName);
  }

  void commonProblem(BuildContext context) {
    bool q1 = false;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('常見問題'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q1 = !q1;
                          });
                        },
                        child: Text('如何繳費？'),
                      ),
                      q1
                          ? Text(
                              '掏出錢拿去繳就是了！',
                              style: TextStyle(fontSize: 12),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  void shareIt(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('分享'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＬＩＮＥ'),
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＦＢ'),
                        color: Colors.blueAccent,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＩＧ'),
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                )),
              );
            }),
          );
        });
  }

  void aboutUs(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('關於我們'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                  child: Text('''公司簡介 Company

'''),
                ),
              );
            }),
          );
        });
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  var loginUser;
  User userData = User();

  //取得使用者資訊
  bool upDate;

  void getUserID() async {
    final user = await _auth.currentUser();
    if (user != null) {
      setState(() {
        loginUser = user.email;
      });
    }
    await _firestore
        .collection("/房客/帳號資料/$loginUser")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        upDate = f['更新'];
      });
    });
    await getData();
    await getAddress();
    await getPassword();
    await getUrl();
    await getPhone();
    setState(() {});
    if (userData.name == null) {
      _logout();
    }
  }

  Future saveName(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future getData() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('$loginUser姓名');

    if (userName != null && upDate == false) {
      return userData.name = userName;
    }
    else{

      print('開始獲取姓名');
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.name = f["name"];
          saveName('$loginUser姓名', userData.name);
        });
      });
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
    }
  }

  Future getPhone() async {
    var userPhone;
    SharedPreferences phone = await SharedPreferences.getInstance();
    userPhone = phone.getString('$loginUser手機號碼');
    if (userPhone != null && upDate == false) {
      return userData.phoneNumber = userPhone;
    }
    else{

      print('開始獲取號碼');
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.phoneNumber = f['手機號碼'];
          saveName('$loginUser手機號碼', userData.phoneNumber);
        });
      });
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
    }
  }

  Future getUrl() async {
    var userUrl;
    SharedPreferences url = await SharedPreferences.getInstance();
    userUrl = url.getString('$loginUser url');
    if (userUrl != null && upDate == false) {
      return userData.url = userUrl;
    }
    else{

      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.url = f['url'];
          saveName('$loginUser url', userData.url);
        });
      });
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
      print('開始獲取URL');
    }
  }

  Future getPassword() async {
    var userPassWord;
    SharedPreferences passWord = await SharedPreferences.getInstance();
    userPassWord = passWord.getString('$loginUser密碼');
    if (userPassWord != null && upDate == false) {
      return userData.password = userPassWord;
    }
    else{


      print('開始獲取密碼');
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.password = f['密碼'];
          saveName('$loginUser密碼', userData.password);
        });
      });
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
    }
  }

  Future getAddress() async {
    var userAddress;
    SharedPreferences address = await SharedPreferences.getInstance();
    userAddress = address.getString('$loginUser地址');
    if (userAddress != null && upDate == false) {
      return userData.address = userAddress;
    }
    else {
      print('開始獲取地址');
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.address = f['地址'];
          saveName('$loginUser地址', userData.address);
        });
      });
      await _firestore
          .collection("/房客/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.tenantAppBarAndFontColor,
        title: Text('我的'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: userData.name == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            )
          : SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * .8,
                          color: Colors.green[50],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      '個人設定',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Card(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              //內圈相片
                                              backgroundImage:
                                                  NetworkImage(userData.url),
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  7.2,
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .07,
                                            color: AppConstants.tenantBackColor,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  userData.name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppConstants
                                                          .tenantAppBarAndFontColor),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Text(
                                                    userData.phoneNumber,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppConstants
                                                            .tenantAppBarAndFontColor),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.settings),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TenantViewProFilePage(
                                                                  userName: userData.name,
                                                                  phoneNb: userData.phoneNumber,
                                                                  address: userData.address,
                                                                  mail:
                                                                      loginUser,
                                                                  password:
                                                                      userData.password,
                                                                  url: userData.url,
                                                                )));
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                ListTile(
                                                  onTap: () {
                                                    commonProblem(context);
                                                  },
                                                  leading: Icon(
                                                    Icons.report_problem,
                                                    size: 40,
                                                    color: Colors.red[900],
                                                  ),
                                                  title: Text(
                                                    '常見問題',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppConstants
                                                            .appBarAndFontColor),
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    aboutUs(context);
                                                  },
                                                  leading: Icon(Icons.book,
                                                      size: 40,
                                                      color: AppConstants
                                                          .appBarAndFontColor),
                                                  title: Text(
                                                    '關於房東天堂',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppConstants
                                                            .appBarAndFontColor),
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TenantPay()));
                                                  },
                                                  leading: Icon(
                                                    Icons.update,
                                                    size: 40,
                                                    color: Colors.blue[200],
                                                  ),
                                                  title: Text(
                                                    '立刻儲值',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppConstants
                                                            .appBarAndFontColor),
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    shareIt(context);
                                                  },
                                                  leading: Icon(
                                                    Icons.share,
                                                    size: 40,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  title: Text(
                                                    '分享',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppConstants
                                                            .appBarAndFontColor),
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    _logout();
                                                  },
                                                  leading: Icon(
                                                      Icons
                                                          .call_missed_outgoing,
                                                      size: 40,
                                                      color: Colors.blue),
                                                  title: Text(
                                                    '登出',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
  }
}

class CommonProblem extends StatelessWidget {
  final Image _images;
  final String _title1;
  final String _title2;

  CommonProblem(this._images, this._title1, this._title2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      child: SingleChildScrollView(
        child: Card(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    child: _images,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Container(
                      child: Text(
                    '$_title1',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.appBarAndFontColor),
                  )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '$_title2',
                    style: TextStyle(
                        fontSize: 12, color: AppConstants.appBarAndFontColor),
                  )),
            ),
          ],
        )),
      ),
    );
  }
}

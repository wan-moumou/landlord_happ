import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/user.dart';
import 'file:///D:/FlutterProjects/landlord_happy_copy/lib/landlord/my/pay/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';
import 'my_page_set.dart';
import 'view_profile.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  var loginUser;
  User userData = User();
  MyPageSet _landlordSet = MyPageSet();
  TextEditingController doorPassWord = TextEditingController();
  TextEditingController loginPassWord = TextEditingController();
  bool nowRenew = true;
  String getedDoorPassWord = '';
  bool getPasswordKey = false;
  String loginPassword = '';
  String doorPass = '';

  @override
  //進入畫面執行
  void initState() {
    getUserID();
    super.initState();
  }

  Future saveName(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future getData() async {
    try{
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('$loginUser姓名');

    if (userName != null && upDate == false) {
      return userData.name = userName;
    } else {
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
      print('開始獲取姓名');
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.name = f["name"];
          saveName('$loginUser姓名', userData.name);
        });
      });
    }}catch(e){
      if (userData.name == null) {
        _logout();
      }
    }
  }

  Future getPhone() async {
    var userPhone;
    SharedPreferences phone = await SharedPreferences.getInstance();
    userPhone = phone.getString('$loginUser手機號碼');
    if (userPhone != null && upDate == false) {
      return userData.phoneNumber = userPhone;
    } else {
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
      print('開始獲取號碼');
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.phoneNumber = f['手機號碼'];
          saveName('$loginUser手機號碼', userData.phoneNumber);
        });
      });
    }
  }

  Future getUrl() async {
    var userUrl;
    SharedPreferences url = await SharedPreferences.getInstance();
    userUrl = url.getString('$loginUser url');
    if (userUrl != null && upDate == false) {
      return userData.url = userUrl;
    } else {
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
      print('開始獲取URL');
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.url = f['url'];
          saveName('$loginUser url', userData.url);
        });
      });
    }
  }

  Future getPassword() async {
    var userPassWord;
    SharedPreferences passWord = await SharedPreferences.getInstance();
    userPassWord = passWord.getString('$loginUser密碼');
    if (userPassWord != null && upDate == false) {
      return userData.password = userPassWord;
    } else {
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});

      print('開始獲取密碼');
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.password = f['密碼'];
          saveName('$loginUser密碼', userData.password);
        });
      });
    }
  }

  Future getAddress() async {
    var userAddress;
    SharedPreferences address = await SharedPreferences.getInstance();
    userAddress = address.getString('$loginUser地址');
    if (userAddress != null && upDate == false) {
      return userData.address = userAddress;
    } else {
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .document('資料')
          .updateData({'更新': false});
      print('開始獲取地址');
      await _firestore
          .collection("/房東/帳號資料/$loginUser")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          userData.address = f['地址'];
          saveName('$loginUser地址', userData.address);
        });
      });
    }
  }

//登出
  void _logout() async {
    await _auth.signOut();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(updeta: true,)));
  }

  //更新密碼
  void passWordUpData() async {
    await _firestore
        .collection('/房東/帳號資料/$loginUser')
        .document('資料')
        .updateData({'門鎖密碼': doorPassWord.text});
    Navigator.pop(context);
  }

  //門鎖密碼設定入口
  void passWord(BuildContext context, String loginPassword) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('臨時密碼設定'),
                Text(
                  '設定未出租房間密碼',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          newPassWord(context);
                        },
                        child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '新增密碼',
                                ),
                              ],
                            )),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 1,
                        color: Colors.grey[400],
                      ),
                      FlatButton(
                        onPressed: () {
                          newFingerprintPassWord(context);
                        },
                        child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '新增指紋',
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  //新增密碼
  void newPassWord(BuildContext context) {
    bool setPasswordKey = false;
    bool going = false;
    showDialog(
        context: context,
        barrierDismissible: going,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('密碼設定'),
                Text(
                  '設定未出租房間密碼',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('密碼:'),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _landlordSet.formKey,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (doorPassWord.text.length == 6) {
                                    setState(() {
                                      setPasswordKey = true;
                                    });

                                    return null;
                                  } else {
                                    setState(() {
                                      setPasswordKey = false;
                                    });

                                    return '密碼必須等於6位數';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "請輸入密碼",
                                  helperText: '輸入6位數密碼',
                                ),
                                controller: doorPassWord,
                                obscureText: true,
                              ),
                            ),
                          )),
                        ],
                      ),
                      OutlineButton(
                          onPressed: () {
                            _landlordSet.trySubmit();
                            FocusScope.of(context).unfocus();
                            if (setPasswordKey) {
                              setState(() {
                                going = true;
                              });
                              passWordUpData();
                              setState(() {
                                going = false;
                              });
                            }
                          },
                          child: Text('更改密碼'))
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  //新增指紋
  void newFingerprintPassWord(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('添加指紋'),
                Text(
                  '設定未出租房間指紋',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('依據逼聲提示,在指紋採集器上進行多次抬起按壓'),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Image.asset('assets/images/添加指紋.png'),
                      ),
                      OutlineButton(onPressed: () {}, child: Text('確定'))
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

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
        .collection("/房東/帳號資料/$loginUser")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.appBarAndFontColor,
          title: Text(
            '設定',
            style: TextStyle(fontSize: Adapt.px(40)),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: userData.name == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * .83,
                  color: AppConstants.backColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            //內圈相片
                                            backgroundImage:
                                                NetworkImage(userData.url),
                                            radius: Adapt.px(120)),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            userData.name ?? '',
                                            style: TextStyle(
                                                fontSize: Adapt.px(30),
                                                color: AppConstants
                                                    .appBarAndFontColor),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Text(
                                              userData.phoneNumber ?? '',
                                              style: TextStyle(
                                                  fontSize: Adapt.px(25),
                                                  color: AppConstants
                                                      .appBarAndFontColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.settings,
                                          size: Adapt.px(50),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewProFilePage(
                                                        userName: userData.name,
                                                        phoneNb: userData
                                                            .phoneNumber,
                                                        address:
                                                            userData.address,
                                                        mail: loginUser,
                                                        password:
                                                            userData.password,
                                                        url: userData.url,
                                                      )));
                                        },
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: Adapt.px(100),
                                    color: AppConstants.backColor,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Pay(
                                                      loginUser: loginUser,
                                                    )));
                                      },
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                '點數中心',
                                                style: TextStyle(
                                                    color: AppConstants
                                                        .appBarAndFontColor),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.fiber_smart_record,
                                                color: AppConstants
                                                    .appBarAndFontColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: StreamBuilder<
                                                      DocumentSnapshot>(
                                                  stream: Firestore.instance
                                                      .collection(
                                                          '/房東/帳號資料/$loginUser')
                                                      .document('資料')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    final data = snapshot.data;
                                                    return Text(
                                                      data['剩餘點數'],
                                                      style: TextStyle(
                                                          color: AppConstants
                                                              .appBarAndFontColor),
                                                    );
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: Adapt.px(740),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        ListTile(
                                          onTap: () {
                                            _landlordSet.commonProblem(context);
                                          },
                                          leading: Icon(
                                            Icons.report_problem,
                                            size: Adapt.px(50),
                                            color: Colors.red[900],
                                          ),
                                          title: Text(
                                            '常見問題',
                                            style: TextStyle(
                                                fontSize: Adapt.px(23),
                                                color: AppConstants
                                                    .appBarAndFontColor),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            _landlordSet.aboutUs(context);
                                          },
                                          leading: Icon(Icons.book,
                                              size: Adapt.px(50),
                                              color: AppConstants
                                                  .appBarAndFontColor),
                                          title: Text(
                                            '關於房東天堂',
                                            style: TextStyle(
                                                fontSize: Adapt.px(23),
                                                color: AppConstants
                                                    .appBarAndFontColor),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            passWord(
                                                context, userData.password);
                                          },
                                          leading: Icon(
                                            MaterialCommunityIcons.onepassword,
                                            size: Adapt.px(50),
                                            color: Colors.red,
                                          ),
                                          title: Text(
                                            '門鎖密碼設定',
                                            style: TextStyle(
                                                fontSize: Adapt.px(23),
                                                color: AppConstants
                                                    .appBarAndFontColor),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            _landlordSet.viewContract(context);
                                          },
                                          leading: Icon(
                                            Icons.update,
                                            size: Adapt.px(50),
                                            color: Colors.blue[200],
                                          ),
                                          title: Text(
                                            '查看合約',
                                            style: TextStyle(
                                                fontSize: Adapt.px(23),
                                                color: AppConstants
                                                    .appBarAndFontColor),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            _landlordSet.shareIt(context);
                                          },
                                          leading: Icon(
                                            Icons.share,
                                            size: Adapt.px(50),
                                            color: Colors.blueGrey,
                                          ),
                                          title: Text(
                                            '分享',
                                            style: TextStyle(
                                                fontSize: Adapt.px(23),
                                                color: AppConstants
                                                    .appBarAndFontColor),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            _logout();
                                          },
                                          leading: Icon(
                                              Icons.call_missed_outgoing,
                                              size: Adapt.px(50),
                                              color: Colors.blue),
                                          title: Text(
                                            '登出',
                                            style: TextStyle(
                                                fontSize: Adapt.px(23),
                                                fontWeight: FontWeight.bold),
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

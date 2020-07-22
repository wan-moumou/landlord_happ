import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/updata_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_const/Adapt.dart';
import 'landlord/guestHomePage.dart';
import 'sing_up.dart';
import 'tenant/tenant_guest_home_page.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = '/loginPageRoute';
final data;
final intnetVersion;
final appVesion;
  LoginPage({Key key,this.data,this.intnetVersion,this.appVesion}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController animatedContainer;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController;
  TextEditingController passwordController;
  bool eye = true;

  void animated() {
    animatedContainer = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animatedContainer.forward();
    animatedContainer.addListener(() {
      setState(() {});
    });
  }
  Future<void> updateAlert(BuildContext context, Map data) async {
    bool isForceUpdate = data['isForceUpdate']; // 从数据拿到是否强制更新字段

    new Future.delayed(Duration(microseconds: 100)).then((value) {
      showDialog(
        // 显示对话框
        context: context,
        barrierDismissible: false, // 点击空白区域不结束对话框
        builder: (_) => new WillPopScope(
          // 拦截返回键
          child: new UpgradeDialog(data, isForceUpdate, updateUrl: data['url']),
          // 有状态类对话框
          onWillPop: () {
            return; // 检测到返回键直接返回
          },
        ),
      );
    });
  }



  @override
  void initState() {
    if(widget.intnetVersion!=widget.appVesion){
    updateAlert(context,widget.data);}
    final fbm = FirebaseMessaging();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fbm.requestNotificationPermissions();
    fbm.configure();
    getEmail();
    getPassWord();
    getPassBool();

    animated();
    super.initState();
  }

  @override
  void dispose() {
    animatedContainer.dispose();
    super.dispose();
  }

  void _goToSignUp(bool whoMaI) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(
                  whoMaI: wohAmI,
                )));
  }

  void _goHomePage() {
    upLandlordData();
    Navigator.popAndPushNamed(context, GuestHomePage.routeName);

  }

  void _goToTenantLogIn() {
    upTenantData();
    Navigator.popAndPushNamed(context, TenantGuestHomePage.routeName);

  }

  saveID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('帳號', emailController.value.text.toString());
  }

  savePassWord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('密碼', passwordController.value.text.toString());
  }

  Future getEmail() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = await prefs.getString('帳號');
    if (userName != null) {
      return emailController.text = userName;
    }
  }

  Future getPassWord() async {
    var userPassWord;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPassWord = await prefs.getString('密碼');
    if (userPassWord != null) {
      return passwordController.text = userPassWord;
    }
  }

  Future setPassWord() async {
    var userPassWord;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPassWord = await prefs.setBool('保存密碼', savePassword);
    return savePassword = userPassWord;
  }

  Future getPassBool() async {
    var userPassWord;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPassWord = await prefs.getBool('保存密碼');
    if (userPassWord == null) {
      return savePassword = false;
    } else {
      return savePassword = userPassWord;
    }
  }

  Future dlePassWord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('密碼');
  }
void upTenantData()async{
  await Firestore.instance
      .collection('房客')
      .document('帳號資料')
      .collection(emailController.text)
      .document('資料')
      .updateData({'更新': true});
  await Firestore.instance
      .collection('房客')
      .document('帳號資料')
      .collection(emailController.text)
      .document('帳務資料')
      .updateData({'帳務更新': true,'詳細資料更新':true});
}
void upLandlordData()async{
  await Firestore.instance
      .collection('房東')
      .document('帳號資料')
      .collection(emailController.text)
      .document('資料')
      .updateData({'更新': true});
  await Firestore.instance
      .collection('房東')
      .document('帳號資料')
      .collection(emailController.text)
      .document('帳務資料')
      .updateData({'帳務更新': true,'詳細資料更新':true});
}
  bool inAsyncCall = false;
  bool wohAmI = true;
  bool savePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          wohAmI ? AppConstants.backColor : AppConstants.tenantBackColor,
      body: OKToast(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ModalProgressHUD(
            inAsyncCall: inAsyncCall,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          width: Adapt.px(600),
                          child: Image.asset(wohAmI
                              ? 'assets/images/LOGO藍.jpg'
                              : 'assets/images/LOGO綠.jpg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                                highlightColor: AppConstants.backColor,
                                onPressed: () {
                                  setState(() {
                                    if (!wohAmI) {
                                      wohAmI = true;
                                      animatedContainer.reset();
                                      animatedContainer.forward();
                                      animatedContainer.addListener(() {
                                        setState(() {});
                                      });
                                    }
                                  });
                                },
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        width: Adapt.px(100),
                                        child: Icon(
                                          FontAwesome.user_secret,
                                          color: wohAmI
                                              ? AppConstants.appBarAndFontColor
                                                  .withOpacity(
                                                      animatedContainer.value)
                                              : Colors.grey.withOpacity(
                                                  animatedContainer.value),
                                          size: Adapt.px(100),
                                        )),
                                    Text(
                                      '我是房東',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: Adapt.px(30),
                                          fontWeight: FontWeight.bold,
                                          color: wohAmI
                                              ? Colors.black
                                              : Colors.grey),
                                    ),
                                  ],
                                )),
                            FlatButton(
                                highlightColor: AppConstants.tenantBackColor,
                                onPressed: () {
                                  setState(() {
                                    if (wohAmI) {
                                      wohAmI = false;
                                      animatedContainer.reset();
                                      animatedContainer.forward();
                                      animatedContainer.addListener(() {
                                        setState(() {});
                                      });
                                    }
                                  });
                                },
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        width: Adapt.px(100),
                                        child: Icon(
                                          FontAwesome.user,
                                          color: !wohAmI
                                              ? AppConstants
                                                  .tenantAppBarAndFontColor
                                                  .withOpacity(
                                                      animatedContainer.value)
                                              : Colors.grey.withOpacity(
                                                  animatedContainer.value),
                                          size: Adapt.px(100),
                                        )),
                                    Text(
                                      '我是房客',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: Adapt.px(30),
                                        fontWeight: FontWeight.bold,
                                        color: !wohAmI
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          height: 1.0,
                          endIndent: 18.0,
                          indent: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Form(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '帳號'),
                                      style: TextStyle(
                                          fontSize: Adapt.px(25),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 0, 25, 10),
                                    child: TextFormField(
                                      obscureText: eye,
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(eye
                                                ? Icons.remove_red_eye
                                                : Icons.panorama_fish_eye),
                                            onPressed: () {
                                              setState(() {
                                                eye = !eye;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(),
                                          labelText: '密碼'),
                                      style: TextStyle(
                                          fontSize: Adapt.px(25),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text('記住密碼:'),
                                  Checkbox(
                                      value: savePassword,
                                      onChanged: (v) {
                                        setState(() {
                                          savePassword = v;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 1.0,
                                endIndent: 18.0,
                                indent: 18.0,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: Adapt.px(620),
                                child: MaterialButton(
                                  onPressed: () async {
    if(widget.intnetVersion==widget.appVesion) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    setState(() {
                                      inAsyncCall = true;
                                    });
                                    try {
                                      saveID();
                                      savePassword
                                          ? savePassWord()
                                          : dlePassWord();
                                      savePassword
                                          ? setPassWord()
                                          : setPassWord();
                                      final newLoginUser = await _auth
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                      newLoginUser.user != null
                                          ? wohAmI
                                              ? _goHomePage()
                                              : _goToTenantLogIn()
                                          : null;
                                    } catch (e) {
                                      setState(() {
                                        inAsyncCall = false;
                                      });
                                      showToastWidget(Text(
                                        '帳號或密碼錯誤',
                                        style: TextStyle(
                                            fontSize: Adapt.px(30),
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ));
                                    }
                                  }},
                                  child: Text(
                                    wohAmI ? '房東登入' : '房客登入',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: Adapt.px(30),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  color: wohAmI
                                      ? AppConstants.appBarAndFontColor
                                          .withOpacity(animatedContainer.value)
                                      : AppConstants.tenantAppBarAndFontColor
                                          .withOpacity(animatedContainer.value),
                                  height: Adapt.px(100),
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('還不是房東天堂會員嗎?'),
                                MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    _goToSignUp(wohAmI);
                                  },
                                  child: Hero(
                                    tag: '註冊',
                                    child: Text(
                                      '立即註冊',
                                      style: TextStyle(
                                          fontSize: Adapt.px(25),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent),
                                    ),
                                  ),
                                  height: Adapt.px(100),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

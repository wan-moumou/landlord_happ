import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'app_const/Adapt.dart';
import 'app_const/app_const.dart';
import 'login.dart';
import 'rules_of_user.dart';

class SignUpPage extends StatefulWidget {
  bool whoMaI;

  SignUpPage({this.whoMaI});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  bool goToMyPageKey = false;
  bool whoMaI = true;
  int num = 0;
  TextEditingController firstNameController;
  TextEditingController listNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController password2Controller;
  TextEditingController phoneNumberController;
  TextEditingController addressController;
  TextEditingController howMaIController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  void _trySubmit() {
    _formKey.currentState.validate();
    _formKey1.currentState.validate();
    _formKey2.currentState.validate();
    _formKey3.currentState.validate();
    _formKey4.currentState.validate();
    _formKey5.currentState.validate();
    FocusScope.of(context).unfocus();
  }

  Color checkColor = Colors.black;
  bool check = false;

  @override
  void initState() {
    firstNameController = TextEditingController();
    listNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    password2Controller = TextEditingController();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();
    howMaIController = TextEditingController();
    super.initState();
  }

  void _goToLogIn() {
    Navigator.pop(context);
  }

  bool inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: widget.whoMaI
            ? AppConstants.appBarAndFontColor
            : AppConstants.tenantAppBarAndFontColor,
        title: Hero(
          tag: '註冊',
          child: Text(
            '註冊',
            style: TextStyle(fontSize: Adapt.px(40)),
          ),
        ),
      ),
      body: Container(
        color: widget.whoMaI
            ? AppConstants.backColor
            : AppConstants.tenantBackColor,
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: inAsyncCall,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 20, 10.0, 20),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '請輸入基本資料',
                            style: TextStyle(
                                fontSize: Adapt.px(30),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: Adapt.px(100),
                                  child: SignUpTextField(
                                    whoMaI: widget.whoMaI,
                                    function: (v) {
                                      if (firstNameController.text.length >= 5) {
                                        goToMyPageKey = false;
                                        return '輸入正確姓名';
                                      } else if (firstNameController.text.length <=
                                          2) {
                                        goToMyPageKey = false;
                                        return '長度必須大於２';
                                      }
                                      goToMyPageKey = true;
                                      return null;
                                    },
                                    labelText: '姓名',
                                    controller: firstNameController,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: Adapt.px(100),
                                  child: SignUpTextField(
                                    whoMaI: widget.whoMaI,
                                    function: (value) {
                                      if (emailController.text.contains('@')) {
                                        goToMyPageKey = true;
                                        return null;
                                      } else {
                                        goToMyPageKey = false;
                                        return '請輸入正確信箱';
                                      }
                                    },
                                    labelText: '信箱',
                                    controller: emailController,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: Adapt.px(100),
                                  child: SignUpTextField(
                                    whoMaI: widget.whoMaI,
                                    function: (value) {
                                      if (passwordController.text.length >= 6) {
                                        goToMyPageKey = true;
                                        return null;
                                      } else {
                                        goToMyPageKey = false;
                                        return '密碼必須大於６位數';
                                      }
                                    },
                                    labelText: '密碼',
                                    controller: passwordController,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: Adapt.px(100),
                                  child: SignUpTextField(
                                    whoMaI: widget.whoMaI,
                                    function: (value) {
                                      if (passwordController.text ==
                                          password2Controller.text) {
                                        goToMyPageKey = true;
                                        return null;
                                      } else {
                                        goToMyPageKey = false;
                                        return '兩次密碼不一樣';
                                      }
                                    },
                                    labelText: '重複密碼',
                                    controller: password2Controller,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: Adapt.px(100),
                                  child: SignUpTextField(
                                    whoMaI: widget.whoMaI,
                                    function: (value) {
                                      if (phoneNumberController.text.length < 10) {
                                        goToMyPageKey = false;
                                        return '請輸入正確手機號碼';
                                      } else if (phoneNumberController.text
                                                  .indexOf('0') ==
                                              0 &&
                                          phoneNumberController.text.length == 10) {
                                        goToMyPageKey = true;
                                        return null;
                                      } else {
                                        goToMyPageKey = false;
                                        return '檢查手機格式';
                                      }
                                    },
                                    labelText: '手機號碼',
                                    controller: phoneNumberController,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: Adapt.px(100),
                                  child: SignUpTextField(
                                    whoMaI: widget.whoMaI,
                                    function: (value) {
                                      if (addressController.text.contains('@') ||
                                          addressController.text.length < 7) {
                                        goToMyPageKey = false;
                                        return '請輸入完整地址';
                                      }
                                      goToMyPageKey = true;
                                      return null;
                                    },
                                    labelText: '居住地址',
                                    controller: addressController,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: check,
                                  onChanged: (v) {
                                    setState(() {
                                      check = !check;
                                    });
                                  },
                                ),
                                Text(
                                  '同意使用守則',
                                  style: TextStyle(
                                      fontSize: Adapt.px(30),
                                      fontWeight: FontWeight.bold,
                                      color: checkColor),
                                ),
                                FlatButton(
                                    onPressed: widget.whoMaI
                                        ? () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RulesOfUser()));
                                          }
                                        : () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImTenant()));
                                          },
                                    child: Text(
                                      '查看守則',
                                      style: TextStyle(fontSize: Adapt.px(25)),
                                    ))
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10.0, bottom: 20.0),
                          child: MaterialButton(
                            onPressed: check
                                ? () async {
                                    _trySubmit();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    goToMyPageKey
                                        ? setState(() {
                                            inAsyncCall = true;
                                          })
                                        : null;
                                    if (goToMyPageKey == true) {
                                      final newUser = await _auth
                                          .createUserWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                      widget.whoMaI
                                          ? await {
                                              _firestore
                                                  .collection('房東')
                                                  .document("帳號資料")
                                                  .collection(
                                                      emailController.text)
                                                  .document('資料')
                                                  .setData({
                                                'name':
                                                    firstNameController.text,
                                                '帳號': emailController.text,
                                                '密碼': passwordController.text,
                                                '手機號碼':
                                                    phoneNumberController.text,
                                                '地址': addressController.text,
                                                'url': " ",
                                                '門鎖密碼': " ",
                                                '更新':true
                                              }),
                                              await _firestore
                                                  .collection(
                                                      '房東/帳號資料/${emailController.text}')
                                                  .document('帳務資料')
                                                  .setData({
                                                '帳務更新': true,
                                                '詳細資料更新': true,
                                              })
                                            }
                                          : await _firestore
                                              .collection('房客')
                                              .document("帳號資料")
                                              .collection(emailController.text)
                                              .document('資料')
                                              .setData({
                                              'name': firstNameController.text,
                                              '帳號': emailController.text,
                                              '密碼': passwordController.text,
                                              '手機號碼':
                                                  phoneNumberController.text,
                                              '地址': addressController.text,
                                              'url': " ",
                                              '房東姓名': '',
                                              '剩餘度數': '0',
                                              '房屋名稱': '',
                                              '簽約日期': '',
                                              '門鎖密碼': '',
                                              '出租中': false,
                                        '更新':true
                                            });
                                      await _firestore
                                          .collection(
                                          '/房客/帳號資料/${emailController.text}')
                                          .document('帳務資料')
                                          .setData({
                                        '帳務更新': true,
                                        '詳細資料更新': true,
                                      });

                                      if (newUser != null) {
                                        firstNameController.clear();
                                        listNameController.clear();
                                        emailController.clear();
                                        passwordController.clear();
                                        password2Controller.clear();
                                        phoneNumberController.clear();
                                        addressController.clear();
                                        howMaIController.clear();
                                        _goToLogIn();
                                      }
                                    } else {}
                                  }
                                : () {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      checkColor = Colors.red;
                                    });
                                  },
                            child: Text(
                              '提交',
                              style: TextStyle(
                                  fontSize: Adapt.px(30),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            color: widget.whoMaI
                                ? AppConstants.appBarAndFontColor
                                : AppConstants.tenantAppBarAndFontColor,
                            height: Adapt.px(70),
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
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
      ),
    );
  }
}

// ignore: must_be_immutable
class SignUpTextField extends StatefulWidget {
  SignUpTextField(
      {Key key,
      this.labelText,
      this.controller,
      this.function,
      this.function2,
      this.whoMaI})
      : super(key: key);
  final String labelText;
  final TextEditingController controller;
  final Function function;
  final Function function2;
  bool whoMaI;

  @override
  _SignUpTextFieldState createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 0),
      child: TextFormField(
        onChanged: widget.function2,
        validator: widget.function,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                  color: widget.whoMaI
                      ? AppConstants.appBarAndFontColor
                      : AppConstants.tenantAppBarAndFontColor,
                  width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                  color: widget.whoMaI
                      ? AppConstants.appBarAndFontColor
                      : AppConstants.tenantAppBarAndFontColor,
                  width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(color: Colors.deepOrange, width: 2)),
        ),
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

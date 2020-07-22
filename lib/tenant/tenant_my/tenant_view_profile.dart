import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import '../../login.dart';
import '../tenant_guest_home_page.dart';

class TenantViewProFilePage extends StatefulWidget {
  final String userName;
  final String phoneNb;
  final String mail;
  final String address;
  final String password;
  final String url;

  TenantViewProFilePage(
      {this.url,
      this.userName,
      this.phoneNb,
      this.mail,
      this.address,
      this.password});

  @override
  _TenantViewProFilePageState createState() => _TenantViewProFilePageState();
}

class _TenantViewProFilePageState extends State<TenantViewProFilePage> {
  void upPassword() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user
        .updatePassword(passwordController.text)
        .then((_) {})
        .catchError((error) {
      print(error.toString());
    });
    await Firestore.instance
        .collection('房客')
        .document('帳號資料')
        .collection(user.email)
        .document('資料')
        .updateData({'密碼': passwordController.text, '更新': true});
  }

  void upAddress() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance
        .collection('房客')
        .document('帳號資料')
        .collection(user.email)
        .document('資料')
        .updateData({'地址': addressController.text, '更新': true});
  }

  void upPhoneNub() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance
        .collection('房客')
        .document('帳號資料')
        .collection(user.email)
        .document('資料')
        .updateData({'手機號碼': phoneController.text, '更新': true});
  }

  void renew({
    BuildContext context,
    String title,
    String labelText,
    String labelText2,
    Function onPressed,
    TextEditingController controller,
    TextEditingController controller2,
    bool inAsyncCall,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Text(title),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: labelText,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    TextFormField(
                      controller: controller2,
                      decoration: InputDecoration(
                          labelText: labelText2,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    OutlineButton(
                      onPressed: onPressed,
                      child: Text('確認'),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  void _logout() {
    _auth.signOut();
    Navigator.pushNamed(context, LoginPage.routeName);
  }

  bool inAsyncCall = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.tenantBackColor,
      appBar: AppBar(
        backgroundColor: AppConstants.tenantAppBarAndFontColor,
        centerTitle: true,
        title: Text('${widget.userName}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(13),
          child: Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                AddImage(
                  userID: widget.mail,
                  url: widget.url,
                ),
                ViewProfileListTile(
                  title: '姓名：',
                  userData: widget.userName,
                  color: AppConstants.tenantBackColor,
                ),
                ViewProfileListTile(
                  title: '信箱：',
                  userData: widget.mail,
                ),
                ViewProfileListTile(
                  title: '電話：',
                  userData: widget.phoneNb,
                  color: AppConstants.tenantBackColor,
                  iconButton: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        renew(
                            inAsyncCall: inAsyncCall,
                            context: context,
                            title: '更改電話號碼',
                            labelText: '新的電話號碼',
                            labelText2: '輸入密碼',
                            onPressed: () async {
                              if (phoneController2.text == widget.password) {
                                upPhoneNub();

                                Navigator.popAndPushNamed(
                                    context, TenantGuestHomePage.routeName);
                              }
                              return null;
                            },
                            controller: phoneController,
                            controller2: phoneController2);
                      }),
                ),
                ViewProfileListTile(
                  title: '地址：',
                  userData: widget.address,
                  iconButton: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        renew(
                            inAsyncCall: inAsyncCall,
                            context: context,
                            title: '更改地址',
                            labelText: '新地址',
                            labelText2: '輸入密碼',
                            controller: addressController,
                            controller2: passwordController2,
                            onPressed: () async {
                              if (passwordController2.text == widget.password) {
                                upAddress();
                                Navigator.popAndPushNamed(
                                    context, TenantGuestHomePage.routeName);
                              } else {
                                print(passwordController2.text);
                              }
                            });
                      }),
                ),
                MaterialButton(
                  height: MediaQuery.of(context).size.height * .08,
                  color: AppConstants.tenantBackColor,
                  minWidth: double.infinity,
                  onPressed: () {
                    renew(
                        inAsyncCall: inAsyncCall,
                        context: context,
                        title: '新密碼',
                        labelText: '輸入新密碼',
                        labelText2: '重複密碼',
                        controller: passwordController,
                        controller2: passwordController2,
                        onPressed: () async {
                          if (passwordController.text ==
                                  passwordController2.text &&
                              passwordController.text.isNotEmpty) {
                            setState(() {
                              inAsyncCall = true;
                            });
                            await upPassword();

                            inAsyncCall = false;
                            _logout();
                          } else {
                            {
                              return null;
                            }
                          }
                        });
                  },
                  child: Text('更改密碼'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewProfileListTile extends StatelessWidget {
  final String userData;
  final String title;
  final Color color;

  final Widget iconButton;

  ViewProfileListTile({this.userData, this.title, this.color, this.iconButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
            trailing: iconButton),
      ),
    );
  }
}

class AddImage extends StatefulWidget {
  final String userID;
  final String url;

  AddImage({this.userID, this.url});

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  String imageURL;

  void saveImages() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("房客")
        .child(widget.userID)
        .child('頭像')
        .child("個人資料${DateTime.now().second}");
    await ref.putFile(_imageFromGallery).onComplete;
    final url = await ref.getDownloadURL();

    await Firestore.instance
        .collection('房客')
        .document('帳號資料')
        .collection(widget.userID)
        .document('資料')
        .updateData({'url': url,'更新': true});
    Navigator.popAndPushNamed(context, TenantGuestHomePage.routeName);
  }

  final _picker = ImagePicker();

  Future _getImageFromGallery() async {
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _imageFromGallery = File(pickedFile.path);
    });
  }

  File _imageFromGallery;

  bool ok = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: MediaQuery.of(context).size.width * .2,
            backgroundImage: _imageFromGallery != null
                ? FileImage(_imageFromGallery)
                : NetworkImage(widget.url),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: AppConstants.tenantBackColor,
                child: MaterialButton(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '相冊',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Icon(Icons.add),
                      ],
                    ),
                    onPressed: () async {
                      await _getImageFromGallery();
                      setState(() {
                        ok = true;
                      });
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: AppConstants.tenantBackColor,
                child: MaterialButton(
                  child: Column(
                    children: <Widget>[
                      Text('儲存更變',
                          style: TextStyle(
                            fontSize: 10,
                          )),
                      Icon(Icons.save_alt),
                    ],
                  ),
                  onPressed: ok
                      ? () async {
                          setState(() {
                            ok = false;
                          });
                          await saveImages();

                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ABC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

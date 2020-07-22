import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';

import 'for_rent_tenant_Information.dart';

//以出租
class ForRentCard extends StatelessWidget {
  final int index;
  final String houseName;
  final String houseImages;
  final String houseImages2;
  final String address;
  final String houseMoney;
  final String tenantName;
  final String phoneNumber;
  final bool hasDoorLock;
  final List<String> imageList;
  String doorLockNUM;

  //點入後詳細資訊
  final String cashTime;
  final String waterMoney;
  final String electricityMoney;
  final bool television;
  final bool internetFee;
  final bool gasFee;
  final bool managementFee;
  final String gender;
  final String pet;
  final String smoke;
  final String party;
  final bool tvTable;
  final bool diningTable;
  final bool shoeBox;
  final bool bookBox;
  final bool sofa;
  final bool coffeeTable;
  final bool bedside;
  final bool wardrobe;
  final bool fluidTable;
  final bool gasStove;
  final bool bookTable;
  final bool dressingTable;
  final bool locker;
  final bool airConditioner;
  final bool wifi;
  final bool refrigerator;
  final bool washingMachine;
  final bool waterHeater;
  final bool microwaveOven;
  final bool oven;
  final bool tv;
  final bool cookerHood;
  final bool gas;
  final bool dishwasher;
  final bool phone;
  final bool wiredNetwork;
  final bool preservation;
  final bool fingerprintPasswordLock;
  final String contract; //合約日期
  final String tenantMail;
  final String otherFacilities;
  final bool fixed;

  //尚未使用的信息
  final String cityValues;
  final String houseTypeValues;
  final String roomTypeValues;
  final String floor;
  final String allFloor;
  final String area;
  final String bedroomsNum;
  final String bedNum;
  final String haveKitchen;
  final String haveLivingRoom;
  final String haveBalcony;
  final String bathroomType;
  final String houseIsWhoValues;
  final String housingIntroduction;
  final String deposit;

  ForRentCard({@required this.index,
    @required this.allFloor,
    @required this.fixed,
    @required this.otherFacilities,
    @required this.area,
    @required this.bathroomType,
    @required this.doorLockNUM,
    @required this.bedNum,
    @required this.bedroomsNum,
    @required this.cityValues,
    @required this.hasDoorLock,
    @required this.deposit,
    @required this.floor,
    @required this.haveBalcony,
    @required this.haveKitchen,
    @required this.haveLivingRoom,
    @required this.houseIsWhoValues,
    @required this.houseTypeValues,
    @required this.housingIntroduction,
    @required this.roomTypeValues,
    @required this.tenantName,
    @required this.houseImages2,
    @required this.imageList,
    @required this.tenantMail,
    @required this.contract,
    @required this.address,
    @required this.phoneNumber,
    @required this.houseMoney,
    @required this.managementFee,
    @required this.gasFee,
    @required this.internetFee,
    @required this.television,
    @required this.pet,
    @required this.airConditioner,
    @required this.wifi,
    @required this.refrigerator,
    @required this.phone,
    @required this.oven,
    @required this.washingMachine,
    @required this.waterHeater,
    @required this.dishwasher,
    @required this.microwaveOven,
    @required this.cookerHood,
    @required this.wiredNetwork,
    @required this.gas,
    @required this.fingerprintPasswordLock,
    @required this.preservation,
    @required this.tv,
    @required this.locker,
    @required this.fluidTable,
    @required this.dressingTable,
    @required this.bookTable,
    @required this.gasStove,
    @required this.bedside,
    @required this.tvTable,
    @required this.sofa,
    @required this.wardrobe,
    @required this.bookBox,
    @required this.shoeBox,
    @required this.diningTable,
    @required this.coffeeTable,
    @required this.waterMoney,
    @required this.electricityMoney,
    @required this.cashTime,
    @required this.party,
    @required this.gender,
    @required this.smoke,
    @required this.houseImages,
    @required this.houseName});

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  var loginUser;
  bool delete = false;
  TextEditingController doubleCheckController = TextEditingController();

  void deleteData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection('/房客/帳號資料/$tenantMail')
        .document('資料')
        .updateData({
      '房東姓名': '',
      '房屋名稱': '',
      '出租中': false,
    });
    await _firestore
        .collection('/房東/帳號資料/$loginUser/資料/擁有房間')
        .document(houseName)
        .delete();
  }

  void deleteRented(BuildContext context) {
    showDialog(
      //通过showDialog方法展示alert弹框
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(AntDesign.deleteuser),
              Text('確定解約'),
            ],
          ),
          content: Text('解約後不可復原!!'),
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
                Navigator.pop(context);
                doubleCheck(context);
              },
              textStyle: TextStyle(fontSize: 18, color: Colors.grey),
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void error(BuildContext context) {
    showDialog(
      //通过showDialog方法展示alert弹框
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('錯誤'),
          content: Text(
            "輸入文字錯誤",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            //操作控件
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                doubleCheck(context);
              },
              textStyle: TextStyle(fontSize: 18, color: Colors.grey),
              child: Text('重試'),
            ),
          ],
        );
      },
    );
  }

  void notRentedOnLongPress(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '選項',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                deleteRented(context);
              },
              child: Text('解約房客'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                doorLock(context);
              },
              child: Text('門鎖設定'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                waterAndEle(context);
              },
              child: Text('水電設定'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            //取消按钮
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('取消'),
          ),
        );
      },
    );
  }

  void doorLock(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '門鎖相關',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                lockOpenLockTimeSettings(context);
              },
              child: Text('臨時開啟'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            //取消按钮
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('取消'),
          ),
        );
      },
    );
  }

  void waterAndEle(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '水電相關',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                waterAndEleSettings(context);
              },
              child: Text('臨時開啟'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            //取消按钮
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('取消'),
          ),
        );
      },
    );
  }

  String openLock = '未選';
  int openLockTime = DateTime
      .now()
      .day;

  void lockOpenLockTimeSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text("設定"),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('臨時開啟:'),
                        Column(
                          children: <Widget>[
                            Container(
                              width: 150,
                              child: RadioListTile<String>(
                                  title: Text('一天'),
                                  value: "一天",
                                  groupValue: openLock,
                                  onChanged: (value) {
                                    setState(() {
                                      openLockTime = DateTime
                                          .now()
                                          .day + 1;
                                      openLock = value;
                                      print(openLockTime);
                                    });
                                  }),
                            ),
                            Container(
                              width: 150,
                              child: RadioListTile<String>(
                                  title: Text('兩天'),
                                  value: "兩天",
                                  groupValue: openLock,
                                  onChanged: (value) {
                                    setState(() {
                                      openLockTime = DateTime
                                          .now()
                                          .day + 2;
                                      openLock = value;
                                      print(openLockTime);
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text('儲存'),
                          color: AppConstants.appBarAndFontColor,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('取消'),
                          color: Colors.grey,
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  int openWaterTime = DateTime
      .now()
      .day;
  String openWater = '未選';
  String openEle = '未選';
  int openEleTime = DateTime
      .now()
      .day;

  void waterAndEleSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text("設定"),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('水閥\n臨時開啟:'),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: RadioListTile<String>(
                                      title: Text('一天'),
                                      value: "一天",
                                      groupValue: openWater,
                                      onChanged: (value) {
                                        setState(() {
                                          openWaterTime =
                                              DateTime
                                                  .now()
                                                  .day + 1;
                                          openWater = value;
                                          print(openWaterTime);
                                        });
                                      }),
                                ),
                                Container(
                                  width: 150,
                                  child: RadioListTile<String>(
                                      title: Text('兩天'),
                                      value: "兩天",
                                      groupValue: openEle,
                                      onChanged: (value) {
                                        setState(() {
                                          openEleTime = DateTime
                                              .now()
                                              .day + 2;
                                          openEle = value;
                                          print(openEleTime);
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('電表\n臨時開啟:'),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: RadioListTile<String>(
                                      title: Text('一天'),
                                      value: "一天",
                                      groupValue: openLock,
                                      onChanged: (value) {
                                        setState(() {
                                          openLockTime = DateTime
                                              .now()
                                              .day + 1;
                                          openLock = value;
                                          print(openLockTime);
                                        });
                                      }),
                                ),
                                Container(
                                  width: 150,
                                  child: RadioListTile<String>(
                                      title: Text('兩天'),
                                      value: "兩天",
                                      groupValue: openLock,
                                      onChanged: (value) {
                                        setState(() {
                                          openLockTime = DateTime
                                              .now()
                                              .day + 2;
                                          openLock = value;
                                          print(openLockTime);
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text(
                            '儲存',
                            style: TextStyle(
                                fontSize: Adapt.px(30), color: Colors.white),
                          ),
                          color: AppConstants.appBarAndFontColor,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '取消',
                            style: TextStyle(
                                fontSize: Adapt.px(30), color: Colors.white),
                          ),
                          color: Colors.grey,
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  void doubleCheck(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '解約請輸入"我要解約"\n後按下鍵盤上的確定\n解約後不可復原！',
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextFormField(
                      controller: doubleCheckController,
                      onEditingComplete: () {
                        setState(() {
                          delete = false;
                        });
                      },
                      onFieldSubmitted: (_) {
                        if (doubleCheckController.text != '我要解約') {
                          error(context);
                        } else {
                          setState(() {
                            delete = false;
                          });
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: OutlineButton(
                            onPressed: doubleCheckController.text == '我要解約'
                                ? delete == true
                                ? null
                                : () {
                              setState(() {
                                delete = true;
                                wait(context);
                                saveData();
                                Timer(Duration(seconds:3), () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              });
                            }
                                : null,
                            child: Text('確定'),
                            color: AppConstants.appBarAndFontColor,
                          ),
                        ),
                        Container(
                          child: OutlineButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('取消'),
                            color: AppConstants.appBarAndFontColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }
  void wait(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('資料加密傳輸中..請稍後'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Text(
                    '請勿關閉視窗',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }),
          );
        });
  }
  Future saveData() async {

    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      loginUser = currentUser.email;
      await _firestore
          .collection('房東')
          .document('新建房間')
          .collection(loginUser)
          .document(houseName)
          .setData({
        '門鎖相關': {'門鎖編號': doorLockNUM, '有無門鎖': hasDoorLock, '臨時密碼': '',},
        '照片位置': {
          '照片1': houseImages,
          '照片2': houseImages2,
        },
        '房間位置與類型': {
          '城市': cityValues,
          '地址': address,
          '建物型態': houseTypeValues,
          '房間類型': roomTypeValues
        },
        '樓層資訊': {
          '樓層': floor, //樓層
          '全部樓層': allFloor, //全部樓層樓層
          '房屋面積': area, //房屋面積
        },
        '房屋名稱': houseName,
        '其他條件': {
          '性別': gender,
          '吸菸': smoke,
          '開伙': party,
          '寵物': pet,
        },
        '房間格局': {
          '臥室數量': bedroomsNum, //臥室數量
          '床數': bedNum, //床數
          '廚房': haveKitchen, //廚房
          '客廳': haveLivingRoom, //客廳
          '陽台': haveBalcony, //陽台
          '衛浴': bathroomType, //衛浴
        },
        '房源': houseIsWhoValues,
        '簡介': housingIntroduction,
        '房屋費用設定': {
          '房租': houseMoney,
          '繳費時間': cashTime,
          '電費': electricityMoney,
          '水費': waterMoney,
          '電費儲值': fixed,
          '管理費': managementFee,
          '網路費': internetFee,
          '第四臺': television,
          '瓦斯費': gasFee,
          '押金': deposit,
        },
        '家具': {
          '茶几': coffeeTable,
          '餐桌': diningTable,
          '鞋櫃': shoeBox,
          '書櫃': bookBox,
          '衣櫃': wardrobe,
          '沙發': sofa,
          '電視櫃': tvTable,
          '床頭組': bedside,
          '瓦斯爐': gasStove,
          '書桌': bookTable,
          '梳妝台': dressingTable,
          '流理臺': fluidTable,
          '置物櫃': locker,
        },
        '設備': {
          '電視': tv,
          '冷氣': airConditioner,
          'wifi': wifi,
          '冰箱': refrigerator,
          '電話': phone,
          '烤箱': oven,
          '洗衣機': washingMachine,
          '熱水器': waterHeater,
          '洗碗機': dishwasher,
          '微波爐': microwaveOven,
          '油煙機': cookerHood,
          '有線網路': wiredNetwork,
          '瓦斯': gas,
          '指紋密碼鎖': fingerprintPasswordLock,
          '保全設備': preservation,
        },
        '附加設施': otherFacilities,
        '生成時間': DateTime.now().toUtc()
      });
      deleteData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * .8,
      child: Center(
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          onLongPress: () {
            notRentedOnLongPress(context);
          },
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ForRentTenantInformation(
                          index: index,
                          address: address,
                          otherFacilities: otherFacilities,
                          fixed: fixed,
                          houseMoney: houseMoney,
                          managementFee: managementFee,
                          gasFee: gasFee,
                          internetFee: internetFee,
                          television: television,
                          pet: pet,
                          airConditioner: airConditioner,
                          wifi: wifi,
                          refrigerator: refrigerator,
                          phone: phone,
                          oven: oven,
                          washingMachine: washingMachine,
                          waterHeater: waterHeater,
                          dishwasher: dishwasher,
                          microwaveOven: microwaveOven,
                          cookerHood: cookerHood,
                          wiredNetwork: wiredNetwork,
                          gas: gas,
                          fingerprintPasswordLock: fingerprintPasswordLock,
                          preservation: preservation,
                          tv: tv,
                          locker: locker,
                          fluidTable: fluidTable,
                          dressingTable: dressingTable,
                          bookTable: bookTable,
                          gasStove: gasStove,
                          bedside: bedside,
                          tvTable: tvTable,
                          sofa: sofa,
                          wardrobe: wardrobe,
                          bookBox: bookBox,
                          shoeBox: shoeBox,
                          diningTable: diningTable,
                          coffeeTable: coffeeTable,
                          waterMoney: waterMoney,
                          electricityMoney: electricityMoney,
                          cashTime: cashTime,
                          party: party,
                          gender: gender,
                          smoke: smoke,
                          houseName: houseName,
                          tenantMail: tenantMail,
                          contract: contract,
                        )));
          },
          child: Card(
            margin: EdgeInsets.fromLTRB(7, 10, 10, 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: AppConstants.appBarAndFontColor),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        houseName,
                        style: TextStyle(
                            fontSize: Adapt.px(30),
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: Adapt.px(650),
                  height: Adapt.px(450),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        imageList[index],
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: houseImages2 == "" ? false : true,
                    itemCount: houseImages2 == "" ? 1 : 2,
                    itemHeight: Adapt.px(450),
                    itemWidth: Adapt.px(650),
                    layout: SwiperLayout.STACK,
                  ),
                ),
                Divider(
                  height: 1.0,
                  endIndent: 18.0,
                  indent: 18.0,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person_outline,
                          size: Adapt.px(40),
                        ),
                        Text(
                          tenantName,
                          style: TextStyle(fontSize: Adapt.px(25)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 9),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: Adapt.px(40),
                      ),
                      Text(
                        '$houseMoney/月',
                        style: TextStyle(fontSize: Adapt.px(25)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone_iphone,
                          size: Adapt.px(40),
                        ),
                        Text(
                       phoneNumber,
                          style: TextStyle(fontSize: Adapt.px(25)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_city,
                          size: Adapt.px(40),
                        ),
                        Text(address,
                            style: TextStyle(fontSize: Adapt.px(25)),
                            maxLines: 2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 9),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.today,
                          size: Adapt.px(40),
                        ),
                        Text(
                          contract,
                          style: TextStyle(fontSize: Adapt.px(25)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: AppConstants.backColor,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CircleAvatar(
                            backgroundColor: AppConstants.backColor,
                            child: Icon(
                              Icons.build,
                              size: Adapt.px(50),
                              color: Colors.red[900],
                            )),
                      ),
                      Expanded(
                        child: CircleAvatar(
                            backgroundColor: AppConstants.backColor,
                            child: Icon(
                              Icons.format_color_reset,
                              size: Adapt.px(50),
                              color: Colors.red[900],
                            )),
                      ),
                      Expanded(
                        child: CircleAvatar(
                            backgroundColor: AppConstants.backColor,
                            child: Icon(
                              Icons.attach_money,
                              size: Adapt.px(50),
                              color: Colors.red[900],
                            )),
                      ),
                      Expanded(
                        child: Icon(
                            hasDoorLock
                                ? MaterialCommunityIcons.lock_open
                                : MaterialCommunityIcons.lock_question,
                            color: hasDoorLock ? Colors.black : Colors.red[900],
                            size: Adapt.px(50)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

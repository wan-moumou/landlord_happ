import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/user.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'create_house.dart';
import 'not_rented_tenant_information.dart';

//未出租
// ignore: must_be_immutable
class NotRentedCard extends StatefulWidget {
  //顯示相關
  final int index;
  final String houseName;
  final String houseImages;
  final String houseImages2;
  final List<String> imageList;
  final String address;
  final String houseMoney;
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
  final String otherFacilities;
  final bool fixed;
  final bool hasDoorLock;

// 尚未用到的資訊
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

  NotRentedCard(
      {@required this.index,
      @required this.address,
      @required this.fixed,
      @required this.allFloor,
      @required this.doorLockNUM,
      @required this.otherFacilities,
      @required this.area,
      @required this.bathroomType,
      @required this.hasDoorLock,
      @required this.bedNum,
      @required this.bedroomsNum,
      @required this.cityValues,
      @required this.deposit,
      @required this.floor,
      @required this.haveBalcony,
      @required this.haveKitchen,
      @required this.haveLivingRoom,
      @required this.houseIsWhoValues,
      @required this.houseTypeValues,
      @required this.housingIntroduction,
      @required this.roomTypeValues,
      @required this.houseMoney,
      @required this.houseImages2,
      @required this.imageList,
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

  @override
  _NotRentedCardState createState() => _NotRentedCardState();
}

class _NotRentedCardState extends State<NotRentedCard> {
  final _auth = FirebaseAuth.instance;

  final _firestore = Firestore.instance;

  var loginUser;

  User checkUser = User();

  bool forRentCheck;

  bool s = false;

  TextEditingController cashTimeController;

  TextEditingController electricityMoneyController;
  TextEditingController houseMoneyController;
  TextEditingController waterMoneyController;
  bool televisionModify;

  bool managementFeeModify;

  bool tvTableModify;

  bool diningTableModify;

  bool shoeBoxModify;

  bool bookBoxModify;

  bool sofaModify;

  bool coffeeTableModify;

  bool bedsideModify;

  bool wardrobeModify;

  bool fluidTableModify;

  bool gasStoveModify;

  bool bookTableModify;

  bool dressingTableModify;

  bool lockerModify;

  bool airConditionerModify;

  bool wifiModify;

  bool refrigeratorModify;

  bool washingMachineModify;

  bool waterHeaterModify;

  bool microwaveOvenModify;

  bool ovenModify;

  bool tvModify;

  bool cookerHoodModify;

  bool gasModify;

  bool dishwasherModify;

  bool phoneModify;

  bool wiredNetworkModify;

  bool preservationModify;

  bool fingerprintPasswordLockModify;

  void getBoolData() {
    televisionModify = widget.television;
    managementFeeModify = widget.managementFee;
    tvTableModify = widget.tvTable;
    diningTableModify = widget.diningTable;
    shoeBoxModify = widget.shoeBox;
    bookBoxModify = widget.bookBox;
    sofaModify = widget.sofa;
    coffeeTableModify = widget.coffeeTable;
    bedsideModify = widget.bedside;
    wardrobeModify = widget.wardrobe;
    fluidTableModify = widget.fluidTable;
    gasStoveModify = widget.gasStove;
    bookTableModify = widget.bookTable;
    dressingTableModify = widget.dressingTable;
    lockerModify = widget.locker;
    airConditionerModify = widget.airConditioner;
    wifiModify = widget.wifi;
    refrigeratorModify = widget.refrigerator;
    washingMachineModify = widget.washingMachine;
    waterHeaterModify = widget.waterHeater;
    microwaveOvenModify = widget.microwaveOven;
    ovenModify = widget.oven;
    tvModify = widget.tv;
    cookerHoodModify = widget.cookerHood;
    gasModify = widget.gas;
    dishwasherModify = widget.dishwasher;
    phoneModify = widget.phone;
    wiredNetworkModify = widget.wiredNetwork;
    preservationModify = widget.preservation;
    fingerprintPasswordLockModify = widget.fingerprintPasswordLock;
  }

  bool checkOk = true;

  void saveData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    print(loginUser);
    //確認房客身份
    await _firestore
        .collection("/房客/帳號資料/${addTenantIDController.text}")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        forRentCheck = f['出租中'];
        print(forRentCheck);
        User newUserData = User(name: f['name'], phoneNumber: f['手機號碼']);
        checkUser.name = newUserData.name;
        checkUser.phoneNumber = newUserData.phoneNumber;

        print(checkUser.phoneNumber);
        print(checkUser.name);
      });
    });

    if (addTenantNameController.text == checkUser.name &&
        checkUser.name != null &&
        !forRentCheck) {
      wait(context);
      await _firestore
          .collection('/房客/帳號資料/${addTenantIDController.text}')
          .document('資料')
          .updateData({
        '房東姓名': loginUser,
        '房屋名稱': widget.houseName,
        '出租中': true,
        '簽約日期':
            "${DateTime.now().toUtc().year}-${DateTime.now().toUtc().month}-${DateTime.now().toUtc().day}"
      });
      //上傳房間資料
      await _firestore
          .collection('房東/帳號資料/$loginUser/資料/擁有房間')
          .document(widget.houseName)
          .setData({
        '門鎖相關': {
          '門鎖編號': widget.doorLockNUM,
          '有無門鎖': widget.hasDoorLock,
          '臨時密碼': '',
        },
        '房客名稱': checkUser.name,
        '手機號碼': checkUser.phoneNumber,
        '房客帳號': addTenantIDController.text,
        '照片位置': {
          '照片1': widget.houseImages,
          '照片2': widget.houseImages2,
        },
        '房間位置與類型': {
          '城市': widget.cityValues,
          '地址': widget.address,
          '建物型態': widget.houseTypeValues,
          '房間類型': widget.roomTypeValues
        },
        '其他條件': {
          '性別': widget.gender,
          '吸菸': widget.smoke,
          '開伙': widget.party,
          '寵物': widget.pet,
        },
        '樓層資訊': {
          '樓層': widget.floor, //樓層
          '全部樓層': widget.allFloor, //全部樓層樓層
          '房屋面積': widget.area, //房屋面積
        },
        '房屋費用設定': {
          '房租': widget.houseMoney,
          '繳費時間': widget.cashTime,
          '電費': widget.electricityMoney,
          '水費': widget.waterMoney,
          '管理費': widget.managementFee,
          '網路費': widget.internetFee,
          '第四臺': widget.television,
          '瓦斯費': widget.gasFee,
          '押金': widget.deposit,
          '電費儲值': widget.fixed,
        },
        '房間格局': {
          '臥室數量': widget.bedroomsNum, //臥室數量
          '床數': widget.bedNum, //床數
          '廚房': widget.haveKitchen, //廚房
          '客廳': widget.haveLivingRoom, //客廳
          '陽台': widget.haveBalcony, //陽台
          '衛浴': widget.bathroomType, //衛浴
        },
        '房源': widget.houseIsWhoValues,
        '房屋名稱': widget.houseName,
        '簡介': widget.housingIntroduction,
        '家具': {
          '茶几': widget.coffeeTable,
          '餐桌': widget.diningTable,
          '鞋櫃': widget.shoeBox,
          '書櫃': widget.bookBox,
          '衣櫃': widget.wardrobe,
          '沙發': widget.sofa,
          '電視櫃': widget.tvTable,
          '床頭組': widget.bedside,
          '瓦斯爐': widget.gasStove,
          '書桌': widget.bookTable,
          '梳妝台': widget.dressingTable,
          '流理臺': widget.fluidTable,
          '置物櫃': widget.locker,
        },
        '設備': {
          '電視': widget.tv,
          '冷氣': widget.airConditioner,
          'wifi': widget.wifi,
          '冰箱': widget.refrigerator,
          '電話': widget.phone,
          '烤箱': widget.oven,
          '洗衣機': widget.washingMachine,
          '熱水器': widget.waterHeater,
          '洗碗機': widget.dishwasher,
          '微波爐': widget.microwaveOven,
          '油煙機': widget.cookerHood,
          '有線網路': widget.wiredNetwork,
          '瓦斯': widget.gas,
          '指紋密碼鎖': widget.fingerprintPasswordLock,
          '保全設備': widget.preservation,
        },
        '附加設施': widget.otherFacilities,
        '合約相關': {
          '簽約時長': signingTimeController.text ?? "",
          '提早進入': earlyEntryController.text==""||earlyEntryController.text==null? "0":earlyEntryController.text,
        },
        '生成時間':
            "${DateTime.now().toUtc().year}-${DateTime.now().toUtc().month}-${DateTime.now().toUtc().day}"
      });
      print('開始刪除');

      await _firestore
          .collection('房東/新建房間/$loginUser')
          .document(widget.houseName)
          .delete();
      print('刪除');

      addTenantNameController.clear();
      addTenantIDController.clear();
    } else {
      error(context);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  void upHouseMoneyData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection('房東/新建房間/$loginUser')
        .document(widget.houseName)
        .updateData({
      '房屋費用設定': {
        '房租': houseMoneyController.text == ''
            ? widget.houseMoney
            : houseMoneyController.text,
        '繳費時間': cashTimeController.text == ''
            ? widget.cashTime
            : cashTimeController.text,
        '電費': electricityMoneyController.text == ''
            ? widget.electricityMoney
            : electricityMoneyController.text,
        '水費': waterMoneyController.text == ""
            ? widget.waterMoney
            : waterMoneyController.text,
        '管理費': widget.managementFee,
        '網路費': widget.internetFee,
        '第四臺': widget.television,
        '瓦斯費': widget.gasFee,
        '押金': widget.deposit,
        '電費儲值': widget.fixed,
      }
    });
  }

  void upFurnitureData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection('房東/新建房間/$loginUser')
        .document(widget.houseName)
        .updateData({
      '家具': {
        '茶几': coffeeTableModify,
        '餐桌': diningTableModify,
        '鞋櫃': shoeBoxModify,
        '書櫃': bookBoxModify,
        '衣櫃': wardrobeModify,
        '沙發': sofaModify,
        '電視櫃': tvTableModify,
        '床頭組': bedsideModify,
        '瓦斯爐': gasStoveModify,
        '書桌': bookTableModify,
        '梳妝台': dressingTableModify,
        '流理臺': fluidTableModify,
        '置物櫃': lockerModify,
      },
    });
  }

  void upEquipmentData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection('房東/新建房間/$loginUser')
        .document(widget.houseName)
        .updateData({
      '設備': {
        '電視': tvModify,
        '冷氣': airConditionerModify,
        'wifi': wifiModify,
        '冰箱': refrigeratorModify,
        '電話': phoneModify,
        '烤箱': ovenModify,
        '洗衣機': washingMachineModify,
        '熱水器': waterHeaterModify,
        '洗碗機': dishwasherModify,
        '微波爐': microwaveOvenModify,
        '油煙機': cookerHoodModify,
        '有線網路': wiredNetworkModify,
        '瓦斯': gasModify,
        '指紋密碼鎖': fingerprintPasswordLockModify,
        '保全設備': preservationModify,
      },
    });
  }

  void deleteData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection('房東/新建房間/$loginUser')
        .document(widget.houseName)
        .delete();
  }

  Future saveLockNum() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    print(widget.doorLockNUM);
    await _firestore
        .collection('/房東/新建房間/$loginUser')
        .document(widget.houseName)
        .updateData({
      '門鎖相關': {
        '門鎖編號': widget.doorLockNUM,
        '有無門鎖': true,
      }
    });
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
          content: Text('刪除後不可復原'),
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
                deleteData();

                Navigator.pop(context);
              },
              textStyle: TextStyle(fontSize: 18, color: Colors.grey),
              child: Text('确定'),
            ),
          ],
        );
      },
    );
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

  void error(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('失敗'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Text(
                    '房客名稱或帳號錯誤,請重新在試',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }),
          );
        });
  }

  void lockSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text("門鎖登入"),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * .5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                            width: 300,
                            height: 300,
                            child: QrCamera(
                              onError: (context, error) => Text(
                                error.toString(),
                                style: TextStyle(color: Colors.red),
                              ),
                              qrCodeCallback: (code) {
                                setState(() {
                                  widget.doorLockNUM = code;
                                  print(widget.doorLockNUM);
                                });
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: AppConstants.appBarAndFontColor,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            )),
                        widget.doorLockNUM == '' ||
                                widget.doorLockNUM.length > 5
                            ? Text(
                                '請對準門鎖後貼紙',
                                style: TextStyle(fontSize: Adapt.px(25)),
                              )
                            : Text(
                                '成功獲取\n${widget.doorLockNUM}請按下加入',
                                style: TextStyle(fontSize: Adapt.px(25)),
                              )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: widget.doorLockNUM == '' ||
                                  widget.doorLockNUM.length > 5
                              ? null
                              : () async {
                                  wait(context);
                                  await saveLockNum();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                          child: Text(
                            '加入',
                            style: TextStyle(color: Colors.white),
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
                          child:
                              Text('取消', style: TextStyle(color: Colors.white)),
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

  String openLock = '未選';

  int openLockTime = DateTime.now().day;

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
                height: MediaQuery.of(context).size.height * .3,
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
                                      openLockTime = DateTime.now().day + 1;
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
                                      openLockTime = DateTime.now().day + 2;
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
                            Navigator.pop(context);
                            wait(context);
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
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                lockSettings(context);
              },
              child: Text('加入門鎖'),
            ),
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

  void modify(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('修改內容'),
          //标题
          titlePadding: EdgeInsets.all(20),
          //标题的padding值
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('每月房租'),
                Container(
                  height: 60,
                  child: NewHouseTextFiledKBTypeNum(
                    regExp: '0-9',
                    maxInt: 6,
                    labelText: '租金,包含其他費用',
                    hintText: '４５００',
                    controller: houseMoneyController,
                    width: 1,
                  ),
                ),
                Text('繳費時間'),
                Container(
                  height: 60,
                  child: NewHouseTextFiledKBTypeNum(
                    regExp: '0-9',
                    maxInt: 2,
//                onEditingComplete: maxCashTime,
                    labelText: '繳費時間',
                    hintText: '每月３',
                    controller: cashTimeController,
                    width: 1,
                  ),
                ),
                widget.fixed
                    ? Text(
                        '電費儲值每度',
                        style: TextStyle(fontSize: 13),
                      )
                    : Text(
                        '每月電費',
                        style: TextStyle(fontSize: 13),
                      ),
                Container(
                  height: 60,
                  child: NewHouseTextFiledKBTypeNum(
                    regExp: '0-9',
                    maxInt: widget.fixed ? 1 : 4,
//                onEditingComplete:
//                maxElectricityMoney,
                    labelText: widget.fixed ? '每度' : '每月',
                    hintText: widget.fixed ? '５' : '４００',
                    controller: electricityMoneyController,
                    width: 1,
                  ),
                ),
                Text(
                  '每月水費',
                  style: TextStyle(fontSize: 13),
                ),
                Container(
                  height: 60,
                  child: NewHouseTextFiledKBTypeNum(
                    regExp: '0-9',
                    maxInt: 3,
                    labelText: '每月',
                    hintText: '300',
                    controller: waterMoneyController,
                  ),
                ),
              ],
            ),
          ),
          //弹框展示主要内容
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          //内容的padding值
          actions: <Widget>[
            //操作按钮数组

            FlatButton(
              onPressed: () {
                print("取消");
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            StatefulBuilder(builder: (context, StateSetter setState) {
              return FlatButton(
                  onPressed: () async {
                    wait(context);
                    upHouseMoneyData();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: ok == '確定'
                      ? Text(
                          ok,
                        )
                      : Text(
                          ok,
                          style: TextStyle(color: Colors.red),
                        ));
            })
          ],
        );
      },
    );
  }

  void furnitureRelated(BuildContext context) {
//展示AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text('家具相關'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '請點擊圖標更改',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ),
            ],
          ),
          //标题
          titlePadding: EdgeInsets.all(20),
          //标题的padding值
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        coffeeTableModify = !coffeeTableModify;
                                      });
                                    },
                                    icon: Icon(
                                      coffeeTableModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: coffeeTableModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '茶几',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        tvTableModify = !tvTableModify;
                                      });
                                    },
                                    icon: Icon(
                                      tvTableModify ? Icons.check : Icons.clear,
                                      color: tvTableModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '電視櫃',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        diningTableModify = !diningTableModify;
                                      });
                                    },
                                    icon: Icon(
                                      diningTableModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: diningTableModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '餐桌',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        bookBoxModify = !bookBoxModify;
                                      });
                                    },
                                    icon: Icon(
                                      bookBoxModify ? Icons.check : Icons.clear,
                                      color: bookBoxModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '書櫃',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        shoeBoxModify = !shoeBoxModify;
                                      });
                                    },
                                    icon: Icon(
                                      shoeBoxModify ? Icons.check : Icons.clear,
                                      color: shoeBoxModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '鞋櫃',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        sofaModify = !sofaModify;
                                      });
                                    },
                                    icon: Icon(
                                      sofaModify ? Icons.check : Icons.clear,
                                      color: sofaModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '沙發',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        bedsideModify = !bedsideModify;
                                      });
                                    },
                                    icon: Icon(
                                      bedsideModify ? Icons.check : Icons.clear,
                                      color: bedsideModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '床頭組',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        wardrobeModify = !wardrobeModify;
                                      });
                                    },
                                    icon: Icon(
                                      wardrobeModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: wardrobeModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '衣櫃',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        fluidTableModify = !fluidTableModify;
                                      });
                                    },
                                    icon: Icon(
                                      fluidTableModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: fluidTableModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '流理台',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        gasStoveModify = !gasStoveModify;
                                      });
                                    },
                                    icon: Icon(
                                      gasStoveModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: gasStoveModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '瓦斯爐',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        bookTableModify = !bookTableModify;
                                      });
                                    },
                                    icon: Icon(
                                      bookTableModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: bookTableModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '書桌椅',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        lockerModify = !lockerModify;
                                      });
                                    },
                                    icon: Icon(
                                      lockerModify ? Icons.check : Icons.clear,
                                      color: lockerModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '置物櫃',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        dressingTableModify =
                                            !dressingTableModify;
                                      });
                                    },
                                    icon: Icon(
                                      dressingTableModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: dressingTableModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '梳妝台',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          //弹框展示主要内容
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          //内容的padding值
          actions: <Widget>[
            //操作按钮数组

            FlatButton(
              onPressed: () {
                print("取消");
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            StatefulBuilder(builder: (context, StateSetter setState) {
              return FlatButton(
                  onPressed: () {
                    setState(() {
                      ok = '請勿關閉視窗';
                    });
                    upFurnitureData();
                    Navigator.pop(context);
                    setState(() {
                      ok = '確定';
                    });
                  },
                  child: ok == '確定'
                      ? Text(
                          ok,
                        )
                      : Text(
                          ok,
                          style: TextStyle(color: Colors.red),
                        ));
            })
          ],
        );
      },
    );
  }

  void equipmentUpData(BuildContext context) {
//展示AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text('設備相關'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '請點擊圖標更改',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ),
            ],
          ),
          //标题
          titlePadding: EdgeInsets.all(20),
          //标题的padding值
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        airConditionerModify =
                                            !airConditionerModify;
                                      });
                                    },
                                    icon: Icon(
                                      airConditionerModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: airConditionerModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '冷氣',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        wifiModify = !wifiModify;
                                      });
                                    },
                                    icon: Icon(
                                      wifiModify ? Icons.check : Icons.clear,
                                      color: wifiModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  'WIFI',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        refrigeratorModify =
                                            !refrigeratorModify;
                                      });
                                    },
                                    icon: Icon(
                                      refrigeratorModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: refrigeratorModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '冰箱',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        washingMachineModify =
                                            !washingMachineModify;
                                      });
                                    },
                                    icon: Icon(
                                      washingMachineModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: washingMachineModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '洗衣機',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        waterHeaterModify = !waterHeaterModify;
                                      });
                                    },
                                    icon: Icon(
                                      waterHeaterModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: waterHeaterModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '熱水器',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        microwaveOvenModify =
                                            !microwaveOvenModify;
                                      });
                                    },
                                    icon: Icon(
                                      microwaveOvenModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: microwaveOvenModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '微波爐',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ovenModify = !ovenModify;
                                      });
                                    },
                                    icon: Icon(
                                      ovenModify ? Icons.check : Icons.clear,
                                      color: ovenModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '烤箱',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        tvModify = !tvModify;
                                      });
                                    },
                                    icon: Icon(
                                      tvModify ? Icons.check : Icons.clear,
                                      color: tvModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '電視',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cookerHoodModify = !cookerHoodModify;
                                      });
                                    },
                                    icon: Icon(
                                      cookerHoodModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: cookerHoodModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '排油煙機',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        gasModify = !gasModify;
                                      });
                                    },
                                    icon: Icon(
                                      gasModify ? Icons.check : Icons.clear,
                                      color: gasModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '瓦斯',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        dishwasherModify = !dishwasherModify;
                                      });
                                    },
                                    icon: Icon(
                                      dishwasherModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: dishwasherModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '洗碗機',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        phoneModify = !phoneModify;
                                      });
                                    },
                                    icon: Icon(
                                      phoneModify ? Icons.check : Icons.clear,
                                      color: phoneModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '電話',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        wiredNetworkModify =
                                            !wiredNetworkModify;
                                      });
                                    },
                                    icon: Icon(
                                      wiredNetworkModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: wiredNetworkModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '有線網路',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        preservationModify =
                                            !preservationModify;
                                      });
                                    },
                                    icon: Icon(
                                      preservationModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: preservationModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '保全設施',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        fingerprintPasswordLockModify =
                                            !fingerprintPasswordLockModify;
                                      });
                                    },
                                    icon: Icon(
                                      fingerprintPasswordLockModify
                                          ? Icons.check
                                          : Icons.clear,
                                      color: fingerprintPasswordLockModify
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                  );
                                }),
                                Text(
                                  '指紋密碼鎖',
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          //弹框展示主要内容
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          //内容的padding值
          actions: <Widget>[
            //操作按钮数组

            FlatButton(
              onPressed: () {
                print("取消");
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            StatefulBuilder(builder: (context, StateSetter setState) {
              return FlatButton(
                  onPressed: () {
                    setState(() {
                      ok = '請勿關閉視窗';
                    });
                    upEquipmentData();
                    Navigator.pop(context);
                  },
                  child: ok == '確定'
                      ? Text(
                          ok,
                        )
                      : Text(
                          ok,
                          style: TextStyle(color: Colors.red),
                        ));
            })
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
                newTenant(context);
              },
              child: Text('加入房客'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                doorLock(context);
              },
              child: Text('門鎖相關'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                notRentedModify(context);
              },
              child: Text('修改'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                deleteNotRentedData(context);
              },
              child: Text('刪除'),
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

  TextEditingController signingTimeController = TextEditingController();
  TextEditingController earlyEntryController = TextEditingController();

  void notRentedModify(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '修改',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                cashTimeController = TextEditingController();
                electricityMoneyController = TextEditingController();
                houseMoneyController = TextEditingController();
                waterMoneyController = TextEditingController();
                modify(context);
              },
              child: Text('房租相關'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

                furnitureRelated(context);
              },
              child: Text('家具相關'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                equipmentUpData(context);
              },
              child: Text('設備相關'),
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

  String ok = '確定';

  void newTenant(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        AntDesign.adduser,
                        color: AppConstants.appBarAndFontColor,
                      ),
                    ),
                    Text(
                      "加入房客",
                      style: TextStyle(
                          fontSize: Adapt.px(45),
                          color: AppConstants.appBarAndFontColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '請輸入房客姓名及帳號以配對',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: addTenantNameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            /*边角*/
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          labelText: '房客姓名',
                          hintText: 'Ex.王祥宇',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: addTenantIDController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            /*边角*/
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          labelText: '房客帳號',
                          hintText: 'Ex.b34866575@gmail.com',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '簽約時長',
                        style: TextStyle(
                            fontSize: Adapt.px(30),
                            color: AppConstants.appBarAndFontColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: signingTimeController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  /*边角*/
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                labelText: '合約時長',
                                hintText: 'Ex.24',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '個月',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Adapt.px(30),
                              color: AppConstants.appBarAndFontColor),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '提前入住天數',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Adapt.px(30),
                                color: AppConstants.appBarAndFontColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: earlyEntryController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  /*边角*/
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                labelText: '0',
                                hintText: 'Ex.3',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '天',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Adapt.px(30),
                              color: AppConstants.appBarAndFontColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: OutlineButton(
                            onPressed: s
                                ? null
                                : () async {
                                    setState(() {
                                      s = true;
                                    });
                                    setState(() {
                                      ok = '請勿關閉視窗...';
                                    });
                                    await saveData();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    setState(() {
                                      ok = '確定';
                                      s = false;
                                    });
                                  },
                            child: ok == '確定'
                                ? Text(ok)
                                : Text(
                                    ok,
                                    style: TextStyle(color: Colors.red),
                                  ),
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

  TextEditingController addTenantNameController = TextEditingController();

  TextEditingController addTenantIDController = TextEditingController();

  bool inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
          onLongPress: () {
            getBoolData();
            notRentedOnLongPress(context);
          },
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotRentedTenantInformation(
                          index: widget.index,
                          otherFacilities: widget.otherFacilities,
                          address: widget.address,
                          fixed: widget.fixed,
                          houseMoney: widget.houseMoney,
                          managementFee: widget.managementFee,
                          gasFee: widget.gasFee,
                          internetFee: widget.internetFee,
                          television: widget.television,
                          pet: widget.pet,
                          airConditioner: widget.airConditioner,
                          wifi: widget.wifi,
                          refrigerator: widget.refrigerator,
                          phone: widget.phone,
                          oven: widget.oven,
                          washingMachine: widget.washingMachine,
                          waterHeater: widget.waterHeater,
                          dishwasher: widget.dishwasher,
                          microwaveOven: widget.microwaveOven,
                          cookerHood: widget.cookerHood,
                          wiredNetwork: widget.wiredNetwork,
                          gas: widget.gas,
                          fingerprintPasswordLock:
                              widget.fingerprintPasswordLock,
                          preservation: widget.preservation,
                          tv: widget.tv,
                          locker: widget.locker,
                          fluidTable: widget.fluidTable,
                          dressingTable: widget.dressingTable,
                          bookTable: widget.bookTable,
                          gasStove: widget.gasStove,
                          bedside: widget.bedside,
                          tvTable: widget.tvTable,
                          sofa: widget.sofa,
                          wardrobe: widget.wardrobe,
                          bookBox: widget.bookBox,
                          shoeBox: widget.shoeBox,
                          diningTable: widget.diningTable,
                          coffeeTable: widget.coffeeTable,
                          waterMoney: widget.waterMoney,
                          electricityMoney: widget.electricityMoney,
                          cashTime: widget.cashTime,
                          party: widget.party,
                          gender: widget.gender,
                          smoke: widget.smoke,
                          houseName: widget.houseName,
                        )));
          },
          child: Card(
            margin: EdgeInsets.fromLTRB(7, 10, 10, 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: AppConstants.appBarAndFontColor),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        widget.houseName,
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
                        widget.imageList[index],
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: widget.houseImages2 == "" ? false : true,
                    itemCount: widget.houseImages2 == "" ? 1 : 2,
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
                Divider(
                  height: 1.0,
                  endIndent: 18.0,
                  indent: 18.0,
                  color: Colors.grey,
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
                        '${widget.houseMoney}/月',
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
                          Icons.location_city,
                          size: Adapt.px(40),
                        ),
                        Text(widget.address,
                            style: TextStyle(fontSize: Adapt.px(25)),
                            maxLines: 2),
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
                          Icons.home,
                          size: Adapt.px(40),
                        ),
                        Text(widget.houseTypeValues,
                            style: TextStyle(fontSize: Adapt.px(25)),
                            maxLines: 2),
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
                          Icons.attach_money,
                          size: Adapt.px(40),
                        ),
                        Text("水費${widget.waterMoney}/月",
                            style: TextStyle(fontSize: Adapt.px(25)),
                            maxLines: 2),
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
                          Icons.attach_money,
                          size: Adapt.px(40),
                        ),
                        Text(
                            widget.fixed
                                ? "電費${widget.electricityMoney}/度"
                                : "電費${widget.electricityMoney}/月",
                            style: TextStyle(fontSize: Adapt.px(25)),
                            maxLines: 2),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: AppConstants.backColor,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            backgroundColor: AppConstants.backColor,
                            child: Icon(
                              widget.smoke == '可'
                                  ? Icons.smoking_rooms
                                  : Icons.smoke_free,
                              color: Colors.black,
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            backgroundColor: AppConstants.backColor,
                            child: Icon(
                              widget.fingerprintPasswordLock
                                  ? Icons.phonelink_lock
                                  : Icons.phonelink_erase,
                              color: Colors.black,
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            backgroundColor: AppConstants.backColor,
                            child: Icon(
                              widget.pet == '可' ? Icons.pets : Icons.pets,
                              color:
                                  widget.pet == '可' ? Colors.black : Colors.red,
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: AppConstants.backColor,
                          child: Icon(
                            widget.wifi ? Icons.wifi : Icons.wifi_lock,
                            size: Adapt.px(50),
                            color: Colors.black,
                          ),
                        ),
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

class IconData extends StatelessWidget {
  final bool have;
  final String title;

  IconData({this.have, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          children: <Widget>[
            StatefulBuilder(builder: (context, StateSetter setState) {
              return IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  have ? Icons.check : Icons.clear,
                  color: have ? Colors.black : Colors.grey[300],
                ),
              );
            }),
            Text(
              '$title',
              style: TextStyle(fontSize: 12),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}

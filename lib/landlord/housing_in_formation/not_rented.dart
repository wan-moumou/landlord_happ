import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/new_house.dart';
import 'package:landlord_happy/app_const/user.dart';
import 'package:landlord_happy/landlord/message/handwriting.dart';
import 'package:landlord_happy/landlord/message/message.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:screenshot/screenshot.dart';
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
  String gatewayNUM;

  //點入後詳細資訊
  final String cashTime;
  final String waterMoney;
  final String electricityMoney;
  final String summerElectricityMoney;
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
  final bool hasGateway;
  final bool noHasGatewayFixd;
  final bool storedValue;

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
  final String cti;
  final String theTotalArea;

  NotRentedCard(
      {@required this.index,
      @required this.address,
      @required this.fixed,
      @required this.storedValue,
      @required this.noHasGatewayFixd,
      @required this.cti,
      @required this.theTotalArea,
      @required this.allFloor,
      @required this.doorLockNUM,
      @required this.otherFacilities,
      @required this.summerElectricityMoney,
      @required this.area,
      @required this.bathroomType,
      @required this.hasDoorLock,
      @required this.hasGateway,
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
      @required this.gatewayNUM,
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
  NewHouse newHouse = NewHouse();

  bool forRentCheck;

  bool s = false;
  String nowMonth;
  TextEditingController cashTimeController;

  TextEditingController electricityMoneyController;
  TextEditingController summerElectricityMoneyController;
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
  bool parkingSpace;
  bool thatPower;
  bool seizureOfRegistration;
  bool flatParking;
  bool mechanicalParkingSpace;
  bool allDay;
  bool dayTime;
  bool other;
  bool night;
  bool restore;
  bool renter;
  bool lessee;
  bool newsletter;
  bool app;
  bool mail;
  bool range;
  String nowYear;
  String contractStartMonth;
  String nowDay;

  String contractStartDay;
  String money;
  String toYear;

  String toMonth;

  @required
  void initState() {
    getPoints();
    nowMonth = DateTime.now().month.toString();
    toYear = "${DateTime.now().year - 1911}";
    toMonth = DateTime.now().month.toString();
    super.initState();
  }

  String points;

  Future getPoints() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    //確認房客身份
    final aa = await Firestore.instance
        .collection('房東/帳號資料/$loginUser')
        .getDocuments();
    points = aa.documents[1]['剩餘點數'];
  }

  Future saveData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
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
      });
    });

    print(points);
    if (int.parse(points) >= 7) {
      if (addTenantNameController.text == checkUser.name &&
          checkUser.name != null &&
          !forRentCheck) {
        wait(context, '資料加密傳輸中..請稍後', '請勿關閉視窗');
        await Firestore.instance
            .collection('房東/帳號資料/$loginUser')
            .document("資料")
            .updateData({
          '剩餘點數': '${int.parse(points) - int.parse('7')}',
        });
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
          '網關相關': {
            '網關編號': widget.gatewayNUM ?? '',
            '有無電表': widget.hasGateway ?? false,
            '上期度數': '',
            '本期度數': '',
            '使用度數': '',
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
            '夏季電費': widget.summerElectricityMoney,
            '水費': widget.waterMoney,
            '管理費': widget.managementFee,
            '網路費': widget.internetFee,
            '第四臺': widget.television,
            '瓦斯費': widget.gasFee,
            '押金': widget.deposit,
            '電費每月固定': widget.storedValue,
            '電費儲值': widget.hasGateway ? false : widget.fixed,
            '有電表儲值單位':
                widget.hasGateway == null || widget.hasGateway && widget.fixed
                    ? true
                    : false,
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
          '生成時間':
              "${DateTime.now().toUtc().year}-${DateTime.now().toUtc().month}-${DateTime.now().toUtc().day}"
        });
        await Firestore.instance
            .collection('/房東/帳號資料/$loginUser/資料/擁有房間/${widget.houseName}/合約')
            .document('房間合約')
            .setData({
          '合約類型': true,
        });
        Navigator.pop(context);
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
    } else {
      wait(context, '剩餘點數不足...請儲值後重試', '剩餘點數$points');
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  Future checkTenant() async {
    //確認房客身份
    if (int.parse(points) >= 7) {
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
        });
      });
      if (addTenantNameController.text == checkUser.name &&
          checkUser.name != null &&
          !forRentCheck) {
        print('確認身分完畢進入合約');
        if (newHouse.data['合約時長'] == '請選擇') {
          wait(context, '請選擇簽約時長', '請選擇簽約時長');
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          vewContract(
              context,
              widget.cti,
              widget.address,
              name,
              widget.theTotalArea,
              widget.floor,
              widget.houseMoney,
              widget.cashTime,
              widget.deposit,
              widget.managementFee,
              widget.fixed,
              widget.summerElectricityMoney,
              widget.electricityMoney,
              widget.television,
              widget.gasFee,
              widget.internetFee,
              landlordAdd,
              landlordPhone,
              landlordMail,
              false,
              toMonth,
              toYear,
              addTenantNameController.text,
              addTenantIDController.text);
        }
      } else {
        error(context);
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    } else {
      wait(context, '剩餘點數不足...請儲值後重試', '剩餘點數$points');
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  Future saveMessageData() async {
    print(points);
    if (int.parse(points) >= 7) {
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
      final jj = await Firestore.instance
          .collection('房東/帳號資料/$loginUser/資料/合約')
          .getDocuments();

      final data = jj.documents[0];
      setState(() {
        url = data['${widget.houseName}合約'];
      });

      final nowTime = DateTime.now().toString();
      await Firestore.instance
          .collection('房客')
          .document('帳號資料')
          .collection(addTenantIDController.text)
          .document('資料')
          .collection('聯絡房東')
          .document(nowTime)
          .setData({
        '回報類型': "簽約",
        '房客姓名': addTenantNameController.text,
        '房間名稱': widget.houseName,
        '回報內容': '合約',
        '處理標籤': false,
        '回覆內容': '',
        '生成時間': DateTime.now(),
        '回報時間':
            "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日",
        '房東帳號': loginUser,
        '房客帳號': addTenantIDController.text,
        '退租': false
      });
      await Firestore.instance
          .collection('房東')
          .document('帳號資料')
          .collection(loginUser)
          .document('資料')
          .collection('聯絡房客')
          .document(nowTime)
          .setData({
        '回報類型': "簽約",
        '房客姓名': addTenantNameController.text,
        '房間名稱': widget.houseName,
        '回報內容': '合約',
        '處理標籤': false,
        '回覆內容': '',
        '生成時間': DateTime.now(),
        '回報時間':
            "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日",
        '房東帳號': loginUser,
        '房客帳號': addTenantIDController.text,
        '退租': false
      });
      Navigator.pop(context);

      addTenantNameController.clear();
      addTenantIDController.clear();
      Navigator.pop(context);
    } else {
      wait(context, '剩餘點數不足...請儲值後重試', '剩餘點數$points');
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
        '夏季電費': summerElectricityMoneyController.text == ''
            ? widget.summerElectricityMoney
            : summerElectricityMoneyController.text,
        '水費': waterMoneyController.text == ""
            ? widget.waterMoney
            : waterMoneyController.text,
        '管理費': widget.managementFee,
        '網路費': widget.internetFee,
        '第四臺': widget.television,
        '瓦斯費': widget.gasFee,
        '押金': widget.deposit,
        '電費儲值': widget.fixed,
        '有電表儲值單位': widget.noHasGatewayFixd,
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

  Future saveGatewayNum() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    await _firestore
        .collection('/房東/新建房間/$loginUser')
        .document(widget.houseName)
        .updateData({
      '網關相關': {
        '網關編號': widget.gatewayNUM,
        '有無電表': true,
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

  void wait(BuildContext context, text, points) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(text),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Text(
                    points,
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
                                  wait(context, '資料加密傳輸中..請稍後', '請勿關閉視窗');
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

  void gatewaySettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text("網關登入"),
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
                                  widget.gatewayNUM = code;
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
                        widget.gatewayNUM == '' || widget.gatewayNUM.length > 5
                            ? Text(
                                '請對準網關後貼紙',
                                style: TextStyle(fontSize: Adapt.px(25)),
                              )
                            : Text(
                                '成功獲取\n${widget.gatewayNUM}請按下加入',
                                style: TextStyle(fontSize: Adapt.px(25)),
                              )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: widget.gatewayNUM == '' ||
                                  widget.gatewayNUM.length > 5
                              ? null
                              : () async {
                                  wait(context, '資料加密傳輸中..請稍後', '請勿關閉視窗');
                                  await saveGatewayNum();
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
                            wait(context, '資料加密傳輸中..請稍後', '請勿關閉視窗');
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

  File _imageFile;
  String url = '';

  Future saveImages() async {
    if (_imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${widget.houseName}合約')
          .child(loginUser)
          .child('合約');

      await ref.putFile(_imageFile).onComplete;

      url = await ref.getDownloadURL();

      await Firestore.instance
          .collection('/房東/帳號資料/$loginUser/資料/合約')
          .document('${widget.houseName}合約')
          .setData({'${widget.houseName}合約': url});
      print('完成');
    }
  }

  ScreenshotController screenshotController = ScreenshotController();

  Future getPicture() async {
    wait(context, '資料加密傳輸中..請稍後', '請勿關閉視窗');
    await screenshotController.capture().then((File image) {
      _imageFile = image;
      print(_imageFile);
    }).catchError((onError) {
      print(onError);
    });
  }

  void vewContract(
      BuildContext context,
      cti,
      address,
      name,
      theTotalArea,
      floor,
      money,
      cashTime,
      deposit,
      managementFee,
      fixed,
      summerElectricityMoney,
      electricityMoney,
      television,
      gasFee,
      internetFee,
      landlordAdd,
      landlordPhone,
      landlordMail,
      check,
      toMonth,
      toYear,
      tenantName,
      tenantID) {
    bool parkingSpace = false;
    bool thatPower = false;
    bool seizureOfRegistration = false;
    bool flatParking = false;
    bool mechanicalParkingSpace = false;
    bool allDay = false;
    bool dayTime = false;
    bool other = false;
    bool night = false;
    bool restore = false;
    bool renter = false;
    bool lessee = false;
    bool newsletter = false;
    bool app = true;
    bool mail = false;
    bool range = true;

    String nowDay = DateTime.now().day.toString();
    String nowYear = "${int.parse(DateTime.now().year.toString()) - 1911}";
    Future setContract() async {
      await Firestore.instance
          .collection('/房東/帳號資料/$loginUser/資料/擁有房間/${widget.houseName}/合約')
          .document('房間合約')
          .setData({
        '停車位': parkingSpace,
        '權力': thatPower,
        '樓層': floor,
        '查封登記': seizureOfRegistration,
        '平面停車位': flatParking,
        '立體停車位': mechanicalParkingSpace,
        '整天': allDay,
        '白天': dayTime,
        '其他': other,
        '晚上': night,
        '恢復原狀': restore,
        '承租人': renter,
        '出租人': lessee,
        '簡訊有效': newsletter,
        '通訊軟體有效': app,
        '信箱有效': mail,
        '租賃範圍': range,
        '現在年': nowYear,
        '現在月': nowMonth,
        '現在日': nowDay,
        '到期年': toYear,
        '到期月': toMonth,
        '到期日': nowDay,
        '每月租金': money,
        '繳款時間': widget.cashTime,
        '押金': widget.deposit,
        '押金金額': '${int.parse(widget.deposit) * int.parse(money)}',
        '管理費': widget.managementFee,
        '第四台': widget.television,
        '瓦斯費': widget.gasFee,
        '網路費': widget.internetFee,
        '開啟電費儲值': widget.fixed,
        '夏季電費': widget.summerElectricityMoney,
        '非夏季電費': widget.electricityMoney,
        '地址': widget.address,
        '城市': widget.cti,
        '面積': widget.theTotalArea,
        '簽約時長': newHouse.contractPeriodDate,
        '合約類型': '電子合約',
        '房東名稱': name,
        '房東地址': landlordAdd,
        '房東電話': landlordPhone,
        '房東信箱': landlordMail,
        '附屬設備': {
          '電視': widget.tv,
          '冰箱': widget.refrigerator,
          '洗衣機': widget.washingMachine,
          '有線網路': widget.wiredNetwork,
          '冷氣': widget.airConditioner,
          '熱水器': widget.waterHeater,
          '油煙機': widget.cookerHood,
          '電話': widget.phone,
          '微波爐': widget.microwaveOven,
          '洗碗機': widget.dishwasher,
          '瓦斯': widget.gas,
          '保全設備': widget.preservation,
          '電視櫃': widget.tvTable,
          '沙發': widget.sofa,
          '茶几': widget.coffeeTable,
          '餐桌': widget.diningTable,
          '鞋櫃': widget.shoeBox,
          '書櫃': widget.bookBox,
          '床頭組': widget.bedside,
          '衣櫃': widget.wardrobe,
          '梳妝台': widget.dressingTable,
          '書桌': widget.bookTable,
          '置物櫃': widget.locker,
          '流理台': widget.fluidTable,
          'wifi': widget.wifi,
          '烤箱': widget.oven,
          '指紋密碼鎖': widget.fingerprintPasswordLock,
          '瓦斯爐': widget.gasStove,
        }
      });
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text("住宅租賃契約書"),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Screenshot(
                    controller: screenshotController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                            "中華民國107年6月27日內政部內授中辦地字第1071304160號函立契約書人出租人 $name ，承租人$tenantName，茲為住宅租賃事宜，雙方同意本契約條款如下："),
                        Text(
                          "第一條 租賃標的",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('一.租賃住宅標示：\n'
                            '1.門牌 $cti$address '
                            '2.專有部分建號__  ，權利範圍 ，面積共計$theTotalArea 坪。\n'
                            '1.主建物面積： __層 __坪，__層 __坪， __層 __坪共計$theTotalArea坪，用途__ 。\n'
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
                                      value: parkingSpace,
                                      onChanged: (v) {
                                        setState(() {
                                          parkingSpace = v;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            Expanded(flex: 3, child: Text('（汽車停車位 個、機車停車位 個）')),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: Text('5.有')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: thatPower,
                                  onChanged: (v) {
                                    setState(() {
                                      thatPower = v;
                                    });
                                  }),
                            ),
                            Expanded(
                                flex: 5, child: Text('設定他項權利，若有，權利種類：___ 。')),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: Text('6.有')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: seizureOfRegistration,
                                  onChanged: (v) {
                                    setState(() {
                                      seizureOfRegistration = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 5, child: Text('查封登記。')),
                          ],
                        ),
                        Text('二.租賃範圍:'),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 4, child: Text('1.租賃住宅')),
                            Expanded(flex: 1, child: Text('全部')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: range,
                                  onChanged: (v) {
                                    setState(() {
                                      range = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 1, child: Text('部分')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: !range,
                                  onChanged: (v) {
                                    setState(() {
                                      range = !range;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        Text(
                            '第 $floor層 房間__間 第__室，面積 $theTotalArea坪(如「租賃住宅位置格局示意圖」標註之租賃範圍)。'),
                        Text('2.車位(如無則免填)：'),
                        Text('1.汽車停車位種類及編號：地上(下）第__層'),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 4, child: Text('平面式停車位')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: flatParking,
                                  onChanged: (v) {
                                    setState(() {
                                      flatParking = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 4, child: Text('機械式停車位')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: mechanicalParkingSpace,
                                  onChanged: (v) {
                                    setState(() {
                                      mechanicalParkingSpace = v;
                                    });
                                  }),
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
                                  value: allDay,
                                  onChanged: (v) {
                                    setState(() {
                                      allDay = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('日間')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: dayTime,
                                  onChanged: (v) {
                                    setState(() {
                                      dayTime = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('夜間')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: night,
                                  onChanged: (v) {
                                    setState(() {
                                      night = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('其他')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: other,
                                  onChanged: (v) {
                                    setState(() {
                                      other = v;
                                    });
                                  }),
                            )
                          ],
                        ),
                        Text(''),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 4, child: Text('3.租賃附屬設備：有')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: seizureOfRegistration,
                                  onChanged: (v) {
                                    setState(() {
                                      seizureOfRegistration = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('附屬設備')),
                          ],
                        ),
                        Text('附屬設備，若有，除另有附屬設備清單外，詳如後附租賃標的現況確認書（如附件一）。。'),
                        Text('4.其他：_____'),
                        Text(
                          '第二條 租賃期間',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '租賃期間自民國$nowYear年$nowMonth月$nowDay日起至民國$toYear年$toMonth月$nowDay日止。(租賃期間至少三十日以上)'),
                        Text(
                          '第三條 租金約定及支付',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '承租人每月租金為新臺幣$money元整，每期應繳納1個月租金，並於每月$cashTime日前支付，不得藉任何理由拖延或拒絕，出租人於租賃期間亦不得任意要求調整租金。'),
                        Text('租金支付方式：依據房東天堂規定之繳費方式繳費'),
                        Text(
                          '第四條 押金約定及返還',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '押金由租賃雙方約定為$deposit個月租金，金額為${int.parse(deposit) * int.parse(money)}元整(最高不得超過二個月租金之總額)。'
                            '承租人應於簽訂住宅租賃契約（以下簡稱本契約）之同時給付出租人。'
                            '前項押金，除有第十三條第三項、第十四條第四項及第十八條第二項之情形外，'
                            '出租人應於租期屆滿或租賃契約終止，承租人返還租賃住宅時'
                            '，返還押金或抵充本契約所生債務後之賸餘押金。'),
                        Text(
                          '第五條 租賃期間相關費用之支付',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('租賃期間，使用租賃住宅所生之相關費用如下：'),
                        Text(managementFee ? '一.管理費：包含至房租' : '一.管理費：由出租人負擔'),
                        Text(television ? '二.第四台：包含至房租' : '二.第四台：由出租人負擔'),
                        Text(gasFee ? '三.瓦斯費：包含至房租' : '三.瓦斯費：由出租人負擔'),
                        Text(internetFee ? '四.網路費：包含至房租' : '四.網路費：由出租人負擔'),
                        Text('五.水費：包含至房租'),
                        Text(fixed
                            ? '六.電費：夏季電費每度$summerElectricityMoney元,非夏季電費每度$electricityMoney元'
                            : '六.電費：包含至房租'),
                        Text('七.其他費用及其支付方式： 。'),
                        Text(
                          '第六條 稅費負擔之約定',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('本契約有關稅費、代辦費，依下列約定辦理:'),
                        Text('一.租賃住宅之房屋稅、地價稅由出租人負擔。'),
                        Text('二.出租人收取現金者，其銀錢收據應貼用之印花稅票由出租人負擔。'),
                        Text('三.簽約代辦費__元整。☐由出租人負擔。☐由承租人負擔。☐由租賃雙方平均負擔。其他：__'),
                        Text('四.公證費__元整。☐由出租人負擔。☐由承租人負擔。☐由租賃雙方平均負擔。其他：__'),
                        Text('五.公證代辦費__元整。☐由出租人負擔。☐由承租人負擔。☐由租賃雙方平均負擔。其他：__'),
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
                                  value: restore,
                                  onChanged: (v) {
                                    setState(() {
                                      restore = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('現況返還')),
                            Expanded(
                              flex: 2,
                              child: Checkbox(
                                  value: !restore,
                                  onChanged: (v) {
                                    setState(() {
                                      restore = !v;
                                    });
                                  }),
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
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 6, child: Text('本契約於期限屆滿前，出租人得')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: renter,
                                  onChanged: (v) {
                                    setState(() {
                                      renter = v;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 2, child: Text('承租人得')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: lessee,
                                  onChanged: (v) {
                                    setState(() {
                                      lessee = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 5, child: Text('終止租約。依約定得')),
                          ],
                        ),
                        Text('終止租約者，租賃之一方應於一個月'),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: Text('前')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: restore,
                                  onChanged: (v) {
                                    setState(() {
                                      restore = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 6, child: Text('通知他方。')),
                          ],
                        ),
                        Text('一方未為先期通知而逕行終止租約者，應賠償他方 1 個月(最高不得超過一個月)租金額之違約金。'
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
                        Text('出租人於租賃住宅交付後，承租人占有中，縱將其所有權讓與第三人，本契約對於受讓人仍繼續存在。'
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
                        Text('''租賃期間有下列情形之一，致難以繼續居住者，承租人得提前終止租約，出租人不得要求任何賠償：

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
                                  value: mail,
                                  onChanged: (v) {
                                    setState(() {
                                      mail = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('電子郵件。')),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: newsletter,
                                  onChanged: (v) {
                                    setState(() {
                                      newsletter = v;
                                    });
                                  }),
                            ),
                            Expanded(flex: 2, child: Text('簡訊。')),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                  value: app,
                                  onChanged: (v) {
                                    setState(() {
                                      app = v;
                                    });
                                  }),
                            ),
                            Expanded(
                                flex: 6, child: Text('通訊軟體(例如 房東天堂訊息文字顯示)。')),
                          ],
                        ),
                        Text(
                            '為之；如因不可歸責於雙方之事由，致通知無法到達時，以通知之一方提出他方確已知悉通知之日期推定為到達日。'),
                        Text(
                          '第二十條 其他約定',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('本契約租賃雙方 ☐ 同意 ☐ 不同意辦理公證。'),
                        Text('本契約經辦理公證者，租賃雙方 ☐ 同意 ☐ 不同意公證書載明下列事項應逕受強制執行：'),
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
                          loginUser: loginUser,
                          tenantEmail: tenantID,
                        ),
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
                        Text('附屬設備項目如下：'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.tv ? ' ☑ 電視' : " ☐ 電視"),
                            Text(widget.refrigerator ? ' ☑ 冰箱' : " ☐ 冰箱"),
                            Text(widget.washingMachine ? ' ☑ 洗衣機' : " ☐ 洗衣機"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.airConditioner ? ' ☑ 冷氣' : " ☐ 冷氣"),
                            Text(widget.oven ? ' ☑ 烤箱' : " ☐ 烤箱"),
                            Text(widget.waterHeater ? ' ☑ 熱水器' : " ☐ 熱水器"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.wifi ? ' ☑ WIFI' : " ☐ WIFI"),
                            Text(widget.phone ? ' ☑ 電話' : " ☐ 電話"),
                            Text(widget.microwaveOven ? ' ☑ 微波爐' : " ☐ 微波爐"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.tvTable ? ' ☑ 電視櫃' : " ☐ 電視櫃"),
                            Text(widget.wiredNetwork ? ' ☑ 有線網路' : " ☐ 有線網路"),
                            Text(widget.fingerprintPasswordLock
                                ? ' ☑ 指紋密碼鎖'
                                : " ☐ 指紋密碼鎖"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.dishwasher ? ' ☑ 洗碗機' : " ☐ 洗碗機"),
                            Text(widget.gas ? ' ☑ 天然瓦斯' : " ☐ 天然瓦斯"),
                            Text(widget.preservation ? ' ☑ 保全設施' : " ☐ 保全設施"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.shoeBox ? ' ☑ 鞋櫃' : " ☐ 鞋櫃"),
                            Text(widget.cookerHood ? ' ☑ 排油煙機' : " ☐ 排油煙機"),
                            Text(widget.dressingTable ? ' ☑ 梳妝台' : " ☐ 梳妝台"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.wardrobe ? ' ☑ 衣櫃' : " ☐ 衣櫃"),
                            Text(widget.bookBox ? ' ☑ 書櫃' : " ☐ 書櫃"),
                            Text(widget.bedside ? ' ☑ 床組(頭)' : " ☐ 床組(頭)"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.sofa ? ' ☑ 沙發' : " ☐ 沙發"),
                            Text(widget.coffeeTable ? ' ☑ 茶几' : " ☐ 茶几"),
                            Text(widget.diningTable ? ' ☑ 餐桌(椅)' : " ☐ 餐桌(椅)"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.bookTable ? ' ☑ 書桌椅' : " ☐ 書桌椅"),
                            Text(widget.locker ? ' ☑ 置物櫃' : " ☐ 置物櫃"),
                            Text(widget.fluidTable ? ' ☑ 流理台' : " ☐ 流理台"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.gasStove ? ' ☑ 瓦斯爐' : " ☐ 瓦斯爐"),
                          ],
                        ),
                        Text(
                            '出租人：$name(簽章)\n承租人： (簽章)\n簽章日期：${DateTime.now().year - 1911} 年${DateTime.now().month} 月${DateTime.now().day} 日'),
                        check
                            ? Container()
                            : StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection('/房東/帳號資料/$loginUser/資料/合約')
                                    .document('${widget.houseName}簽名')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  final data = snapshot.data.data;
                                  print(data);
                                  return data == null
                                      ? FlatButton(
                                          color:
                                              AppConstants.appBarAndFontColor,
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignApp(
                                                          loginUser: loginUser,
                                                          roomName:
                                                              widget.houseName,
                                                        )));
                                          },
                                          child: Text(
                                            '確認無誤並簽名',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                      : Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                FlatButton(
                                                    color: AppConstants
                                                        .appBarAndFontColor,
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SignApp(
                                                                        loginUser:
                                                                            loginUser,
                                                                        roomName:
                                                                            widget.houseName,
                                                                      )));
                                                    },
                                                    child: Text(
                                                      '確認無誤並簽名',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                FlatButton(
                                                    color: AppConstants
                                                        .appBarAndFontColor,
                                                    onPressed:
                                                        data['${widget.houseName}簽名'] ==
                                                                    null ||
                                                                data['${widget.houseName}簽名'] ==
                                                                    ''
                                                            ? null
                                                            : () async {
                                                                Navigator.pop(
                                                                    context);
                                                                newTenant(
                                                                    context);
                                                                await getPicture();
                                                                await saveImages();
                                                                await setContract();
                                                                await saveMessageData();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                    child: Text(
                                                      '送出',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ],
                                            ),
                                            data['${widget.houseName}簽名'] ==
                                                        null ||
                                                    data['${widget.houseName}簽名'] ==
                                                        ""
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 100,
                                                        height: 250,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text('房客簽名'),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        height: 250,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text('房東簽名'),
                                                            Image.network(data[
                                                                '${widget.houseName}簽名']),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        );
                                }),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  void viewContract(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('合約內容'),
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
                    child: Column(
                  children: <Widget>[
                    Text(
                      '房屋租賃契約書',
                      style: TextStyle(
                          color: AppConstants.appBarAndFontColor,
                          fontSize: Adapt.px(40)),
                    ),
                    Text(
                      '''中華民國91年1月30日內政部台內中地字第0910083141號公告頒行
                        (行政院消費者保護委員會第86次委員會議通過)\n
                        中華民國105年6月23日內政部內授中辦地字第1051305386號公告修正 
                        (行政院消費者保護會第47次會議通過)\n契約審閱權\n
                        本契約於中華民國__年__月__日經承租人攜回審閱__日（契約審閱期間至少三日）
                        \n承租人簽章：\n出租人簽章：''',
                      style: TextStyle(fontSize: Adapt.px(25)),
                    ),
                    Text(
                      '房屋租賃契約書',
                      style: TextStyle(
                          color: AppConstants.appBarAndFontColor,
                          fontSize: Adapt.px(40)),
                    ),
                    Text('''
                        立契約書人承租人    ，出租人    【為□所有權人□轉租人(應提示經原所有權人同意轉租之證明文件)】茲為房屋租賃事宜，雙方同意本契約條款如下：

第一條 房屋租賃標的

 一、房屋標示：

(一)門牌__縣(市)__鄉（鎮、市、區）__街（路）__段__巷__弄__號__樓(基地坐落__段__小段__地號。)。

(二)專有部分建號__，權利範圍   ，面積共計  平方公尺。

 1.主建物面積：

__層__平方公尺，__層__平方公尺，__層__平方公尺共 計__平方公尺，用途__。

 2.附屬建物用途__，面積__平方公尺。

(三)共有部分建號   ，權利範圍   ，持分面積  平方公尺。

(四)□有□無設定他項權利，若有，權利種類：   。

(五)□有□無查封登記。

二、租賃範圍：

(一)房屋□全部□部分：第__層□房間   間□第  室，面積__平方公尺(如「房屋位置格局示意圖」標註之租賃範圍)。

(二)車位：

1.車位種類及編號：

地上(下）第__層□平面式停車位□機械式停車位，編號第__號車位＿個。

2.使用時間：

□全日□日間□夜間□其他___。(如無則免填)

(三)租賃附屬設備：

□有□無附屬設備，若有，除另有附屬設備清單外，詳如後附房屋租賃標的現況確認書。

(四)其他：   。

第二條 租賃期間

    租賃期間自民國  年  月  日起至民國  年  月  日止。

第三條 租金約定及支付

   承租人每月租金為新臺幣(下同)   元整，每期應繳納   個月租金，並於每□月□期  日前支付，不得藉任何理由拖延或拒絕；出租人亦不得任意要求調整租金。

租金支付方式：□現金繳付□轉帳繳付：金融機構：____，戶名：____，帳號：____。□其他：____。

第四條 擔保金（押金）約定及返還

擔保金（押金）由租賃雙方約定為___個月租金，金額為   元整(最高不得超過二個月房屋租金之總額)。承租人應於簽訂本契約之同時給付出租人。

   前項擔保金（押金），除有第十一條第三項、第十二條第四項及第十六條第二項之情形外，出租人應於租期屆滿或租賃契約終止，承租人交還房屋時返還之。

第五條 租賃期間相關費用之支付

租賃期間，使用房屋所生之相關費用：

一、管理費：

 □由出租人負擔。

 □由承租人負擔。

房屋每月    元整。

停車位每月   元整。

租賃期間因不可歸責於雙方當事人之事由，致本費用增加者，承租人就增加部分之金額，以負擔百分之十為限；如本費用減少者，承租人負擔減少後之金額。

□其他：      。

二、水費：

□由出租人負擔。

□由承租人負擔。

□其他：______。(例如每度  元整)

三、電費：

□由出租人負擔。

□由承租人負擔。

□其他：______。(例如每度  元整)

四、瓦斯費：

□由出租人負擔。

□由承租人負擔。

□其他：______。

五、其他費用及其支付方式：______。

第六條 稅費負擔之約定

本租賃契約有關稅費、代辦費，依下列約定辦理：

一、房屋稅、地價稅由出租人負擔。

二、銀錢收據之印花稅由出租人負擔。

三、簽約代辦費     元

□由出租人負擔。

□由承租人負擔。

□由租賃雙方平均負擔。

□其他：     。

四、公證費      元

□由出租人負擔。

□由承租人負擔。

□由租賃雙方平均負擔。

□其他：     。

五、公證代辦費      元

□由出租人負擔。

□由承租人負擔。

□由租賃雙方平均負擔。

□其他：     。

六、其他稅費及其支付方式：______。

第七條 使用房屋之限制

本房屋係供住宅使用。非經出租人同意，不得變更用途。

承租人同意遵守住戶規約，不得違法使用，或存放有爆炸性或易燃性物品，影響公共安全。

出租人□同意□不同意將本房屋之全部或一部分轉租、出借或 以其他方式供他人使用，或將租賃權轉讓於他人。

前項出租人同意轉租者，承租人應提示出租人同意轉租之證明文件。

第八條 修繕及改裝

房屋或附屬設備損壞而有修繕之必要時，應由出租人負責修繕。但租賃雙方另有約定、習慣或可歸責於承租人之事由者，不在此限。

前項由出租人負責修繕者，如出租人未於承租人所定相當期限內修繕時，承租人得自行修繕並請求出租人償還其費用或於第三條約定之租金中扣除。

房屋有改裝設施之必要，承租人應經出租人同意，始得依相關法令自行裝設，但不得損害原有建築之結構安全。

前項情形承租人返還房屋時，□應負責回復原狀□現況返還□其他_____。

第九條 承租人之責任

    承租人應以善良管理人之注意保管房屋，如違反此項義務，致房屋毀損或滅失者，應負損害賠償責任。但依約定之方法或依房屋之性質使用、收益，致房屋有毀損或滅失者，不在此限。

第十條 房屋部分滅失

    租賃關係存續中，因不可歸責於承租人之事由，致房屋之一部滅失者，承租人得按滅失之部分，請求減少租金。

第十一條 提前終止租約

本契約於期限屆滿前，租賃雙方□得□不得終止租約。

依約定得終止租約者，租賃之一方應於□一個月前□  個月前通知他方。一方未為先期通知而逕行終止租約者，應賠償他方___個月(最高不得超過一個月)租金額之違約金。

前項承租人應賠償之違約金得由第四條之擔保金(押金)中扣抵。

租期屆滿前，依第二項終止租約者，出租人已預收之租金應返還予承租人。

第十二條 房屋之返還

 租期屆滿或租賃契約終止時，承租人應即將房屋返還出租人並遷出戶籍或其他登記。

前項房屋之返還，應由租賃雙方共同完成屋況及設備之點交手續。租賃之一方未會同點交，經他方定相當期限催告仍不會同者，視為完成點交。

承租人未依第一項約定返還房屋時，出租人得向承租人請求未返還房屋期間之相當月租金額外，並得請求相當月租金額一倍(未足一個月者，以日租金折算)之違約金至返還為止。

    前項金額及承租人未繳清之相關費用，出租人得由第四條之擔保金(押金)中扣抵。

第十三條 房屋所有權之讓與

出租人於房屋交付後，承租人占有中，縱將其所有權讓與第三人，本契約對於受讓人仍繼續存在。

前項情形，出租人應移交擔保金（押金）及已預收之租金與受讓人，並以書面通知承租人。

本契約如未經公證，其期限逾五年或未定期限者，不適用前二項之約定。

第十四條 出租人終止租約

  承租人有下列情形之一者，出租人得終止租約：

一、遲付租金之總額達二個月之金額，並經出租人定相當期限催告，承租人仍不為支付。

二、違反第七條規定而為使用。

三、違反第八條第三項規定而為使用。

四、積欠管理費或其他應負擔之費用達相當二個月之租金額，經出租人定相當期限催告，承租人仍不為支付。

第十五條 承租人終止租約

出租人有下列情形之一者，承租人得終止租約：

一、房屋損害而有修繕之必要時，其應由出租人負責修繕者，經承租人定相當期限催告，仍未修繕完畢。

二、有第十條規定之情形，減少租金無法議定，或房屋存餘部分不能達租賃之目的。

三、房屋有危及承租人或其同居人之安全或健康之瑕疵時。

第十六條 遺留物之處理

租期屆滿或租賃契約終止後，承租人之遺留物依下列方式處理：

一、承租人返還房屋時，任由出租人處理。

二、承租人未返還房屋時，經出租人定相當期限催告搬離仍不搬離時，視為廢棄物任由出租人處理。

 前項遺留物處理所需費用，由擔保金(押金)先行扣抵，如有不足，出租人得向承租人請求給付不足之費用。

第十七條 通知送達及寄送

    除本契約另有約定外，出租人與承租人雙方相互間之通知，以郵寄為之者，應以本契約所記載之地址為準；並得以□電子郵件□簡訊□其他__方式為之(無約定通知方式者，應以郵寄為之)；如因地址變更未通知他方或因__，致通知無法到達時（包括拒收），以他方第一次郵遞或通知之日期推定為到達日。

第十八條 疑義處理

    本契約各條款如有疑義時，應為有利於承租人之解釋。

第十九條 其他約定

    本契約雙方同意□辦理公證□不辦理公證。

本契約經辦理公證者，租賃雙方□不同意；□同意公證書載明下列事項應逕受強制執行：

□一、承租人如於租期屆滿後不返還房屋。

□二、承租人未依約給付之欠繳租金、出租人代繳之管理費，或違約時應支付之金額。

□三、出租人如於租期屆滿或租賃契約終止時，應返還之全部或一部擔保金（押金）。

公證書載明金錢債務逕受強制執行時，如有保證人者，前項後段第__款之效力及於保證人。

第二十條 爭議處理

因本契約發生之爭議，雙方得依下列方式處理：

一、向房屋所在地之直轄市、縣（市）不動產糾紛調處委員會申請調處。

二、向直轄市、縣（市）消費爭議調解委員會申請調解。

三、向鄉鎮市(區)調解委員會申請調解。

四、向房屋所在地之法院聲請調解或進行訴訟。

第二十一條 契約及其相關附件效力

    本契約自簽約日起生效，雙方各執一份契約正本。

    本契約廣告及相關附件視為本契約之一部分。

    本契約所定之權利義務對雙方之繼受人均有效力。

第二十二條 未盡事宜之處置

    本契約如有未盡事宜，依有關法令、習慣、平等互惠及誠實信用原則公平解決之。

附件

□建物所有權狀影本

□使用執照影本

□雙方身分證影本

□保證人身分證影本

□授權代理人簽約同意書

□房屋租賃標的現況確認書

□附屬設備清單

□房屋位置格局示意圖

□其他（測量成果圖、室內空間現狀照片）

立契約書人

出租人：

姓名(名稱)：　　　　簽章

統一編號：

戶籍地址：

通訊地址：

聯絡電話：

負責人：         （簽章）

統一編號：

電子郵件信箱：

承租人：

姓名(名稱)：　　　　簽章

統一編號：

戶籍地址：

通訊地址：

聯絡電話：

電子郵件信箱：

保證人：

姓名(名稱)：　　　（簽章）

統一編號：

戶籍地址：

通訊地址：

聯絡電話：

電子郵件信箱：

不動產經紀業：

名稱（公司或商號）：

地址：

電話：

統一編號：

負責人：　　　　（簽章）

統一編號：

電子郵件信箱：

不動產經紀人：

姓名：　　　　 　（簽章）

統一編號：

通訊地址：

聯絡電話：

證書字號：

電子郵件信箱：

中華民國           年          月            日
                      ''')
                  ],
                )),
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

  void contract(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '點擊更改合約模式',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  eleCont = !eleCont;
                  print(eleCont);
                  if (eleCont) {
                    electronicContract = '現在為(電子合約)';
                  } else {
                    electronicContract = '現在為(傳統合約)';
                  }
                });
                Navigator.pop(context);
              },
              child: Text('$electronicContract'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                viewContract(context);
              },
              child: Text('查看合約樣板'),
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

  var name;
  var landlordAdd;
  var landlordPhone;
  var landlordMail;

  Future getName() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }

    await Firestore.instance
        .collection('/房東/帳號資料/$loginUser')
        .document('資料')
        .snapshots()
        .forEach((element) {
      name = element['name'];
      landlordAdd = element['地址'];
      landlordPhone = element['手機號碼'];
      landlordMail = element['帳號'];
      print(name);
    });
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
                widget.noHasGatewayFixd
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
                    regExp: widget.noHasGatewayFixd ? '0-5' : '0-9',
                    maxInt: widget.noHasGatewayFixd ? 1 : 4,
//                onEditingComplete:
//                maxElectricityMoney,
                    labelText: widget.noHasGatewayFixd ? '每度' : '每月',
                    hintText: widget.noHasGatewayFixd ? '５' : '４００',
                    controller: electricityMoneyController,
                    width: 1,
                  ),
                ),
                widget.noHasGatewayFixd
                    ? Text(
                        '夏季電費儲值每度',
                        style: TextStyle(fontSize: 13),
                      )
                    : Text(
                        '夏季每月電費',
                        style: TextStyle(fontSize: 13),
                      ),
                Container(
                  height: 60,
                  child: NewHouseTextFiledKBTypeNum(
                    regExp: widget.noHasGatewayFixd ? '0-6' : '0-9',
                    maxInt: widget.noHasGatewayFixd ? 1 : 4,
                    labelText: widget.noHasGatewayFixd ? '每度' : '每月',
                    hintText: widget.noHasGatewayFixd ? '５' : '４００',
                    controller: summerElectricityMoneyController,
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
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            StatefulBuilder(builder: (context, StateSetter setState) {
              return FlatButton(
                  onPressed: () async {
                    wait(context, '資料加密傳輸中..請稍後', '請勿關閉視窗');
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

  bool eleCont = false;
  String electronicContract = '現在為(傳統合約)';

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
                contract(context);
              },
              child: Text('合約相關'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                smartFacilities(context);
              },
              child: Text('智慧設施'),
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

  void smartFacilities(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '智慧設施',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                doorLock(context);
              },
              child: Text('門鎖相關'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                gatewaySettings(context);
              },
              child: Text('智慧電表'),
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
                summerElectricityMoneyController = TextEditingController();
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
                    eleCont
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '簽約時長',
                              style: TextStyle(
                                  fontSize: Adapt.px(30),
                                  color: AppConstants.appBarAndFontColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    eleCont
                        ? Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: '合約時長',
                                      ),
                                      // isEmpty: _group['color'] == Colors.black,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: newHouse.data['合約時長'],
                                          isDense: true,
                                          onChanged: (newValue) {
                                            setState(() {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              newHouse.data['合約時長'] = newValue;
                                              newHouse.contractPeriodDate =
                                                  newValue;
                                              print(
                                                  newHouse.contractPeriodDate);
                                              if (int.parse(newHouse
                                                      .contractPeriodDate) ==
                                                  1) {
                                                toMonth =
                                                    "${int.parse(toMonth) + 1}";
                                                int.parse(toMonth) > 12
                                                    ? toMonth =
                                                        "${int.parse(toMonth) - 12}"
                                                    : null;
                                                int.parse(toMonth) > 12
                                                    ? toYear =
                                                        "${int.parse(toYear) + 1}"
                                                    : null;

                                                print(toYear);
                                                print(toMonth);
                                              } else if (int.parse(newHouse
                                                      .contractPeriodDate) ==
                                                  3) {
                                                toMonth =
                                                    "${int.parse(toMonth) + 3}";
                                                int.parse(toMonth) > 12
                                                    ? nowYear =
                                                        "${int.parse(toYear) + 1}"
                                                    : null;
                                                int.parse(toMonth) > 12
                                                    ? toMonth =
                                                        "${int.parse(toMonth) - 12}"
                                                    : null;
                                                print(toYear);
                                                print(toMonth);
                                              } else if (int.parse(newHouse
                                                      .contractPeriodDate) ==
                                                  6) {
                                                toMonth =
                                                    "${int.parse(toMonth) + 6}";
                                                int.parse(toMonth) > 12
                                                    ? toYear =
                                                        "${int.parse(toYear) + 1}"
                                                    : null;
                                                int.parse(toMonth) > 12
                                                    ? toMonth =
                                                        "${int.parse(toMonth) - 12}"
                                                    : null;
                                                print(toYear);
                                                print(toMonth);
                                              } else if (int.parse(newHouse
                                                      .contractPeriodDate) ==
                                                  12) {
                                                toYear =
                                                    "${int.parse(toYear.toString()) + 1}";
                                                print(toYear);
                                                print(toMonth);
                                              }
                                            });
                                          },
                                          items: newHouse.contractPeriod
                                              .map((dynamic color) {
                                            return DropdownMenuItem(
                                              value: color['合約時長'],
                                              child: Text(color['合約時長']),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    )),
                              ),
                              Text(
                                '個月',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Adapt.px(30),
                                    color: AppConstants.appBarAndFontColor),
                              ),
                            ],
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: OutlineButton(
                            onPressed: s
                                ? null
                                : () async {
                                    eleCont
                                        ? await checkTenant()
                                        : await saveData();
                                    setState(() {
                                      s = true;
                                    });
                                    setState(() {
                                      ok = '請勿關閉視窗...';
                                    });
//                                    Navigator.pop(context);
//

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
            getName();
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
                          summerElectricityMoney: widget.summerElectricityMoney,
                          address: widget.address,
                          fixed: widget.fixed,
                          noHasGatewayFixd: widget.noHasGatewayFixd,
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
                            nowMonth == '6' ||
                                    nowMonth == '7' ||
                                    nowMonth == '8' ||
                                    nowMonth == '9'
                                ? widget.noHasGatewayFixd
                                    ? "電費${widget.summerElectricityMoney}/度"
                                    : "電費${widget.summerElectricityMoney}/月"
                                : widget.noHasGatewayFixd
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

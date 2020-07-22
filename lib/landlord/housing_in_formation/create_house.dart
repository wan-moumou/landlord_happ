import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/app_const/newHouseWidgets.dart';
import 'package:landlord_happy/app_const/new_house.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'preview.dart';

class CreateHouse extends StatefulWidget {
  @override
  _CreateHouseState createState() => _CreateHouseState();
}

class _CreateHouseState extends State<CreateHouse> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  String loginUser;
  int _position = 0;
  NewHouse newHouseData = NewHouse();
  Furniture furniture = Furniture();
  TextEditingController addressController;
  TextEditingController otherFacilities;
  TextEditingController floorController; //樓層
  TextEditingController allFloorController; //全部樓層樓層
  TextEditingController areaController; //房屋面積
  TextEditingController bedroomsNumController; //臥室數量
  TextEditingController bedNumController; //床數
  TextEditingController livingRoomController; //客廳
  TextEditingController houseNameController;
  TextEditingController houseMoneyController; //房租
  TextEditingController cashTimeController; //繳費時間
  TextEditingController electricityMoneyController; //電費
  TextEditingController waterMoneyController; //水費
  TextEditingController housingIntroductionController; //水費
  TextEditingController depositController; //押金
  bool inAsyncCall = false;
  File _imageFromGallery;
  File _imageFromGallery1;
  var check = Icons.clear;
  var check1 = Icons.clear;
  String url1 = '';
  String url = '';
  int electricityMoneyStored = 0;
  bool cashTime = true;
  bool floor = true;
  bool waterMoney = true;
  bool electricityMoney = true;
  bool bedroomsNum = true;
  bool bedNum = true;

  @override
  void initState() {
    houseMoneyController = TextEditingController();
    otherFacilities = TextEditingController();
    cashTimeController = TextEditingController();
    electricityMoneyController = TextEditingController();
    waterMoneyController = TextEditingController();
    addressController = TextEditingController();
    floorController = TextEditingController();
    allFloorController = TextEditingController();
    areaController = TextEditingController();
    bedroomsNumController = TextEditingController();
    bedNumController = TextEditingController();
    livingRoomController = TextEditingController();
    houseNameController = TextEditingController();
    housingIntroductionController = TextEditingController();
    depositController = TextEditingController();
    electricityMoneyController.text = "0";
    super.initState();
  }

  void showBottomSheet(String text) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * .1,
            child: Text(
              '$text 超過限制!\n請確認!',
              style: TextStyle(
                  fontSize: Adapt.px(50),
                  color: AppConstants.appBarAndFontColor),
            ),
          );
        });
  }

  void maxCashTime() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (num.parse(cashTimeController.text) > 29) {
      cashTimeController.text = 29.toString();

      cashTime = false;
      showBottomSheet('繳費時間');
    } else {
      cashTime = true;
    }
  }

  void maxFloor() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (num.parse(floorController.text) > num.parse(allFloorController.text)) {
      floorController.text = allFloorController.text;

      floor = false;
      showBottomSheet('樓層數');
    } else {
      floor = true;
    }
  }

  void maxWaterMoney() {
    FocusScope.of(context).requestFocus(FocusNode());


      if (num.parse(waterMoneyController.text) > 999) {
        waterMoneyController.text = 999.toString();

        waterMoney = false;
        showBottomSheet('水費');
      } else {
        waterMoney = true;
    }
  }

  void maxElectricityMoney() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!newHouseData.fixed) {
      if (num.parse(electricityMoneyController.text) > 7) {
        electricityMoneyController.text = 7.toString();
        electricityMoney = false;
        showBottomSheet('電費');
      } else {
        electricityMoney = true;
      }
    } else {
      if (num.parse(electricityMoneyController.text) > 2000) {
        electricityMoneyController.text = 2000.toString();
        electricityMoney = false;
        showBottomSheet('電費');
      }
    }
  }

  void maxBedroomsNum() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (num.parse(bedroomsNumController.text) > 50) {
      bedroomsNumController.text = 50.toString();
      bedroomsNum = false;
      showBottomSheet('臥室數');
    } else {
      bedroomsNum = true;
    }
  }

  void maxBedNumController() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (num.parse(bedNumController.text) > 10) {
      bedNumController.text = 10.toString();
      bedNum = false;
      showBottomSheet('床數');
    } else {
      bedNum = true;
    }
  }

  @override
  void dispose() {
    print('頁面初始化中．．');
    super.dispose();
  }

  Future saveData() async {
    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      loginUser = currentUser.email;
      if (_imageFromGallery != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child(loginUser)
            .child('新建房間照片')
            .child(houseNameController.text)
            .child('照片1');
        await ref.putFile(_imageFromGallery).onComplete;

        url = await ref.getDownloadURL();
      }
      if (_imageFromGallery1 != null) {
        final ref1 = FirebaseStorage.instance
            .ref()
            .child(loginUser)
            .child('新建房間照片')
            .child(houseNameController.text)
            .child('封面照片');
        await ref1.putFile(_imageFromGallery1).onComplete;
        url1 = await ref1.getDownloadURL();
      }
      await _firestore
          .collection('房東')
          .document('新建房間')
          .collection(loginUser)
          .document(houseNameController.text)
          .setData({
        '照片位置': {
          '照片1': url,
          '照片2': url1,
        },
      });
    }
  }

  final _picker = ImagePicker();

  Future _getImageFromGallery() async {
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _imageFromGallery1 = File(pickedFile.path);
    });
  }

  Future _getImageFromGallery1() async {
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _imageFromGallery = File(pickedFile.path);
    });
  }

  void renew(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Text("填寫內容錯誤"),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    OutlineButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('確認'),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('創建新房間'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppConstants.appBarAndFontColor,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          child: SingleChildScrollView(
            child: Container(
              color: AppConstants.backColor,
              child: Card(
                margin: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '開始創建房間',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Stepper(
                          physics: ClampingScrollPhysics(),
                          type: StepperType.vertical,
                          //当前步骤下标
                          currentStep: _position,
                          //上一步
                          onStepTapped: (step) {
                            setState(() {
                              _position = step;
                            });
                          },
                          onStepContinue: () async {
                            setState(() {
                              if (_position <= 3) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _position++;
                              } else if (_position == 4) {
                                maxBedNumController();
                                maxCashTime();
                                maxBedroomsNum();
                                maxElectricityMoney();
                                maxWaterMoney();
                                maxFloor();
                                if (newHouseData.roomTypeValues == '請選擇' ||
                                    newHouseData.cityValues == '請選擇' ||
                                    newHouseData.houseTypeValues == '請選擇' ||
                                    newHouseData.roomTypeValues == null ||
                                    newHouseData.cityValues == null ||
                                    newHouseData.houseTypeValues == null ||
                                    cashTime == false ||
                                    floor == false ||
                                    waterMoney == false ||
                                    electricityMoney == false ||
                                    bedroomsNum == false ||
                                    bedNum == false) {
                                  renew(context);
                                } else {
                                  inAsyncCall = true;
                                  saveData();

                                  saveData().then((value) {
                                    if (furniture.preservation != null) {
                                      inAsyncCall = false;
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PersonalTenantInformation(
                                                    otherFacilities:
                                                        otherFacilities.text,
                                                    address:
                                                        addressController.text,
                                                    houseMoney:
                                                        houseMoneyController
                                                            .text,
                                                    managementFee: newHouseData
                                                        .managementFee,
                                                    gasFee: newHouseData.gasFee,
                                                    internetFee: newHouseData
                                                        .internetFee,
                                                    television:
                                                        newHouseData.television,
                                                    pet: newHouseData.petValues,
                                                    airConditioner: furniture
                                                        .airConditioner,
                                                    wifi: furniture.wifi,
                                                    refrigerator:
                                                        furniture.refrigerator,
                                                    phone: furniture.phone,
                                                    oven: furniture.oven,
                                                    washingMachine: furniture
                                                        .washingMachine,
                                                    waterHeater:
                                                        furniture.waterHeater,
                                                    dishwasher:
                                                        furniture.dishwasher,
                                                    microwaveOven:
                                                        furniture.microwaveOven,
                                                    cookerHood:
                                                        furniture.cookerHood,
                                                    wiredNetwork:
                                                        furniture.wiredNetwork,
                                                    gas: furniture.gas,
                                                    fingerprintPasswordLock:
                                                        furniture
                                                            .fingerprintPasswordLock,
                                                    preservation:
                                                        furniture.preservation,
                                                    tv: furniture.tv,
                                                    locker: furniture.locker,
                                                    fluidTable:
                                                        furniture.fluidTable,
                                                    dressingTable:
                                                        furniture.dressingTable,
                                                    bookTable:
                                                        furniture.bookTable,
                                                    gasStove:
                                                        furniture.gasStove,
                                                    bedside: furniture.bedside,
                                                    tvTable: furniture.tvTable,
                                                    sofa: furniture.sofa,
                                                    wardrobe:
                                                        furniture.wardrobe,
                                                    bookBox: furniture.bookBox,
                                                    shoeBox: furniture.shoeBox,
                                                    diningTable:
                                                        furniture.diningTable,
                                                    coffeeTable:
                                                        furniture.coffeeTable,
                                                    waterMoney:
                                                        waterMoneyController
                                                            .text,
                                                    electricityMoney: !newHouseData
                                                            .fixed
                                                        ? electricityMoneyStored
                                                            .toString()
                                                        : electricityMoneyController
                                                            .text,
                                                    cashTime:
                                                        cashTimeController.text,
                                                    party: newHouseData
                                                        .partyValues,
                                                    gender: newHouseData
                                                        .genderValues,
                                                    smoke: newHouseData
                                                        .smokeValues,
                                                    houseName:
                                                        houseNameController
                                                            .text,
                                                    cityValues:
                                                        newHouseData.cityValues,
                                                    houseTypeValues:
                                                        newHouseData
                                                            .houseTypeValues,
                                                    housingIntroduction:
                                                        housingIntroductionController
                                                            .text,
                                                    waterStored: newHouseData
                                                        .waterStoredValue,
                                                    fixed: newHouseData.fixed,
                                                    url: url,
                                                    allFloor:
                                                        allFloorController.text,
                                                    storedValue: newHouseData
                                                        .storedValue,
                                                    url1: url1,
                                                    haveBalcony: newHouseData
                                                        .haveBalcony,
                                                    haveKitchen: newHouseData
                                                        .haveKitchen,
                                                    bathroomType: newHouseData
                                                        .bathroomType,
                                                    area: areaController.text,
                                                    houseIsWhoValues:
                                                        newHouseData
                                                            .houseIsWhoValues,
                                                    floor: floorController.text,
                                                    roomTypeValues: newHouseData
                                                        .roomTypeValues,
                                                    bedroomsNum:
                                                        bedroomsNumController
                                                            .text,
                                                    deposit:
                                                        depositController.text,
                                                    bedNum:
                                                        bedroomsNumController
                                                            .text,
                                                    haveLivingRoom: newHouseData
                                                        .haveLivingRoom,
                                                  )));
                                    }
                                  });
                                }
                              }
                            });
                          },
                          onStepCancel: () {
                            setState(() {
                              if (_position == 0) {
                                Navigator.pop(context);
                              } else if (_position > 0) {
                                _position--;
                              }
                            });
                          },
                          controlsBuilder: (context,
                              {VoidCallback onStepContinue,
                              VoidCallback onStepCancel}) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: RaisedButton(
                                        onPressed: onStepCancel,
                                        color: AppConstants.appBarAndFontColor,
                                        child: Text(
                                          '上一步',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Expanded(flex: 1, child: SizedBox()),
                                    Expanded(
                                      flex: 2,
                                      child: RaisedButton(
                                        onPressed: onStepContinue,
                                        color: AppConstants.appBarAndFontColor,
                                        child: Text(
                                          '下一步',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          steps: <Step>[
                            //步驟
                            Step(
                              isActive: _position >= 0 ? true : false,
                              state: _position == 0
                                  ? StepState.editing
                                  : StepState.indexed,
                              title: Text(
                                '填寫房間基本資訊',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '請按表單填寫信息',
                                style: TextStyle(fontSize: 16),
                              ),
                              content: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '房間位置與類型',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.threesixty),
                                            labelText: '建物型態',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['建物型態'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['建物型態'] =
                                                      newValue;
                                                  newHouseData.houseTypeValues =
                                                      newValue;
                                                });
                                                print(newHouseData
                                                    .roomTypeValues);
                                                print(newHouseData.cityValues);
                                                print(newHouseData
                                                    .houseTypeValues);
                                              },
                                              items: newHouseData.houseType
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['建物型態'],
                                                  child: Text(color['建物型態']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.loyalty),
                                            labelText: '房間類型',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['房間類型'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['房間類型'] =
                                                      newValue;
                                                  newHouseData.roomTypeValues =
                                                      newValue;
                                                  print(newHouseData
                                                      .roomTypeValues);
                                                  print(
                                                      newHouseData.cityValues);
                                                  print(newHouseData
                                                      .houseTypeValues);
                                                });
                                              },
                                              items: newHouseData.roomType
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['房間類型'],
                                                  child: Text(color['房間類型']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.scatter_plot),
                                            labelText: '縣市',
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['縣市'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['縣市'] =
                                                      newValue;
                                                  newHouseData.cityValues =
                                                      newValue;
                                                  print(newHouseData
                                                      .roomTypeValues);
                                                  print(
                                                      newHouseData.cityValues);
                                                  print(newHouseData
                                                      .houseTypeValues);
                                                });
                                              },
                                              items: newHouseData.city
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['縣市'],
                                                  child: Text(color['縣市']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  NewHouseTextFiled(
                                    labelText: '建物地址',
                                    hintText: 'ex.同德七街１０巷１０號３樓',
                                    controller: addressController,
                                    width: 0.65,
                                  ),
                                  Text(
                                    '樓層資訊',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  NewHouseTextFiledKBTypeNum(
                                    regExp: '0-9',
                                    labelText: '房間樓層',
                                    maxInt: 2,
                                    hintText: 'EX.３',
                                    controller: floorController,
                                    width: 0.3,
                                  ),
                                  NewHouseTextFiledKBTypeNum(
                                    regExp: '0-9',
                                    maxInt: 2,
                                    labelText: '建物樓層',
                                    hintText: 'ex.５',
                                    controller: allFloorController,
                                    width: 0.3,
                                  ),
                                  NewHouseTextFiledKBTypeNum(
                                    labelText: '房間面積',
                                    regExp: '0-9',
                                    maxInt: 3,
                                    hintText: 'ex.４０坪',
                                    controller: areaController,
                                    width: 0.65,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '房間格局',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.scatter_plot),
                                            labelText: '衛浴',
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['衛浴類型'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['衛浴類型'] =
                                                      newValue;
                                                  newHouseData.bathroomType =
                                                      newValue;
                                                });
                                              },
                                              items: newHouseData.bathroom
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['衛浴類型'],
                                                  child: Text(color['衛浴類型']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.scatter_plot),
                                            labelText: '有無客廳',
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['客廳'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['客廳'] =
                                                      newValue;
                                                  newHouseData.haveLivingRoom =
                                                      newValue;
                                                  print(newHouseData
                                                      .haveLivingRoom);
                                                });
                                              },
                                              items: newHouseData.livingRoom
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['客廳'],
                                                  child: Text(color['客廳']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.scatter_plot),
                                            labelText: '有無廚房',
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['廚房'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['廚房'] =
                                                      newValue;
                                                  newHouseData.haveKitchen =
                                                      newValue;
                                                });
                                              },
                                              items: newHouseData.kitchen
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['廚房'],
                                                  child: Text(color['廚房']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.scatter_plot),
                                            labelText: '有無陽台',
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['陽台'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['陽台'] =
                                                      newValue;
                                                  newHouseData.haveBalcony =
                                                      newValue;
                                                });
                                              },
                                              items: newHouseData.balcony
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['陽台'],
                                                  child: Text(color['陽台']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  NewHouseTextFiledKBTypeNum(
                                    regExp: '0-9',
                                    maxInt: 2,
                                    onEditingComplete: maxBedroomsNum,
                                    labelText: '臥室數',
                                    hintText: 'ex.1',
                                    controller: bedroomsNumController,
                                    width: 0.3,
                                  ),
                                  NewHouseTextFiledKBTypeNum(
                                    regExp: '0-9',
                                    maxInt: 2,
                                    onEditingComplete: maxBedNumController,
                                    labelText: '床數',
                                    hintText: 'ex.1',
                                    controller: bedNumController,
                                    width: 0.3,
                                  ),
                                  Text(
                                    '您與房源關係為何?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.home),
                                            labelText: '房源',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['房源'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['房源'] =
                                                      newValue;
                                                  newHouseData
                                                          .houseIsWhoValues =
                                                      newValue;
                                                  print(newHouseData
                                                      .houseIsWhoValues);
                                                  print(newHouseData
                                                      .roomTypeValues);
                                                });
                                              },
                                              items: newHouseData.houseIsHwo
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['房源'],
                                                  child: Text(color['房源']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              isActive: _position >= 1 ? true : false,
                              state: _position == 1
                                  ? StepState.editing
                                  : StepState.indexed,
                              title: Text(
                                '編輯房屋介紹',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '幫房屋取個名子吧!',
                                style: TextStyle(fontSize: 16),
                              ),
                              content: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      controller: houseNameController,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          /*边角*/
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        labelText: '名稱',
                                        hintText: 'ex.帝寶',
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
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                      ],
                                      controller: housingIntroductionController,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          /*边角*/
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        labelText: '簡介',
                                        hintText: 'ex.這是一間超棒的房子!',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  OutlineButton(
                                      onPressed: () {
                                        _getImageFromGallery1();
                                        setState(() {
                                          check = Icons.check;
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(check),
                                          Text('點我新增：封面照片'),
                                        ],
                                      )),
                                  OutlineButton(
                                      onPressed: () {
                                        setState(() {
                                          _getImageFromGallery();
                                          check1 = Icons.check;
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(check1),
                                          Text('點我新增：臥室/衛浴'),
                                        ],
                                      )),
                                  Text('上傳臥室,衛浴照片能讓房客更了解您的房源\n(每張照片須為5MB以下)'),
                                ],
                              ),
                            ),
                            Step(
                              isActive: _position >= 2 ? true : false,
                              state: _position == 2
                                  ? StepState.editing
                                  : StepState.indexed,
                              title: Text(
                                '填寫家具與設備',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '房間內提供那些家具?',
                                style: TextStyle(fontSize: 16),
                              ),
                              content: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '您的房源包含哪些家具?',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.grey[400],
                                            width: 1.0)),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: ListView(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: CheckboxListTile(
                                            value: furniture.coffeeTable,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.coffeeTable = v;
                                                print(furniture.coffeeTable);
                                              });
                                            },
                                            title: Text('茶几'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.diningTable,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.diningTable = v;
                                                print(furniture.diningTable);
                                              });
                                            },
                                            title: Text('餐桌'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.shoeBox,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.shoeBox = v;
                                                print(furniture.shoeBox);
                                              });
                                            },
                                            title: Text('鞋櫃'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.bookBox,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.bookBox = v;
                                                print(furniture.bookBox);
                                              });
                                            },
                                            title: Text('書櫃'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.wardrobe,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.wardrobe = v;
                                                print(furniture.wardrobe);
                                              });
                                            },
                                            title: Text('衣櫃'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.sofa,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.sofa = v;
                                                print(furniture.sofa);
                                              });
                                            },
                                            title: Text('沙發'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.tvTable,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.tvTable = v;
                                                print(furniture.tvTable);
                                              });
                                            },
                                            title: Text('電視櫃'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.bedside,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.bedside = v;
                                                print(furniture.bedside);
                                              });
                                            },
                                            title: Text('床頭組'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.gasStove,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.gasStove = v;
                                                print(furniture.gasStove);
                                              });
                                            },
                                            title: Text('瓦斯爐'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.bookTable,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.bookTable = v;
                                                print(furniture.bookTable);
                                              });
                                            },
                                            title: Text('書桌椅'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.dressingTable,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.dressingTable = v;
                                                print(furniture.dressingTable);
                                              });
                                            },
                                            title: Text('梳妝台'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.fluidTable,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.fluidTable = v;
                                                print(furniture.fluidTable);
                                              });
                                            },
                                            title: Text('流理臺'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.locker,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.locker = v;
                                                print(furniture.locker);
                                              });
                                            },
                                            title: Text('置物櫃'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('您的房源包含哪些設備?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.grey[400],
                                            width: 1.0)),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: ListView(
                                      children: <Widget>[
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.tv,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.tv = v;
                                                print(furniture.tv);
                                              });
                                            },
                                            title: Text('電視'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.airConditioner,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.airConditioner = v;
                                                print(furniture.airConditioner);
                                              });
                                            },
                                            title: Text('冷氣'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.wifi,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.wifi = v;
                                                print(furniture.wifi);
                                              });
                                            },
                                            title: Text('WIFI'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.refrigerator,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.refrigerator = v;
                                                print(furniture.refrigerator);
                                              });
                                            },
                                            title: Text('冰箱'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.phone,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.phone = v;
                                                print(furniture.phone);
                                              });
                                            },
                                            title: Text('電話'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.oven,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.oven = v;
                                                print(furniture.oven);
                                              });
                                            },
                                            title: Text('烤箱'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.washingMachine,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.washingMachine = v;
                                                print(furniture.washingMachine);
                                              });
                                            },
                                            title: Text('洗衣機'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.waterHeater,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.waterHeater = v;
                                                print(furniture.waterHeater);
                                              });
                                            },
                                            title: Text('熱水器'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.dishwasher,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.dishwasher = v;
                                                print(furniture.dishwasher);
                                              });
                                            },
                                            title: Text('洗碗機'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.microwaveOven,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.microwaveOven = v;
                                                print(furniture.microwaveOven);
                                              });
                                            },
                                            title: Text('微波爐'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.cookerHood,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.cookerHood = v;
                                                print(furniture.cookerHood);
                                              });
                                            },
                                            title: Text('油煙機'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.wiredNetwork,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.wiredNetwork = v;
                                                print(furniture.wiredNetwork);
                                              });
                                            },
                                            title: Text('有線網路'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.gas,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.gas = v;
                                                print(furniture.gas);
                                              });
                                            },
                                            title: Text('瓦斯'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture
                                                .fingerprintPasswordLock,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture
                                                    .fingerprintPasswordLock = v;
                                                print(furniture
                                                    .fingerprintPasswordLock);
                                              });
                                            },
                                            title: Text('指紋密碼鎖'),
                                          ),
                                        ),
                                        MyCheckBoxData(
                                          checkboxListTile: CheckboxListTile(
                                            value: furniture.preservation,
                                            onChanged: (v) {
                                              setState(() {
                                                furniture.preservation = v;
                                                print(furniture.preservation);
                                              });
                                            },
                                            title: Text('保全設施'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: NewHouseTextFiled(
                                      hintText: '限制20字',
                                      labelText: '其他設施',
                                      controller: otherFacilities,
                                      width: 0.8,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Step(
                              isActive: _position >= 3 ? true : false,
                              state: _position == 3
                                  ? StepState.editing
                                  : StepState.indexed,
                              title: Text(
                                '其他規定',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '租客條件',
                                style: TextStyle(fontSize: 16),
                              ),
                              content: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.pregnant_woman),
                                            labelText: '性別',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['性別'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['性別'] =
                                                      newValue;
                                                  String genderValues =
                                                      newValue;
                                                  newHouseData.genderValues =
                                                      genderValues;
                                                  print(newHouseData
                                                      .houseTypeValues);
                                                });
                                              },
                                              items: newHouseData.gender
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['性別'],
                                                  child: Text(color['性別']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.smoking_rooms),
                                            labelText: '吸菸',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['吸菸'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['吸菸'] =
                                                      newValue;
                                                  newHouseData.smokeValues =
                                                      newValue;
                                                  print(newHouseData
                                                      .houseTypeValues);
                                                });
                                              },
                                              items: newHouseData.smokes
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['吸菸'],
                                                  child: Text(color['吸菸']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.fastfood),
                                            labelText: '開伙',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['開伙'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['開伙'] =
                                                      newValue;
                                                  newHouseData.partyValues =
                                                      newValue;
                                                  print(newHouseData
                                                      .houseTypeValues);
                                                });
                                              },
                                              items: newHouseData.party
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['開伙'],
                                                  child: Text(color['開伙']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.pets),
                                            labelText: '寵物',
                                          ),
                                          // isEmpty: _group['color'] == Colors.black,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: newHouseData.data['寵物'],
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  newHouseData.data['寵物'] =
                                                      newValue;
                                                  newHouseData.petValues =
                                                      newValue;
                                                });
                                              },
                                              items: newHouseData.pet
                                                  .map((dynamic color) {
                                                return DropdownMenuItem(
                                                  value: color['寵物'],
                                                  child: Text(color['寵物']),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              isActive: _position >= 4 ? true : false,
                              state: _position == 4
                                  ? StepState.editing
                                  : StepState.indexed,
                              title: Text(
                                '房屋費用設定',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '房租相關',
                                style: TextStyle(fontSize: 16),
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '設定租金',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: NewHouseTextFiledKBTypeNum(
                                          regExp: '0-9',
                                          maxInt: 6,
                                          labelText: '租金,包含其他費用',
                                          hintText: '４５００',
                                          controller: houseMoneyController,
                                          width: 1,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '元/月',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: NewHouseTextFiledKBTypeNum(
                                          regExp: '0-9',
                                          maxInt: 2,
                                          onEditingComplete: maxCashTime,
                                          labelText: '繳費時間',
                                          hintText: '每月３',
                                          controller: cashTimeController,
                                          width: 1,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '號',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '電費',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(請選擇您預收電費的方式)',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: newHouseData.storedValue,
                                        onChanged: (v) {
                                          setState(() {
                                            newHouseData.storedValue = v;
                                            print(newHouseData.storedValue);
                                            newHouseData.fixed =
                                                !newHouseData.storedValue;
                                          });
                                        },
                                      ),
                                      Text(
                                        '儲值',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: newHouseData.fixed,
                                            onChanged: (v) {
                                              setState(() {
                                                newHouseData.fixed = v;
                                                newHouseData.storedValue =
                                                    !newHouseData.fixed;
                                                print(newHouseData.storedValue);
                                              });
                                            },
                                          ),
                                          Text(
                                            '每月隨房租繳交',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  newHouseData.fixed
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child:
                                                    NewHouseTextFiledKBTypeNum(
                                                  regExp: '0-9',
                                                  maxInt: newHouseData.fixed
                                                      ? 4
                                                      : 1,
                                                  onEditingComplete:
                                                      maxElectricityMoney,
                                                  labelText: newHouseData.fixed
                                                      ? '每月'
                                                      : '每度',
                                                  hintText: newHouseData.fixed
                                                      ? '４００'
                                                      : '５',
                                                  controller:
                                                      electricityMoneyController,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '元',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                )),
                                          ],
                                        )
                                      : Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed:
                                                      electricityMoneyStored ==
                                                              0
                                                          ? null
                                                          : () {
                                                              setState(() {
                                                                electricityMoneyController
                                                                    .text = "0";
                                                                electricityMoneyStored--;
                                                              });
                                                            },
                                                  child: Icon(
                                                      Icons.exposure_neg_1)),
                                              Text('$electricityMoneyStored'),
                                              FlatButton(
                                                  onPressed:
                                                      electricityMoneyStored ==
                                                              7
                                                          ? null
                                                          : () {
                                                              setState(() {
                                                                electricityMoneyController
                                                                    .text = "0";
                                                                electricityMoneyStored++;
                                                              });
                                                            },
                                                  child: Icon(
                                                      Icons.exposure_plus_1)),
                                              Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '元',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '水費',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(請選擇您預收水費的方式)',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: newHouseData.waterFixed,
                                            onChanged: (v) {
                                              setState(() {
                                                newHouseData.waterFixed =! v;
                                              });
                                            },
                                          ),
                                          Text(
                                            '每月隨房租繳交',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: NewHouseTextFiledKBTypeNum(
                                          regExp: '0-9',
                                          maxInt: 3,
                                          onEditingComplete: maxWaterMoney,
                                          labelText: '每月',
                                          hintText: '300',
                                          controller: waterMoneyController,
                                          width: 1,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '元',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '其他費用',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(將包含在房租內)',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: newHouseData.managementFee,
                                            onChanged: (v) {
                                              setState(() {
                                                newHouseData.managementFee = v;
                                              });
                                            },
                                          ),
                                          Text(
                                            '管理費',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: newHouseData.internetFee,
                                            onChanged: (v) {
                                              setState(() {
                                                newHouseData.internetFee = v;
                                              });
                                            },
                                          ),
                                          Text(
                                            '網路費',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: newHouseData.television,
                                            onChanged: (v) {
                                              setState(() {
                                                newHouseData.television = v;
                                              });
                                            },
                                          ),
                                          Text(
                                            '第四台',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Checkbox(
                                                value: newHouseData.gasFee,
                                                onChanged: (v) {
                                                  setState(() {
                                                    newHouseData.gasFee = v;
                                                  });
                                                },
                                              ),
                                              Text(
                                                '瓦斯費',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '押金',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(在房客將房源依原樣返還後\n您需將押金返還給房客)',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: NewHouseTextFiledKBTypeNum(
                                          regExp: '0-2',
                                          maxInt: 1,
                                          labelText: '押金',
                                          hintText: '依法律規定最高上限為2',
                                          controller: depositController,
                                          width: 1,
                                        ),
                                      ),
                                      Expanded(child: Text('個月')),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ].toList()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewHouseTextFiled extends StatelessWidget {
  final double width;
  final String labelText;
  final String hintText;
  final TextEditingController controller;

  NewHouseTextFiled({
    this.controller,
    this.width,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            labelText: labelText,
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3,
              ),
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(20),
          ]),
    );
  }
}

class NewHouseTextFiledKBTypeNum extends StatelessWidget {
  final double width;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String regExp;
  final int maxInt;
  final Function onEditingComplete;

  NewHouseTextFiledKBTypeNum({
    this.onEditingComplete,
    this.regExp,
    this.maxInt,
    this.controller,
    this.width,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.1,
      child: TextField(
          onEditingComplete: onEditingComplete,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            labelText: labelText,
            labelStyle: TextStyle(fontSize: Adapt.px(23)),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: Adapt.px(20)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3,
              ),
            ),
          ),
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp("[$regExp]")),
            LengthLimitingTextInputFormatter(maxInt),
          ]),
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/app_const.dart';

import '../guestHomePage.dart';

//房屋資訊
class PersonalTenantInformation extends StatefulWidget {
  final String houseName;
  final String address;
  final String houseMoney;
  final String cityValues;
  final String houseTypeValues;
  final String roomTypeValues;
  final String floor;
  final String allFloor;
  final String area;
  final String bedroomsNum;
  final String bedNum;
  final String haveKitchen;
  final String houseIsWhoValues;
  final String haveLivingRoom;
  final String haveBalcony;
  final String bathroomType;

  //點入後詳細資訊
  final String cashTime;
  final String waterMoney;
  final String electricityMoney;
  final String summerElectricityMoneyController;
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
  final bool waterStored;
  final String housingIntroduction;
  final bool fixed;
  final bool storedValue;
  final String deposit;
  final String otherFacilities;
  final String url1;
  final String url;

  PersonalTenantInformation(
      {@required this.address,
      @required this.cityValues,
      @required this.storedValue,
      @required this.otherFacilities,
      @required this.summerElectricityMoneyController,
      @required this.fixed,
      @required this.url,
      @required this.url1,
      @required this.houseIsWhoValues,
      @required this.haveBalcony,
      @required this.haveKitchen,
      @required this.haveLivingRoom,
      @required this.bathroomType,
      @required this.roomTypeValues,
      @required this.allFloor,
      @required this.area,
      @required this.bedNum,
      @required this.bedroomsNum,
      @required this.deposit,
      @required this.floor,
      @required this.housingIntroduction,
      @required this.waterStored,
      @required this.houseTypeValues,
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
      @required this.houseName});

  @override
  _PersonalTenantInformationState createState() =>
      _PersonalTenantInformationState();
}

class _PersonalTenantInformationState extends State<PersonalTenantInformation> {
  bool inAsyncCall = false;
  bool noHasGatewayFixd = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  var loginUser;

  Future delete() async {
    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      loginUser = currentUser.email;
      await _firestore
          .collection('房東')
          .document('新建房間')
          .collection(loginUser)
          .document(widget.houseName)
          .delete();
    }
  }

  String points;

  Future saveData() async {
    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      loginUser = currentUser.email;
      await _firestore
          .collection('房東')
          .document('新建房間')
          .collection(loginUser)
          .document(widget.houseName)
          .setData({
        '門鎖相關': {
          '門鎖編號': '',
          '有無門鎖': false,
          '臨時密碼': '',
        },
        '網關相關': {
          '網關編號': '',
          '有無電表': false,
          '上期度數': '',
          '本期度數': '',
          '使用度數': '',
        },
        '照片位置': {
          '照片1': widget.url,
          '照片2': widget.url1,
        },
        '房間位置與類型': {
          '城市': widget.cityValues,
          '地址': widget.address,
          '建物型態': widget.houseTypeValues,
          '房間類型': widget.roomTypeValues
        },
        '樓層資訊': {
          '樓層': widget.floor, //樓層
          '全部樓層': widget.allFloor, //全部樓層
          '房屋面積': widget.area, //房屋面積
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
        '其他條件': {
          '性別': widget.gender,
          '吸菸': widget.smoke,
          '開伙': widget.party,
          '寵物': widget.pet,
        },
        '房屋費用設定': {
          '房租': widget.houseMoney,
          '繳費時間': widget.cashTime,
          '電費': widget.electricityMoney,
          '夏季電費': widget.summerElectricityMoneyController,
          '水費': widget.waterMoney,
          '水費每月固定': widget.waterStored,
          '電費每月固定': widget.fixed,
          '電費儲值': widget.storedValue,
          '有電表儲值單位': noHasGatewayFixd,
          '管理費': widget.managementFee,
          '網路費': widget.internetFee,
          '第四臺': widget.television,
          '瓦斯費': widget.gasFee,
          '押金': widget.deposit,
        },
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
        '生成時間': DateTime.now().toUtc()
      });
      print({widget.fixed, widget.storedValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              delete();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GuestHomePage()));
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                inAsyncCall = true;
                saveData();
                saveData().then((value) {
                  if (widget.preservation != null) {
                    inAsyncCall = false;
                    Navigator.pushNamed(context, GuestHomePage.routeName);
                  }
                });
              })
        ],
        centerTitle: true,
        title: Text(
          widget.houseName,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.appBarAndFontColor,
      ),
      body: Container(
        color: AppConstants.backColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                children: <Widget>[
                  HouseData(
                    title: '繳費時間',
                    detail: '每月${widget.cashTime}號',
                    backColor: AppConstants.backColor,
                  ),
                  HouseData(
                    title: '房間地址',
                    detail: widget.address,
                  ),
                  HouseData(
                    title: '房租費用',
                    detail: 'NT.${widget.houseMoney}',
                    backColor: AppConstants.backColor,
                  ),
                  HouseData(
                    title: '電費',
                    detail: widget.fixed
                        ? '非夏季電費:${widget.electricityMoney}/月\n夏季電費:${widget.summerElectricityMoneyController}/月'
                        : '非夏季電費:${widget.electricityMoney}/度\n夏季電費:${widget.summerElectricityMoneyController}/度',
                  ),
                  HouseData(
                    title: '水費',
                    detail: '水費:${widget.waterMoney}/月',
                    backColor: AppConstants.backColor,
                  ),
                  HouseIcon(
                    title: '其他設施',
                    television: widget.television,
                    internetFee: widget.internetFee,
                    gasFee: widget.gasFee,
                    managementFee: widget.managementFee,
                  ),
                  HouseData(
                    title: '備註',
                    detail:
                        '性別:${widget.gender}    寵物:${widget.pet}\n吸菸:${widget.smoke}   開伙：${widget.party} ',
                    backColor: AppConstants.backColor,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.height * 0.015,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '家具',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.tvTable,
                              title: '電視櫃',
                            ),
                            IconData(
                              have: widget.diningTable,
                              title: '餐桌',
                            ),
                            IconData(
                              have: widget.shoeBox,
                              title: '鞋櫃',
                            ),
                            IconData(
                              have: widget.bookBox,
                              title: '書櫃',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.sofa,
                              title: '沙發',
                            ),
                            IconData(
                              have: widget.coffeeTable,
                              title: '茶几',
                            ),
                            IconData(
                              have: widget.bedside,
                              title: '床頭組',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.fluidTable,
                              title: '流理台',
                            ),
                            IconData(
                              have: widget.gasStove,
                              title: '瓦斯爐',
                            ),
                            IconData(
                              have: widget.bookTable,
                              title: '書桌椅',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.dressingTable,
                              title: '梳妝台',
                            ),
                            IconData(
                              have: widget.locker,
                              title: '置物櫃',
                            ),
                            IconData(
                              have: widget.wardrobe,
                              title: '衣櫃',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.height * 0.015,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '設備',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.airConditioner,
                              title: '冷氣',
                            ),
                            IconData(
                              have: widget.wifi,
                              title: 'WIFI',
                            ),
                            IconData(
                              have: widget.washingMachine,
                              title: '洗衣機',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.waterHeater,
                              title: '熱水器',
                            ),
                            IconData(
                              have: widget.microwaveOven,
                              title: '微波爐',
                            ),
                            IconData(
                              have: widget.oven,
                              title: '烤箱',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.tv,
                              title: '電視',
                            ),
                            IconData(
                              have: widget.cookerHood,
                              title: '排油煙機',
                            ),
                            IconData(
                              have: widget.gas,
                              title: '瓦斯',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.dishwasher,
                              title: '洗碗機',
                            ),
                            IconData(
                              have: widget.phone,
                              title: '電話',
                            ),
                            IconData(
                              have: widget.wiredNetwork,
                              title: '有線網路',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconData(
                              have: widget.refrigerator,
                              title: '冰箱',
                            ),
                            IconData(
                              have: widget.preservation,
                              title: '保全設施',
                            ),
                            IconData(
                              have: widget.fingerprintPasswordLock,
                              title: '指紋密碼鎖',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  HouseData(
                    title: '附加設施',
                    detail: widget.otherFacilities,
                    backColor: AppConstants.backColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//家具設備
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
            Icon(
              have ? Icons.check : Icons.clear,
              color: have ? Colors.black : Colors.grey[300],
            ),
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

//資訊卡
class HouseData extends StatelessWidget {
  final String title;
  final String detail;
  final Color backColor;

  const HouseData({Key key, this.title, this.detail, this.backColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor,
      height: MediaQuery.of(context).size.height / 11,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$title :',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  '$detail',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HouseIcon extends StatelessWidget {
  final String title;
  final bool managementFee;
  final bool internetFee;
  final bool television;
  final bool gasFee;

  const HouseIcon(
      {Key key,
      this.title,
      this.television,
      this.internetFee,
      this.managementFee,
      this.gasFee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 11,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$title :',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  managementFee ? '管理費' : '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  internetFee ? '網路費' : '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  gasFee ? '瓦斯費' : '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  television ? '第四臺' : '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

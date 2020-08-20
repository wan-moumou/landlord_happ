import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/Widgets.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

import 'preview.dart';

class ForRentTenantInformation extends StatefulWidget {
  static final String routeName = '/TenantInformation';
  final int index;

  final String cashTime;
  final String address;
  final String houseMoney;
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
  final String houseName;
  final String summerElectricityMoney;
  final String tenantMail;
  final String contract; //合約日期
  final bool fixed;
  final bool noHasGatewayFixd;
  final String otherFacilities;

  ForRentTenantInformation(
      {this.index,
      this.contract,
      this.otherFacilities,
      this.fixed,
      this.noHasGatewayFixd,
      this.tenantMail,
      this.address,
      this.houseMoney,
      this.managementFee,
      this.summerElectricityMoney,
      this.gasFee,
      this.internetFee,
      this.television,
      this.pet,
      this.airConditioner,
      this.wifi,
      this.refrigerator,
      this.phone,
      this.oven,
      this.washingMachine,
      this.waterHeater,
      this.dishwasher,
      this.microwaveOven,
      this.cookerHood,
      this.wiredNetwork,
      this.gas,
      this.fingerprintPasswordLock,
      this.preservation,
      this.tv,
      this.locker,
      this.fluidTable,
      this.dressingTable,
      this.bookTable,
      this.gasStove,
      this.bedside,
      this.tvTable,
      this.sofa,
      this.wardrobe,
      this.bookBox,
      this.shoeBox,
      this.diningTable,
      this.coffeeTable,
      this.waterMoney,
      this.electricityMoney,
      this.cashTime,
      this.party,
      this.gender,
      this.smoke,
      this.houseName});

  @override
  _ForRentTenantInformationState createState() =>
      _ForRentTenantInformationState();
}

class _ForRentTenantInformationState extends State<ForRentTenantInformation> {
  final List<Tab> tabCard = <Tab>[
    Tab(
      text: '房屋資訊',
    ),
    Tab(
      text: "租客資訊",
    ),
    Tab(
      text: '帳務資訊',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.houseName,
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppConstants.appBarAndFontColor,
          bottom: TabBar(
            unselectedLabelColor: Color(0xFFA7BDEB),
            labelColor: Colors.white,
            tabs: tabCard,
          ),
        ),
        body: TabBarView(children: <Widget>[
          TenantInformation1(
            index: widget.index,
            address: widget.address,
            otherFacilities: widget.otherFacilities,
            fixed: widget.fixed,
            houseMoney: widget.houseMoney,
            managementFee: widget.managementFee,
            summerElectricityMoney: widget.summerElectricityMoney,
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
            fingerprintPasswordLock: widget.fingerprintPasswordLock,
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
            noHasGatewayFixd: widget.noHasGatewayFixd,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('房客/帳號資料/${widget.tenantMail}')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  final data = snapshot.data;
                  print(data.documents[1]['手機號碼']);
                  print(widget.tenantMail);
                  return TenantInformation2(
                    index: widget.index,
                    tenantMail: widget.tenantMail,
                    phoneNumber: data.documents[1]['手機號碼'],
                    tenantName: data.documents[1]['name'],
                    contract: widget.contract,
                    tenantImageUrl: data.documents[1]['url'],
                  );
                }
              }),
          TenantInformation3(
            index: widget.index,
          )
        ]),
      ),
    );
  }
}

//房屋資訊
class TenantInformation1 extends StatelessWidget {
  final int index;
  final String cashTime;
  final String address;
  final String houseMoney;
  final String waterMoney;
  final String electricityMoney;
  final bool television;
  final bool internetFee;
  final bool gasFee;
  final bool managementFee;
  final String gender;
  final String pet;
  final String summerElectricityMoney;
  final String smoke;
  final String party;
  final String otherFacilities;
  final String houseName;
  final bool tvTable;
  final bool noHasGatewayFixd;
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
  final bool fixed;

  TenantInformation1(
      {this.index,
      this.address,
      this.houseMoney,
      this.houseName,
      this.summerElectricityMoney,
      this.fixed,
      this.otherFacilities,
      this.noHasGatewayFixd,
      this.managementFee,
      this.gasFee,
      this.internetFee,
      this.television,
      this.pet,
      this.airConditioner,
      this.wifi,
      this.refrigerator,
      this.phone,
      this.oven,
      this.washingMachine,
      this.waterHeater,
      this.dishwasher,
      this.microwaveOven,
      this.cookerHood,
      this.wiredNetwork,
      this.gas,
      this.fingerprintPasswordLock,
      this.preservation,
      this.tv,
      this.locker,
      this.fluidTable,
      this.dressingTable,
      this.bookTable,
      this.gasStove,
      this.bedside,
      this.tvTable,
      this.sofa,
      this.wardrobe,
      this.bookBox,
      this.shoeBox,
      this.diningTable,
      this.coffeeTable,
      this.waterMoney,
      this.electricityMoney,
      this.cashTime,
      this.party,
      this.gender,
      this.smoke});

  bool water = false;
  bool power = false;
  final _firestore = Firestore.instance;

  void waterAndElectricity(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.local_drink),
                Text("水電狀態"),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '電費剩餘度數: 35度\n水費剩餘度數: 0度',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * .1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('斷水狀態'),
                        IconButton(
                          onPressed:water==true? null:() {
                            setState(() {
                              water = !water;
                            });
                          },
                          icon: Icon(
                            water
                                ? MaterialCommunityIcons.water
                                : MaterialCommunityIcons.water_off,
                            color: water
                                ? AppConstants.appBarAndFontColor
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('斷電狀態'),
                        IconButton(
                          onPressed:power==true? null:() {
                            setState(() {
                              power = !power;
                            });
                          },
                          icon: Icon(
                            power
                                ? MaterialCommunityIcons.power_plug
                                : MaterialCommunityIcons.power_plug_off,
                            color: power
                                ? AppConstants.appBarAndFontColor
                                : Colors.red,
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

  final _auth = FirebaseAuth.instance;
  bool lockStatus;
  String loginUser = '';
  String thisHouseName = '';

  Future getUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    print(loginUser);
  }

  void lock(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("門鎖狀態"),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('房東')
                      .document('帳號資料')
                      .collection(loginUser)
                      .document('資料')
                      .collection('擁有房間')
                      .document(houseName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      final data = snapshot.data;
                      return Container(
                        height: MediaQuery.of(context).size.height * .15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: Text('門鎖編號:')),
                                data['門鎖相關']['有無門鎖'] == false
                                    ? Expanded(flex: 1, child: Text('尚未加入...'))
                                    : Expanded(
                                        flex: 1, child: Text(data['門鎖相關']['門鎖編號'])),
                                Expanded(flex: 1,
                                    child: SizedBox())
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: Text('門鎖狀態:')),
                                Expanded(
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    child: data['門鎖相關']['門鎖編號'] == ''
                                        ? Text('暫無')
                                        : Text(lockStatus ? '正常開放' : '欠費封鎖'),
                                    onPressed: data['門鎖相關']['門鎖編號'] == ''
                                        ? null
                                        : () {
                                            lockStatus == false
                                                ? lockOpenLockTimeSettings(
                                                    context)
                                                : null;
                                          },
                                  ),
                                ),
                                Expanded(
                                  child: Icon(lockStatus
                                      ? AntDesign.unlock
                                      : AntDesign.lock1),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  });
            }),
          );
        });
  }

  String openLock = '未選';
  int openLockTime = DateTime.now().day;
  String doorLockNUM = '';

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
                            setState(() {
                              lockStatus == false
                                  ? lockStatus = !lockStatus
                                  : null;
                            });
                            Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.backColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            waterAndElectricity(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.local_drink,
                                color: AppConstants.appBarAndFontColor,
                              ),
                              Text(
                                '水電狀態',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )),
                      Container(
                          height: 20,
                          child: VerticalDivider(color: Colors.grey)),
                      //垂直分隔線
                      StatefulBuilder(builder: (context, StateSetter setState) {
                        return FlatButton(
                            onPressed: () {
                              setState(() {
                                DateTime.now().day >= openLockTime
                                    ? lockStatus = false
                                    : lockStatus = true;
                              });
                              getUser();
                              lock(context);
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.do_not_disturb_off,
                                  color: AppConstants.appBarAndFontColor,
                                ),
                                Text(
                                  '門鎖狀態',
                                  style: TextStyle(fontSize: 10),
                                )
                              ],
                            ));
                      }),
                      Container(
                          height: 20,
                          child: VerticalDivider(color: Colors.grey)),
                      //垂直分隔線
                      FlatButton(
                          onPressed: () {},
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.build,
                                color: AppConstants.appBarAndFontColor,
                              ),
                              Text(
                                '修繕狀態',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                HouseData(
                  title: '繳費時間',
                  detail: '每月$cashTime號',
                  backColor: AppConstants.backColor,
                ),
                HouseData(
                  title: '房間地址',
                  detail: address,
                ),
                HouseData(
                  title: '房租費用',
                  detail: 'NT.$houseMoney',
                  backColor: AppConstants.backColor,
                ),
                HouseData(
                  title: '水費',
                  detail: '水費:$waterMoney/月',
                ),
                HouseData(
                  title: '電費',
                  detail:  noHasGatewayFixd?'非夏季電費:$electricityMoney/度\n夏季電費:$summerElectricityMoney/度'
                      : '非夏季電費:$electricityMoney/月\n夏季電費:$summerElectricityMoney/月',
                  backColor: AppConstants.backColor,
                ),
                HouseIcon(
                  title: '其他設施',
                  television: television,
                  internetFee: internetFee,
                  gasFee: gasFee,
                  managementFee: managementFee,
                ),
                HouseData(
                  title: '備註',
                  detail: '性別:$gender    寵物:$pet\n吸菸:$smoke   開伙：$party ',
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
                            have: tvTable,
                            title: '電視櫃',
                          ),
                          IconData(
                            have: diningTable,
                            title: '餐桌',
                          ),
                          IconData(
                            have: shoeBox,
                            title: '鞋櫃',
                          ),
                          IconData(
                            have: bookBox,
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
                            have: sofa,
                            title: '沙發',
                          ),
                          IconData(
                            have: coffeeTable,
                            title: '茶几',
                          ),
                          IconData(
                            have: bedside,
                            title: '床頭組',
                          ),
                          IconData(
                            have: wardrobe,
                            title: '衣櫃',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          IconData(
                            have: fluidTable,
                            title: '流理台',
                          ),
                          IconData(
                            have: gasStove,
                            title: '瓦斯爐',
                          ),
                          IconData(
                            have: bookTable,
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
                            have: dressingTable,
                            title: '梳妝台',
                          ),
                          IconData(
                            have: locker,
                            title: '置物櫃',
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
                            have: airConditioner,
                            title: '冷氣',
                          ),
                          IconData(
                            have: wifi,
                            title: 'WIFI',
                          ),
                          IconData(
                            have: refrigerator,
                            title: '冰箱',
                          ),
                          IconData(
                            have: washingMachine,
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
                            have: waterHeater,
                            title: '熱水器',
                          ),
                          IconData(
                            have: microwaveOven,
                            title: '微波爐',
                          ),
                          IconData(
                            have: oven,
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
                            have: tv,
                            title: '電視',
                          ),
                          IconData(
                            have: cookerHood,
                            title: '排油煙機',
                          ),
                          IconData(
                            have: gas,
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
                            have: dishwasher,
                            title: '洗碗機',
                          ),
                          IconData(
                            have: phone,
                            title: '電話',
                          ),
                          IconData(
                            have: wiredNetwork,
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
                            have: preservation,
                            title: '保全設施',
                          ),
                          IconData(
                            have: fingerprintPasswordLock,
                            title: '指紋密碼鎖',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                HouseData(
                  title: '附加設施',
                  detail: otherFacilities == null ? '無' : otherFacilities,
                  backColor: AppConstants.backColor,
                ),
              ],
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
              maxLines: 1,
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

  const HouseData({
    Key key,
    this.title,
    this.detail,
    this.backColor,
  }) : super(key: key);

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
            child: Text(
              '$detail',
              maxLines: 2,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

//租客資訊
class TenantInformation2 extends StatelessWidget {
  final int index;
  final String tenantMail;
  final String phoneNumber;
  final String tenantName;
  final String contract; //合約日期
  final String tenantImageUrl;

  TenantInformation2(
      {this.index,
      this.tenantMail,
      this.contract,
      this.phoneNumber,
      this.tenantName,
      this.tenantImageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.backColor,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      //內圈相片
                      backgroundImage: NetworkImage(tenantImageUrl),
                      radius: MediaQuery.of(context).size.width / 5.1,
                    ),
                  ),
                  HouseData(
                    title: "房客帳號",
                    detail: tenantMail,
                    backColor: AppConstants.backColor,
                  ),
                  HouseData(
                    title: "房客姓名",
                    detail: tenantName,
                  ),
                  HouseData(
                    title: '簽約日期',
                    detail: contract,
                    backColor: AppConstants.backColor,
                  ),
                  HouseData(
                    title: '連絡電話',
                    detail: phoneNumber,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    color: AppConstants.backColor,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
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

//帳務資訊
class TenantInformation3 extends StatefulWidget {
  final int index;

  TenantInformation3({this.index});

  @override
  _TenantInformation3State createState() => _TenantInformation3State();
}

class _TenantInformation3State extends State<TenantInformation3> {
  bool day = true;
  bool userName = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.backColor,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  //選項名稱
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              day = !day;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Text('日期'),
                              Icon(day
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up)
                            ],
                          )),
                    ),
                    Expanded(flex: 3, child: IAEDownButton()),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) =>
                              IncomeAndExpensesListTitle(index), //內容
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

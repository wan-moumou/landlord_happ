
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/Widgets.dart';
import 'package:landlord_happy/app_const/app_const.dart';

import 'preview.dart';


class NotRentedTenantInformation extends StatefulWidget {
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
  final bool fixed;
  final String houseName;
  final String otherFacilities;

  NotRentedTenantInformation(
      {this.index,
      this.address,
      this.houseMoney,
      this.otherFacilities,
      this.fixed,
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
      this.smoke,
      this.houseName});

  @override
  _NotRentedTenantInformationState createState() =>
      _NotRentedTenantInformationState();
}

class _NotRentedTenantInformationState
    extends State<NotRentedTenantInformation> {
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
          NotRentedTenantInformation1(
            otherFacilities:widget.otherFacilities,
            index: widget.index,
            address: widget.address,
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
            fixed: widget.fixed,
          ),
          NotRentedTenantInformation2(
            index: widget.index,
          ),
          NotRentedTenantInformation3(
            index: widget.index,
          )
        ]),
      ),
    );
  }
}

//房屋資訊
class NotRentedTenantInformation1 extends StatelessWidget {
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
  final String otherFacilities;
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
  final bool fixed;

  NotRentedTenantInformation1(
      {this.index,
      this.address,
      this.houseMoney,
      this.fixed,

      this.managementFee,
      this.otherFacilities,
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
                          onPressed: () {},
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
                      FlatButton(
                          onPressed: () {},
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
                          )),
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
                  detail:'水費:$waterMoney/月',
                ),
                HouseData(
                  title: '電費',
                  detail: fixed?'電費:$electricityMoney/度':'電費:$electricityMoney/月',
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
                  detail: otherFacilities==null?'無':otherFacilities,
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
              style: TextStyle(fontSize: Adapt.px(30), color: Colors.grey[600]),
              
            ),
          ),
          Expanded(flex: 3,
            child: Text(
              '$detail',
              maxLines: 2,
              style: TextStyle(fontSize: Adapt.px(25), color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

//租客資訊
class NotRentedTenantInformation2 extends StatelessWidget {
  final int index;

  NotRentedTenantInformation2({this.index});

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
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      //內圈相片
                      backgroundImage: AssetImage('assets/images/2.jpeg'),
                      radius: MediaQuery.of(context).size.width / 5.1,
                    ),
                  ),
                  HouseData(
                    title: "房客帳號",
                    detail: "還沒有房客歐！",
                    backColor: AppConstants.backColor,
                  ),
                  HouseData(
                    title: "房客姓名",
                    detail: "還沒有房客歐！",
                  ),
                  HouseData(
                    title: '簽約日期',
                    detail: "以加入房客當天開始計算",
                    backColor: AppConstants.backColor,
                  ),
                  HouseData(
                    title: '連絡電話',
                    detail: "還沒有房客歐！",
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
class NotRentedTenantInformation3 extends StatefulWidget {
  final int index;

  NotRentedTenantInformation3({this.index});

  @override
  _NotRentedTenantInformation3State createState() =>
      _NotRentedTenantInformation3State();
}

class _NotRentedTenantInformation3State
    extends State<NotRentedTenantInformation3> {
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

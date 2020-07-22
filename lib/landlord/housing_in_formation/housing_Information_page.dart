import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';

import 'create_house.dart';
import 'for_rent.dart';
import 'not_rented.dart';

class HousingInformationPage extends StatefulWidget {
  HousingInformationPage({Key key}) : super(key: key);

  @override
  _HousingInformationPageState createState() => _HousingInformationPageState();
}

final List<Tab> myTabs = <Tab>[
  Tab(
    text: '已出租',
  ),
  Tab(
    text: "未出租",
  ),
];

class _HousingInformationPageState extends State<HousingInformationPage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  var loginUser;
  Stream stream;
  Stream tenantStream;
  TextEditingController _searchController = TextEditingController();

  void searchSnapshots() {
    print(_searchController.text);
    if (_searchController.text==null||_searchController.text=='') {
      stream = _firestore.collection('房東/新建房間/$loginUser').snapshots();
      tenantStream =
          _firestore.collection('房東/帳號資料/$loginUser/資料/擁有房間').snapshots();
    } else {
      stream = _firestore
          .collection('房東/新建房間/$loginUser/')
          .where('房屋名稱', isEqualTo: _searchController.text)
          .snapshots();
      tenantStream = _firestore
          .collection('房東/帳號資料/$loginUser/資料/擁有房間')
          .where('房屋名稱', isEqualTo: _searchController.text)
          .snapshots();
    }
  }

  FocusNode blankNode = FocusNode();

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    print(loginUser);
  }

  @override
  void initState() {
    getCurrentUser();
    Timer(Duration(seconds: 1), () {
      stream = _firestore.collection('房東/新建房間/$loginUser').snapshots();
      tenantStream =
          _firestore.collection('房東/帳號資料/$loginUser/資料/擁有房間').snapshots();
      setState(() {});
    });
    super.initState();
  }

  var data;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.appBarAndFontColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateHouse()));
                  }),
            ),
          ],
          title: Column(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 25, maxWidth: 200),
                child: TextField(
                  controller: _searchController,
                  onTap: () {
                    _searchController.text = '';
                    setState(() {
                      stream = _firestore
                          .collection('房東/新建房間/$loginUser')
                          .snapshots();
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      searchSnapshots();
                    });
                  },
                  textInputAction: TextInputAction.search,
                  focusNode: blankNode,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchController.clear();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    hintText: '搜索完整房間名稱',
                    prefixIcon: Icon(Icons.search),
                    // contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            unselectedLabelColor: Color(0xFFA7BDEB),
            labelColor: Colors.white,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(children: <Widget>[
          SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: tenantStream,
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
                    data = snapshot.data.documents;

                    return Container(
                      color: AppConstants.backColor,
                      height: MediaQuery.of(context).size.height * 0.73,
                      width: MediaQuery.of(context).size.width * 1,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          //網格數
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: Adapt.px(300) / Adapt.px(400),
                          ),
                          itemBuilder: (context, int index) {
                            return ForRentCard(
                              index: index,
                              imageList: [
                                data[index].data['照片位置']['照片1'],
                                data[index].data['照片位置']['照片2']
                              ],
                              houseImages2: data[index].data['照片位置']['照片2'],
                              tenantName: data[index].data['房客名稱'],
                              address: data[index].data['房間位置與類型']['地址'],
                              houseMoney: data[index].data['房屋費用設定']['房租'],
                              managementFee: data[index].data['房屋費用設定']['管理費'],
                              gasFee: data[index].data['房屋費用設定']['瓦斯費'],
                              internetFee: data[index].data['房屋費用設定']['網路費'],
                              television: data[index].data['房屋費用設定']['第四臺'],
                              pet: data[index].data['其他條件']['寵物'],
                              airConditioner: data[index].data['設備']['冷氣'],
                              wifi: data[index].data['設備']['wifi'],
                              refrigerator: data[index].data['設備']['冰箱'],
                              phone: data[index].data['設備']['電話'],
                              oven: data[index].data['設備']['烤箱'],
                              washingMachine: data[index].data['設備']['洗衣機'],
                              waterHeater: data[index].data['設備']['熱水器'],
                              dishwasher: data[index].data['設備']['洗碗機'],
                              microwaveOven: data[index].data['設備']['微波爐'],
                              cookerHood: data[index].data['設備']['油煙機'],
                              wiredNetwork: data[index].data['設備']['有線網路'],
                              gas: data[index].data['設備']['瓦斯'],
                              fingerprintPasswordLock: data[index].data['設備']
                                  ['指紋密碼鎖'],
                              preservation: data[index].data['設備']['保全設備'],
                              tv: data[index].data['設備']['電視'],
                              locker: data[index].data['家具']['置物櫃'],
                              fluidTable: data[index].data['家具']['流理臺'],
                              dressingTable: data[index].data['家具']['梳妝台'],
                              bookTable: data[index].data['家具']['書桌'],
                              gasStove: data[index].data['家具']['瓦斯爐'],
                              bedside: data[index].data['家具']['床頭組'],
                              tvTable: data[index].data['家具']['電視櫃'],
                              sofa: data[index].data['家具']['沙發'],
                              wardrobe: data[index].data['家具']['衣櫃'],
                              bookBox: data[index].data['家具']['書櫃'],
                              shoeBox: data[index].data['家具']['鞋櫃'],
                              diningTable: data[index].data['家具']['餐桌'],
                              coffeeTable: data[index].data['家具']['茶几'],
                              waterMoney: data[index].data['房屋費用設定']['水費'],
                              electricityMoney: data[index].data['房屋費用設定']
                                  ['電費'],
                              cashTime: data[index].data['房屋費用設定']['繳費時間'],
                              party: data[index].data['其他條件']['開伙'],
                              gender: data[index].data['其他條件']['性別'],
                              smoke: data[index].data['其他條件']['吸菸'],
                              houseImages: data[index].data['照片位置']['照片1'],
                              houseName: data[index].documentID,
                              phoneNumber: data[index].data['手機號碼'],
                              contract: data[index].data['生成時間'],
                              tenantMail: data[index].data['房客帳號'],
                              allFloor: data[index].data['樓層資訊']['全部樓層'],
                              haveBalcony: data[index].data['房間格局']['陽台'],
                              bedroomsNum: data[index].data['房間格局']['臥室數量'],
                              houseIsWhoValues: data[index].data['房源'],
                              roomTypeValues: data[index].data['房間位置與類型']
                                  ['房間類型'],
                              haveLivingRoom: data[index].data['房間格局']['客廳'],
                              bedNum: data[index].data['房間格局']['床數'],
                              deposit: data[index].data['房屋費用設定']['押金'],
                              area: data[index].data['樓層資訊']['房屋面積'],
                              houseTypeValues: data[index].data['房間位置與類型']
                                  ['建物型態'],
                              cityValues: data[index].data['房間位置與類型']['城市'],
                              bathroomType: data[index].data['房間格局']['衛浴'],
                              haveKitchen: data[index].data['房間格局']['廚房'],
                              housingIntroduction: data[index].data['簡介'],
                              floor: data[index].data['樓層資訊']['樓層'],
                              otherFacilities: data[index].data['附加設施'],
                              fixed:  data[index].data['房屋費用設定']['電費儲值'],
                              hasDoorLock:  data[index].data['門鎖相關']['有無門鎖'],
                              doorLockNUM:  data[index].data['門鎖相關']['門鎖編號'],
                            );
                          }),
                    );
                  } 
                }),
          ),
          SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting||loginUser==null) {
                      return Container(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      final data = snapshot.data.documents;

                      return Container(
                        color: AppConstants.backColor,
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * .76,
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            //網格數
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: Adapt.px(300) / Adapt.px(400),
                            ),
                            itemBuilder: (context, index) {
                              return NotRentedCard(
                                index: index,
                                imageList: [
                                  data[index].data['照片位置']['照片1'],
                                  data[index].data['照片位置']['照片2']
                                ],
                                houseImages2: data[index].data['照片位置']['照片2'],
                                address: data[index].data['房間位置與類型']['地址'],
                                houseMoney: data[index].data['房屋費用設定']['房租'],
                                managementFee: data[index].data['房屋費用設定']
                                    ['管理費'],
                                gasFee: data[index].data['房屋費用設定']['瓦斯費'],
                                internetFee: data[index].data['房屋費用設定']['網路費'],
                                television: data[index].data['房屋費用設定']['第四臺'],
                                pet: data[index].data['其他條件']['寵物'],
                                airConditioner: data[index].data['設備']['冷氣'],
                                wifi: data[index].data['設備']['wifi'],
                                refrigerator: data[index].data['設備']['冰箱'],
                                phone: data[index].data['設備']['電話'],
                                oven: data[index].data['設備']['烤箱'],
                                washingMachine: data[index].data['設備']['洗衣機'],
                                waterHeater: data[index].data['設備']['熱水器'],
                                dishwasher: data[index].data['設備']['洗碗機'],
                                microwaveOven: data[index].data['設備']['微波爐'],
                                cookerHood: data[index].data['設備']['油煙機'],
                                wiredNetwork: data[index].data['設備']['有線網路'],
                                gas: data[index].data['設備']['瓦斯'],
                                fingerprintPasswordLock: data[index].data['設備']
                                    ['指紋密碼鎖'],
                                preservation: data[index].data['設備']['保全設備'],
                                tv: data[index].data['設備']['電視'],
                                locker: data[index].data['家具']['置物櫃'],
                                fluidTable: data[index].data['家具']['流理臺'],
                                dressingTable: data[index].data['家具']['梳妝台'],
                                bookTable: data[index].data['家具']['書桌'],
                                gasStove: data[index].data['家具']['瓦斯爐'],
                                bedside: data[index].data['家具']['床頭組'],
                                tvTable: data[index].data['家具']['電視櫃'],
                                sofa: data[index].data['家具']['沙發'],
                                wardrobe: data[index].data['家具']['衣櫃'],
                                bookBox: data[index].data['家具']['書櫃'],
                                shoeBox: data[index].data['家具']['鞋櫃'],
                                diningTable: data[index].data['家具']['餐桌'],
                                coffeeTable: data[index].data['家具']['茶几'],
                                waterMoney: data[index].data['房屋費用設定']['水費'],
                                electricityMoney: data[index].data['房屋費用設定']
                                    ['電費'],
                                cashTime: data[index].data['房屋費用設定']['繳費時間'],
                                party: data[index].data['其他條件']['開伙'],
                                gender: data[index].data['其他條件']['性別'],
                                smoke: data[index].data['其他條件']['吸菸'],
                                houseImages: data[index].data['照片位置']['照片1'],
                                houseName: data[index].documentID,
                                allFloor: data[index].data['樓層資訊']['全部樓層'],
                                haveBalcony: data[index].data['房間格局']['陽台'],
                                bedroomsNum: data[index].data['房間格局']['臥室數量'],
                                houseIsWhoValues: data[index].data['房源'],
                                roomTypeValues: data[index].data['房間位置與類型']
                                    ['房間類型'],
                                haveLivingRoom: data[index].data['房間格局']['客廳'],
                                bedNum: data[index].data['房間格局']['床數'],
                                deposit: data[index].data['房屋費用設定']['押金'],
                                area: data[index].data['樓層資訊']['房屋面積'],
                                houseTypeValues: data[index].data['房間位置與類型']
                                    ['建物型態'],
                                cityValues: data[index].data['房間位置與類型']['城市'],
                                bathroomType: data[index].data['房間格局']['衛浴'],
                                haveKitchen: data[index].data['房間格局']['廚房'],
                                housingIntroduction: data[index].data['簡介'],
                                floor: data[index].data['樓層資訊']['房間樓層'],
                                otherFacilities: data[index].data['附加設施'],
                                fixed:  data[index].data['房屋費用設定']['電費儲值'],
                                hasDoorLock:  data[index].data['門鎖相關']['有無門鎖'],
                                doorLockNUM:  data[index].data['門鎖相關']['門鎖編號'],
                              );
                            }),
                      );
                    }
                  }))
        ]),
      ),
    );
  }
}

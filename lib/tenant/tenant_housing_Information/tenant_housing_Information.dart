import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/Widgets.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/landlord/housing_in_formation/preview.dart';
import 'package:landlord_happy/tenant/tenant_guest_home_page.dart';

class TenantHousingInformationPage extends StatefulWidget {
  static final String routeName = '/TenantHousingInformationPage';

  @override
  _TenantHousingInformationPageState createState() =>
      _TenantHousingInformationPageState();
}

class _TenantHousingInformationPageState
    extends State<TenantHousingInformationPage> {
  String loginUser;

  final _auth = FirebaseAuth.instance;

  final _firestore = Firestore.instance;

  String landlordName;

  String houseName;
  final List<Tab> tabCard = <Tab>[
    Tab(
      text: '房屋資訊',
    ),
    Tab(
      text: "房東資訊",
    ),
    Tab(
      text: '帳務資訊',
    ),
  ];

  void getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
    }
    print(loginUser);
    //確認房客身份
    await _firestore
        .collection("/房客/帳號資料/$loginUser")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        landlordName = f['房東姓名'];
        houseName = f['房屋名稱'];
      });
    });
    setState(() {

    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            houseName==''?'尚未加入':houseName,
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppConstants.tenantAppBarAndFontColor,
          bottom: TabBar(
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.white,
            tabs: tabCard,
          ),
        ),
        body:houseName== ''? Container(color: AppConstants.tenantBackColor,
          child: Center(
              child: Container(
                child: Text('請連絡房東並加入房間'),
              ))):StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('/房東/帳號資料/$landlordName/資料/擁有房間')
                .document(houseName)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data.data;
              print(data);
              return TabBarView(children: <Widget>[
                TenantInformation1(
                  address: data['房間位置與類型']['地址'],
                  houseMoney: data['房屋費用設定']['房租'],
                  managementFee: data['房屋費用設定']['管理費'],
                  gasFee: data['房屋費用設定']['瓦斯費'],
                  internetFee: data['房屋費用設定']['網路費'],
                  television: data['房屋費用設定']['第四臺'],
                  pet: data['其他條件']['寵物'],
                  airConditioner: data['設備']['冷氣'],
                  wifi: data['設備']['wifi'],
                  refrigerator: data['設備']['冰箱'],
                  phone: data['設備']['電話'],
                  oven: data['設備']['烤箱'],
                  washingMachine: data['設備']['洗衣機'],
                  waterHeater: data['設備']['熱水器'],
                  dishwasher: data['設備']['洗碗機'],
                  microwaveOven: data['設備']['微波爐'],
                  cookerHood: data['設備']['油煙機'],
                  wiredNetwork: data['設備']['有線網路'],
                  gas: data['設備']['瓦斯'],
                  fingerprintPasswordLock: data['設備']['指紋密碼鎖'],
                  preservation: data['設備']['保全設備'],
                  tv: data['設備']['電視'],
                  locker: data['家具']['置物櫃'],
                  fluidTable: data['家具']['流理臺'],
                  dressingTable: data['家具']['梳妝台'],
                  bookTable: data['家具']['書桌'],
                  gasStove: data['家具']['瓦斯爐'],
                  bedside: data['家具']['床頭組'],
                  tvTable: data['家具']['電視櫃'],
                  sofa: data['家具']['沙發'],
                  wardrobe: data['家具']['衣櫃'],
                  bookBox: data['家具']['書櫃'],
                  shoeBox: data['家具']['鞋櫃'],
                  diningTable: data['家具']['餐桌'],
                  coffeeTable: data['家具']['茶几'],
                  waterMoney: data['房屋費用設定']['水費'],
                  electricityMoney: data['房屋費用設定']['電費'],
                  cashTime: data['房屋費用設定']['繳費時間'],
                  party: data['其他條件']['開伙'],
                  gender: data['其他條件']['性別'],
                  smoke: data['其他條件']['吸菸'],
                  fixed: data['房屋費用設定']['電費儲值'],
                  houseName: houseName,
                  tenantMail: data['房客帳號'],
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('房東/帳號資料/$landlordName')
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
                        final data1 = snapshot.data.documents;
                        print(data1[1]['手機號碼']);
                        return TenantInformation2(
                          tenantMail: landlordName,
                          phoneNumber: data1[1]['手機號碼'],
                          tenantName: data1[1]['name'],
                          tenantImageUrl: data1[1]['url'],
                          contract: data['生成時間'],
                        );
                      }
                    }),
                TenantInformation3()
              ]);
            }),
      ),
    );
  }
}

class TenantInformation1 extends StatelessWidget {
  final int index;
  final String cashTime;

  final bool fixed;
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
  final String tenantMail;
  final String contract; //合約日期
  TenantInformation1(
      {this.index,
      this.contract,
      this.fixed,
      this.tenantMail,
      this.address,
      this.houseMoney,
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

  void doorLock(BuildContext context, String loginPassWord) {
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
                setPassWord(context, loginPassWord);
              },
              child: Text('新增密碼'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);

                setnewFingerprintPassWord(context, loginPassWord);
              },
              child: Text('新增指紋'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('臨時開門請求'),
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

  void contractRelated(BuildContext context, String loginPassWord) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            '合約相關',
            style: TextStyle(fontSize: 22),
          ), //标题
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                contractQuery(context);
              },
              child: Text('合約查詢'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                earlyTermination(context);
              },
              child: Text('提早解約'),
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

  TextEditingController doorPassWord = TextEditingController();

  //更新密碼
  void passWordUpData() async {
    await Firestore.instance
        .collection('/房客/帳號資料/$tenantMail')
        .document('資料')
        .updateData({'門鎖密碼': doorPassWord.text});
  }

  String loginPassWord;

  void getLoginPass() async {
    await Firestore.instance
        .collection("/房客/帳號資料/$tenantMail")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        loginPassWord = f['密碼'];

        print(getedDoorPassWord);
      });
    });
  }
  void contractQuery(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('合約查詢'),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      OutlineButton(onPressed: () {}, child: Text('確定'))
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
  void earlyTermination(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('提早解約'),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      OutlineButton(onPressed: () {}, child: Text('確定'))
                    ],
                  ),
                ),
              );
            }),
          );
        });
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
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('開啟水閘請求'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('開啟電表請求'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('查看剩餘度數'),
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

  void trySubmit1() {
    formKey1.currentState.validate();
  }

  String getedDoorPassWord = '';
  final formKey1 = GlobalKey<FormState>();

  //新增密碼
  void newPassWord(BuildContext context) {
    bool setPasswordKey = false;
    bool going = true;
    showDialog(
        context: context,
        barrierDismissible: going,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('密碼設定'),
                Text(
                  '設定房間密碼',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('密碼:'),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey1,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (doorPassWord.text.length == 6) {
                                    setState(() {
                                      setPasswordKey = true;
                                    });

                                    return null;
                                  } else {
                                    setState(() {
                                      setPasswordKey = false;
                                    });

                                    return '密碼必須等於6位數';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "請輸入密碼",
                                  helperText: '輸入6位數密碼',
                                ),
                                controller: doorPassWord,
                                obscureText: true,
                              ),
                            ),
                          )),
                        ],
                      ),
                      OutlineButton(
                          onPressed: () {
                            trySubmit1();
                            FocusScope.of(context).unfocus();
                            if (setPasswordKey) {
                              setState(() {
                                going = false;
                              });
                              passWordUpData();
                              setState(() {
                                going = true;
                              });
                              doorPassWord.clear();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('更改密碼'))
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  //新增指紋
  void newFingerprintPassWord(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('添加指紋'),
                Text(
                  '設定未出租房間指紋',
                  style: TextStyle(fontSize: Adapt.px(20), color: Colors.grey),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('依據逼聲提示,在指紋採集器上進行多次抬起按壓'),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Image.asset('assets/images/添加指紋.png'),
                      ),
                      OutlineButton(onPressed: () {}, child: Text('確定'))
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  void trySubmit() {
    formKey.currentState.validate();
  }

  final formKey = GlobalKey<FormState>();
  bool getPasswordKey = false;

  //新增密碼
  void setPassWord(
    BuildContext context,
    String loginPassword,
  ) {
    print(loginPassword);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('請輸入登入密碼'),
                Form(
                    key: formKey,
                    child: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (doorPassWord.text == loginPassword) {
                            setState(() {
                              getPasswordKey = true;
                            });

                            return null;
                          } else {
                            setState(() {
                              getPasswordKey = false;
                            });

                            return '密碼錯誤';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "請輸入密碼",
                        ),
                        controller: doorPassWord,
                        obscureText: true,
                      );
                    })),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: OutlineButton(
                      onPressed: () async {
                        trySubmit();
                        FocusScope.of(context).unfocus();
                        if (getPasswordKey) {
                          doorPassWord.clear();
                          newPassWord(context);
                        }
                      },
                      child: Text('確定')),
                ),
              );
            }),
          );
        });
  }

  void setnewFingerprintPassWord(
    BuildContext context,
    String loginPassword,
  ) {
    print(loginPassword);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('請輸入登入密碼'),
                Form(
                    key: formKey,
                    child: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (doorPassWord.text == loginPassword) {
                            setState(() {
                              getPasswordKey = true;
                            });

                            return null;
                          } else {
                            setState(() {
                              getPasswordKey = false;
                            });

                            return '密碼錯誤';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "請輸入密碼",
                        ),
                        controller: doorPassWord,
                        obscureText: true,
                      );
                    })),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: OutlineButton(
                      onPressed: () async {
                        trySubmit();
                        FocusScope.of(context).unfocus();
                        if (getPasswordKey) {
                          doorPassWord.clear();
                          newFingerprintPassWord(context);
                        }
                      },
                      child: Text('確定')),
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    getLoginPass();
    return Container(
      color: AppConstants.tenantBackColor,
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
                            waterAndEle(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.local_drink,
                                color: AppConstants.appBarAndFontColor,
                              ),
                              Text(
                                '水電相關',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )),
                      Container(
                          height: 20,
                          child: VerticalDivider(color: Colors.grey)),
                      //垂直分隔線
                      FlatButton(
                          onPressed: () {
                            doorLock(context, loginPassWord);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                FontAwesome.lock,
                                color: AppConstants.appBarAndFontColor,
                              ),
                              Text(
                                '門鎖相關',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )),
                      Container(
                          height: 20,
                          child: VerticalDivider(color: Colors.grey)),
                      //垂直分隔線
                      FlatButton(
                          onPressed: () {
                            contractRelated(context,loginPassWord);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.build,
                                color: AppConstants.appBarAndFontColor,
                              ),
                              Text(
                                '合約相關',
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
                  backColor: AppConstants.tenantBackColor,
                ),
                HouseData(
                  title: '房間地址',
                  detail: address,
                ),
                HouseData(
                  title: '房租費用',
                  detail: 'NT.$houseMoney',
                  backColor: AppConstants.tenantBackColor,
                ),
                HouseData(
                  title: '水費',
                  detail: '水費:$waterMoney/月',
                ),
                HouseData(
                  title: '電費',
                  detail: fixed
                      ? '電費:$electricityMoney/度'
                      : '電費:$electricityMoney/月',
                  backColor: AppConstants.tenantBackColor,
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
                  backColor: AppConstants.tenantBackColor,
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          IconData(
                            have: wardrobe,
                            title: '衣櫃',
                          ),
                          IconData(
                            have: fluidTable,
                            title: '流理台',
                          ),
                          IconData(
                            have: gasStove,
                            title: '瓦斯爐',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          IconData(
                            have: bookTable,
                            title: '書桌椅',
                          ),
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
                          IconData(
                            have: washingMachine,
                            title: '洗衣機',
                          ),
                        ],
                      ),
                    ),
                  ],
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

//房東資訊
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
      color: AppConstants.tenantBackColor,
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
                      backgroundImage: NetworkImage(tenantImageUrl),
                      radius: MediaQuery.of(context).size.width / 5.1,
                    ),
                  ),
                  HouseData(
                    title: "房客帳號",
                    detail: tenantMail,
                    backColor: AppConstants.tenantBackColor,
                  ),
                  HouseData(
                    title: "房客姓名",
                    detail: tenantName,
                  ),
                  HouseData(
                    title: '簽約日期',
                    detail: contract,
                    backColor: AppConstants.tenantBackColor,
                  ),
                  HouseData(
                    title: '連絡電話',
                    detail: phoneNumber,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    color: AppConstants.tenantBackColor,
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
  static final String routeName = '/IncomeAndExpenses';

  @override
  _TenantInformation3State createState() => _TenantInformation3State();
}

class _TenantInformation3State extends State<TenantInformation3> {
  bool day = true;
  bool userName = true;
  String loginUser = '';
  int items = 0;
  final _auth = FirebaseAuth.instance;

  Future getData() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user.email;
      final aa = await Firestore.instance
          .collection('/房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
          .getDocuments();
      items = aa.documents.length;
      print(items);
    }
  }

  @override
  void initState() {
    getData();
    Timer(Duration(seconds: 1), () {
      setState(() {});
    });
    super.initState();
  }

  String value;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        Icon(day ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                      ],
                    )),
              ),
              Expanded(flex: 2, child: Text('價格')),
              Expanded(flex: 2, child: Text('類型'))
            ],
          ),
          SingleChildScrollView(
              child: Container(
                  color: AppConstants.tenantBackColor,
                  height: MediaQuery.of(context).size.height * 0.678,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection(
                              '房客/帳號資料/$loginUser/帳務資料/${DateTime.now().month}月')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        {
                          final data = snapshot.data.documents;
                          print(data);
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: items,
                              itemBuilder: (context, index) => Container(
                                    color: index.isEven
                                        ? Colors.green[50]
                                        : Colors.white,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height:
                                        MediaQuery.of(context).size.height / 10,
                                    child: OutlineButton(
                                      splashColor: Colors.blueGrey[100],
                                      onPressed: () {},
                                      child: Card(
                                        margin: EdgeInsets.all(0.0),
                                        elevation: 0.0,
                                        color: index.isEven
                                            ? Colors.green[50]
                                            : Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 2,
                                                child:
                                                    Text(data[index]['購買時間'])),
                                            Expanded(
                                              flex: 2,
                                              child: Text(data[index]['總價']),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(data[index]['類型']),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        }
                      })))
        ],
      ),
    );
  }
}

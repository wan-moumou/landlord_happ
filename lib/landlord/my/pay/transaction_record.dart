import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:landlord_happy/app_const/Adapt.dart';
import 'package:landlord_happy/app_const/app_const.dart';
import 'package:landlord_happy/landlord/my/pay/pay.dart';

class TransactionRecord extends StatefulWidget {
  final loginUser;

  TransactionRecord({
    this.loginUser,
  });

  @override
  _TransactionRecordState createState() => _TransactionRecordState();
}

class _TransactionRecordState extends State<TransactionRecord> {
  int items;
  var data;

  Future getItems() async {
    final aa = await Firestore.instance
        .collection('房東/帳號資料/${widget.loginUser}/帳務資料/交易紀錄')
        .getDocuments();
    items = aa.documents.length;
    data = aa.documents;
    print(items);

    setState(() {});
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('交易紀錄'),
        backgroundColor: AppConstants.appBarAndFontColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(right: 15,left: 15,bottom: 15),
              color: Color(0xFF1E3C6E),
              child: Container(
                height: Adapt.px(200),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '可用點數',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Adapt.px(40),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      Icons.fiber_smart_record,
                      color: Colors.white,
                      size: Adapt.px(70),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection('/房東/帳號資料/${widget.loginUser}')
                            .document('資料')
                            .snapshots(),
                        builder: (context, snapshot) {
                          final data = snapshot.data;
                          return Text(
                            data['剩餘點數'],
                            style: TextStyle(
                                fontSize: Adapt.px(60), color: Colors.white),
                          );
                        }),
                    FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pay(
                                        loginUser: widget.loginUser,
                                      )));
                        },
                        child: Text(
                          '立即儲值',
                          style: TextStyle(
                            fontSize: Adapt.px(40),
                            color: Color(0xFF1E3C6E),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Card(margin: EdgeInsets.only(right: 15,left: 15),
              child: ListTile(
                leading: Text('購買時間'),
                title: Text('購買點數'),
                trailing: Text('購買價格'),
              ),
            ),
            items == null
                ? Container()
                : Container(height: MediaQuery.of(context).size.height*.63,margin: EdgeInsets.only(right: 13,left: 13),
                  child: Card(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items,
                          itemBuilder: (context, index) => ListTile(
                                leading: Text(data[index]['購買時間']),
                            title: Text(data[index]['購買點數']),
                            trailing: Text("NT.${data[index]['總價']}"),
                              ))),
                )
          ],
        ),
      ),
    );
  }
}

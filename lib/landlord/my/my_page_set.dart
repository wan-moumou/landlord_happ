import 'package:flutter/material.dart';

class MyPageSet {
  void trySubmit() {
    formKey.currentState.validate();
  }

  void trySubmit1() {
    formKey1.currentState.validate();
  }

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  //常見問題
  void commonProblem(BuildContext context) {
    bool q1 = false;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('常見問題'),
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
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            q1 = !q1;
                          });
                        },
                        child: Text('如何繳費？'),
                      ),
                      q1
                          ? Text(
                              '掏出錢拿去繳就是了！',
                              style: TextStyle(fontSize: 12),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  //分享
  void shareIt(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('分享'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            elevation: 4,
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＬＩＮＥ'),
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＦＢ'),
                        color: Colors.blueAccent,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text('分享至ＩＧ'),
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                )),
              );
            }),
          );
        });
  }

  //關於
  void aboutUs(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('關於我們'),
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
                  child: Text('''公司簡介 Company
圖文編輯器，內容可自行編輯-我們是一間深根於在地的企業，秉持著專業技術、服務熱誠與優質開發為原則，用心為您做最好的服務。我們希望帶給客戶誠實可靠，工作認真有效率並負責的企業形象，提供最好的產品與專業的服務品質。
 
我們致力於推出最專業的產品服務，並投注心力在開發上，以達到企業與客戶彼此都有最好的感受與成效，這是我們所重視的專業。用心的服務，負責任的態度，是我們的宗旨。我們的產品或服務是您可以放心的項目，使我們成為您可以信賴的商業夥伴。我們重視誠信，言出必行。
合作雙方互惠是我們努力發展的基礎，期待與貴公司有長久互相信賴的合作關係。

選擇我們，是您明智的選擇。999999
'''),
                ),
              );
            }),
          );
        });
  }
}

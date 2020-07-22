import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  AppBarText({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ));
  }
}

class AccountPageListViewTile extends StatelessWidget {
  final IconData icon;

  final String text;

  AccountPageListViewTile({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        text,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
        textAlign: TextAlign.start,
      ),
      leading: Icon(
        icon,
        size: 30.0,
      ),
    );
  }
}

class MyPageCard extends StatelessWidget {
  final IconData icon;
  final String text;

  MyPageCard({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 30,
          ),
          Text(text)
        ],
      ),
    );
  }
}

class ViewData extends StatelessWidget {
  final String title;
  final String title2;

  ViewData({
    Key key,
    this.title,
    this.title2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            "$title:\n$title2",
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      ),
    );
  }
}

class DetailsData extends StatelessWidget {
  DetailsData({@required this.tick, @required this.text});

  final int text;
  final bool tick;

  final List<String> houseDetails = [
    '桌子',
    '椅子',
    '衣櫃',
    '床',
    '熱水器',
    '瓦斯',
    '電視',
    '冰箱',
    '冷氣',
    '洗衣',
    '第四台',
    '養寵物',
    '對講機',
    '開伙',
    '車位',
    '沙發',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      child: CheckboxListTile(
        onChanged: (_) {},
        value: tick,
        title: Text(houseDetails[text]),
      ),
    );
  }
}

//收支明細排序模組
class IncomeAndExpensesListTitle extends StatefulWidget {
  final int index;

  IncomeAndExpensesListTitle(this.index);

  @override
  _IncomeAndExpensesListTitleState createState() =>
      _IncomeAndExpensesListTitleState();
}

class _IncomeAndExpensesListTitleState
    extends State<IncomeAndExpensesListTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index.isEven ? Color(0xFFF2F6FF) : Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height / 10,
      child: OutlineButton(
        splashColor: Colors.blueGrey[100],
        onPressed: () {},
        child: Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          color: widget.index.isEven ? Color(0xFFF2F6FF) : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 2, child: Text('2012/10/10')),
              Expanded(flex: 2, child: Text('王大大')),
              Expanded(
                flex: 3,
                child: Text('水費 3000'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//房客
class TenantIncomeAndExpensesListTitle extends StatefulWidget {
  final int index;
  final String type;
  final buyNum;
  final totalPrice;
  final time;

  TenantIncomeAndExpensesListTitle({this.index, this.totalPrice,
      this.buyNum, this.type, this.time});

  @override
  _TenantIncomeAndExpensesListTitleState createState() =>
      _TenantIncomeAndExpensesListTitleState();
}

class _TenantIncomeAndExpensesListTitleState
    extends State<TenantIncomeAndExpensesListTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index.isEven ? Colors.green[50] : Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height / 10,
      child: OutlineButton(
        splashColor: Colors.blueGrey[100],
        onPressed: () {},
        child: Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          color: widget.index.isEven ? Colors.green[50] : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 2, child: Text(widget.time)),
              Expanded(
                flex: 3,
                child: Text(widget.totalPrice),
              ),
              Expanded(
                flex: 3,
                child: Text(widget.type),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//收支明細模組
class IAEDownButton extends StatefulWidget {
  @override
  _IAEDownButtonState createState() => _IAEDownButtonState();
}

class _IAEDownButtonState extends State<IAEDownButton> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem(
          child: Text(
            "房租",
            style: TextStyle(
                fontWeight: _value == '1' ? FontWeight.bold : FontWeight.normal,
                color: _value == "1" ? Color(0xFF779FA2) : Colors.grey),
          ),
          value: "1",
        ),
        DropdownMenuItem(
          child: Text(
            "水電費",
            style: TextStyle(
                fontWeight: _value == '2' ? FontWeight.bold : FontWeight.normal,
                color: _value == "2" ? Color(0xFF779FA2) : Colors.grey),
          ),
          value: "2",
        ),
        DropdownMenuItem(
          child: Text(
            "其他收入",
            style: TextStyle(
                fontWeight: _value == '3' ? FontWeight.bold : FontWeight.normal,
                color: _value == "3" ? Color(0xFF779FA2) : Colors.grey),
          ),
          value: "3",
        ),
        DropdownMenuItem(
          child: Text(
            "修繕支出",
            style: TextStyle(
                fontWeight: _value == '4' ? FontWeight.bold : FontWeight.normal,
                color: _value == "4" ? Colors.red : Colors.grey),
          ),
          value: "4",
        ),
        DropdownMenuItem(
          child: Text(
            "水電支出",
            style: TextStyle(
                fontWeight: _value == '5' ? FontWeight.bold : FontWeight.normal,
                color: _value == "5" ? Colors.red : Colors.grey),
          ),
          value: "5",
        ),
        DropdownMenuItem(
          child: Text(
            "其他支出",
            style: TextStyle(
                fontWeight: _value == '6' ? FontWeight.bold : FontWeight.normal,
                color: _value == "6" ? Colors.red : Colors.grey),
          ),
          value: "6",
        ),
      ],
      hint: Text("點擊搜尋"),
      // 当没有初始值时显示
      onChanged: (selectValue) {
        //选中后的回调
        setState(() {
          _value = selectValue;
        });
      },
      value: _value,
      // 设置初始值，要与列表中的value是相同的
      elevation: 10,
      //设置阴影
      style: TextStyle(
          //设置文本框里面文字的样式
          color: Colors.blue,
          fontSize: 15),
      iconSize: 30,
      //设置三角标icon的大小
      underline: Container(
        height: 0,
        color: Colors.blue,
      ), // 下划线
    );
  }
}

//房客
class TenantIAEDownButton extends StatefulWidget {
  @override
  _TenantIAEDownButtonState createState() => _TenantIAEDownButtonState();
}

class _TenantIAEDownButtonState extends State<TenantIAEDownButton> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem(
          child: Text(
            "房租",
            style: TextStyle(
                fontWeight: _value == "1" ? FontWeight.bold : FontWeight.normal,
                color: _value == "1" ? Colors.red : Colors.grey),
          ),
          value: "1",
        ),
        DropdownMenuItem(
          child: Text(
            "水費儲值",
            style: TextStyle(
                fontWeight: _value == '2' ? FontWeight.bold : FontWeight.normal,
                color: _value == "2" ? Colors.red : Colors.grey),
          ),
          value: "2",
        ),
        DropdownMenuItem(
          child: Text(
            "電費儲值",
            style: TextStyle(
                fontWeight: _value == '3' ? FontWeight.bold : FontWeight.normal,
                color: _value == "3" ? Colors.red : Colors.grey),
          ),
          value: "3",
        ),
      ],
      hint: Text("點擊搜尋"),
      // 当没有初始值时显示
      onChanged: (selectValue) {
        //选中后的回调
        setState(() {
          _value = selectValue;
        });
      },
      value: _value,
      // 设置初始值，要与列表中的value是相同的
      elevation: 10,
      //设置阴影
    );
  }
}

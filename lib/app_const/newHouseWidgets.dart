import 'package:flutter/material.dart';


class MyCheckBoxData extends StatefulWidget {
  final Widget checkboxListTile;
  MyCheckBoxData({this.checkboxListTile});

  @override
  _MyCheckBoxDataState createState() => _MyCheckBoxDataState();
}

class _MyCheckBoxDataState extends State<MyCheckBoxData> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: widget.checkboxListTile);
  }
}

class MessageData {
  Map<String, dynamic> returnType = {'回報類型': '請選擇', '聯絡房客': '選擇房間名稱'};
  List<Map<String, dynamic>> returnTypeList = [
    {'回報類型': '請選擇'},
    {'回報類型': '修繕'},
    {'回報類型': '簽約'},
    {'回報類型': '其他'},
  ];
  final List<Map<String, dynamic>> roomName = [
    {'聯絡房客': '選擇房間名稱'},
  ];
}

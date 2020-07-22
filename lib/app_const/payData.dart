class PayData {
  String payTypeView = '';
  String paymentInformationView = '請選擇';
  Map<String, dynamic> data = {
    '繳費方式': '請選擇',
    '付款資訊': '請選擇',
    '有效月': '請選擇',
    '有效年': '請選擇',
  };
  List<Map<String, dynamic>> payType = [
    {'繳費方式': '請選擇'},
    {'繳費方式': '超商繳費'},
    {'繳費方式': '信用卡'},
    {'繳費方式': 'ATM'},
  ];
  List<Map<String, dynamic>> paymentInformation = [
    {'付款資訊': '請選擇'},
    {'付款資訊': '個人發票'},
    {'付款資訊': '捐贈'},
    {'付款資訊': '統一編號'},
    {'付款資訊': '自然人憑證'},
  ];

}

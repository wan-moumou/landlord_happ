import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:landlord_happy/main.dart';

class HttpPost {
  final eNCKey = 'kLdmkllCE1tTOzVxz9ySpab7KxsPk5xe';
  final iV = 'C5OUvhMwKJEbefIP';
  final merchantID = 'MerchantID=MS312657815&';
  final respondType = 'RespondType=JSON&';
  final timeStamp = 'TimeStamp=${DateTime.now().millisecondsSinceEpoch}&';
  final notifyURL = 'NotifyURL=https://hitcolife.duckdns.org/notify/store&';

//  final clientBackURL = 'https://landlord-75337.firebaseio.com&';
  final version = 'Version=1.5&';
  final langType = 'LangType=zh-tw&';
  final merchantOrderNo = 'MerchantOrderNo=S_20200731_00035&';
  final amt = 'Amt=999&';
  final itemDesc = 'ItemDesc=租屋付款測試&';
  final email = 'Email=b34866575@gmail.com&';
  final cvs = 'CVS=1';
  var uri;

  void postData(itemDesc, cvs, email, amt, merchantOrderNo,eleMoney,waterMoney,rent,) {
    Map data = {
      "itemDesc": itemDesc,
      "付款方式": cvs,
      "email": email,
      "amt": amt,
      "merchantOrderNo": merchantOrderNo,
      'merchantID': merchantID,
      'respondType': respondType,
      'timeStamp':timeStamp,
      'notifyURL':notifyURL,
      'version':version,
      'langType':langType,
//      'WaterFee':waterMoney,
//      'ElectricFee':eleMoney,
//      'rentFee':rent,
    };
//    post('http://hitcolife.duckdns.org/notify/paysucess', data);
    print(data);
  }

  void getURI(itemDesc, cvs, email, amt, merchantOrderNo) {
    uri = merchantID +
        respondType +
        timeStamp +
        notifyURL +
        version +
        langType +
        merchantOrderNo +
        amt +
        itemDesc +
        email +
        cvs;
    print(uri);
    var encoded = Uri.encodeFull(uri);
    encrypt(iV, eNCKey, encoded);
  }

  void encrypt(iv1, key, uri) {
    final plainText = uri;

    final key = Key.fromUtf8(eNCKey);
    final iv = IV.fromUtf8(iv1);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted.base16);
    var bytes = utf8.encode(
        'HashKey=$eNCKey&${encrypted.base16}&HashIV=$iV'); // data being hashed
    var digest = sha256.convert(bytes);

    print(digest.toString().toUpperCase());
    post("https://ccore.newebpay.com/MPG/mpg_gateway",uri);
  }

  var asd;

  void post(url, body) async {
    var params = body;
    var client = http.Client();
    var response = await client
        .post(url, body: params);
    asd = response.body;
    print(asd);
  }
}

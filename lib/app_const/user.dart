import 'package:firebase_auth/firebase_auth.dart';

class User {
  FirebaseUser user;
  String name ;
  String password;
  String phoneNumber;
  String address ;
  String url;
  User(
      {this.url,
      this.user,
      this.name,
      this.address,
      this.password,
      this.phoneNumber});
}

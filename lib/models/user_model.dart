import 'dart:io';

class UserModel {
  String uid;
  String displayName;
  String email;
  String phoneNumber;
  String password;
  String photoUrl;
  String tokenId;
  int status;
  File file;
  String identify;

  UserModel(
      {this.uid,
      this.displayName,
      this.email,
      this.phoneNumber,
      this.password,
      this.photoUrl,
      this.tokenId,
      this.status,
      this.file,
      this.identify});

  Map<String, dynamic> toMapRegister() {
    return {
      'fullname': displayName,
      'email': email,
      'phone': phoneNumber,
      'password': password,
    };
  }

  Map<String, dynamic> toMapLogin() {
    return {
      'identify': identify,
      'password': password,
    };
  }
}

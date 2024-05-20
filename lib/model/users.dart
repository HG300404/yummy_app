import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String user_id;
  final String username;
  final String ? password;
  final String email;
  final String ? phone;
  final String ? address;
  final int type;
  final String ? imageURL;
  final int level;
  final int coin;
  final String createdAt;
  final String updatedAt;

  const Users(
   {
     required this.user_id,
     required this.username,
      this.password,
     required this.email,
      this.phone,
      this.address,
     required this.type,
      this.imageURL,
     required this.level,
     required this.coin,
     required this.createdAt,
     required this.updatedAt,
  });

  // Chuyển đổi đối tượng Task thành Map
  Map<String, Object?> toMap() {
    return {
      'user_id': user_id,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'address': address,
      'type': type,
      'imageURL': imageURL,
      'level': level,
      'coin': coin,
      'createdAt': createdAt,
      'updatedAt': updatedAt};
  }

  // Tạo đối tượng Task từ Map
  Users.fromMap(Map<String, dynamic> map)
      : user_id = map['id'],
        username = map['username'],
        password = map['password'],
        email = map['email'],
        phone = map['phone'],
        address = map['address'],
        type = map['type'],
        imageURL = map['imageURL'],
        level = map['level'],
        coin = map['coin'],
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'];

}
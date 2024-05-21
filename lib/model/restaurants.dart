import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurants {
  final int id;
  final String? name; // Khai báo nullable
  final String? address; // Khai báo nullable
  final String? phone; // Khai báo nullable
  final String? opening_hours; // Khai báo nullable
  final Timestamp? created_at; // Khai báo nullable
  final Timestamp? updated_at; // Khai báo nullable


  const Restaurants(
      {
        required this.id,
        this.name,
        this.address,
        this.phone,
        this.opening_hours,
        this.created_at,
        this.updated_at,
      });

  // Chuyển đổi đối tượng Task thành Map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'opening_hours': opening_hours,
      'created_at': created_at,
      'updated_at': updated_at};
  }


  Restaurants.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'] ?? '',
        address = map['address'] ?? '',
        phone = map['phone'] ?? '',
        opening_hours = map['opening_hours'] ?? '',
        created_at = (map['created_at'] != null) ? Timestamp.fromDate(DateTime.parse(map['created_at'])) : null,
        updated_at = (map['updated_at'] != null) ? Timestamp.fromDate(DateTime.parse(map['updated_at'])) : null;

  @override
  String toString() {
    return 'Restaurants {id: $id, name: $name, address: $address, phone: $phone, opening_hours: $opening_hours, created_at: $created_at, updated_at: $updated_at}';
  }
}
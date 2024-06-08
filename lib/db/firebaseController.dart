import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../model/firebaseModel.dart';

class FirebaseController {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference firebaseModelRef;

  FirebaseController(){
    firebaseModelRef = _firestore.collection('wait');
  }

  Stream<List<FirebaseModel>> getAll(int customerId) {
    return firebaseModelRef.where('customer.cus_id', isEqualTo: customerId).snapshots()
        .map((snapshot) => snapshot.docs)
        .map((docs) {
      try {
        return docs.map((doc) => FirebaseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
      } catch(e) {
        print('Error converting FirebaseModel: $e');
        return [];
      }
    });
  }
}
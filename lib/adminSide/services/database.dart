import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference myModernSocietyCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUserData(String name, String email, String cnic, String address) async {
    return await myModernSocietyCollection.doc(uid).set({
      'name': name,
      'email': email,
      'cnic': cnic,
      'address': address,
    });
  }

  Future<void> updateUserData(String name, String email, String location) async {
    return await myModernSocietyCollection.doc(uid).update({
      'name': name,
      'email': email,
      'location': location,
    });
  }


}
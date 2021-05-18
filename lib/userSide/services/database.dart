import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference myModernSocietyCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUserData(String uid, String name, String? gender, String email, String cnic, String house, String street, String sector) async {
    return await myModernSocietyCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
      'cnic': cnic,
      'address': 'House# $house, Street# $street, Sector $sector',
      'isApproved': false, 
      'timestamp': DateTime.now(),
    });
  }

  Future<void> updateUserData(String name, String address) async {
    return await myModernSocietyCollection.doc(uid).update({
      'name': name,
      'address': address,
    });
  }

  Future<void> registerComplaint(String? name, String? address, String? subject, String details) async {
    return await FirebaseFirestore.instance.collection('complaints').doc(uid).set({
      'uid': uid,
      'resolved': false,
      'name': name,
      'address': address,
      'subject': subject,
      'details': details,
      'timestamp': DateTime.now(),
      'resolvedDate': DateTime.now(),
    });
  }

  Future<void> sendAlertData(String? name, String? address, String type) async {
    return await FirebaseFirestore.instance.collection('alerts').doc(uid).set({
      'uid': uid,
      'name': name,
      'address': address,
      'type': type,
      'resolved': false,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> sendFeedbackData(String? name, String? email, String feedback) async {
    return await FirebaseFirestore.instance.collection('feedback').doc(uid).set({
      'name': name,
      'email': email,
      'feedback': feedback,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> sendExperienceData(String? name, String? email, String experience) async {
    return await FirebaseFirestore.instance.collection('appExperience').doc(uid).set({
      'name': name,
      'email': email,
      'experience': experience,
      'timestamp': DateTime.now(),
    });
  }


}
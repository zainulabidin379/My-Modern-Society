import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../services/auth.dart';
import '../shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RateExperience extends StatefulWidget {
  @override
  _RateExperienceState createState() => _RateExperienceState();
}

class _RateExperienceState extends State<RateExperience> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('Rate Your Experience'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kGreen,
        //Back Button
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: size.height * 0.35,
            width: size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 70,
                      width: 70,
                      child: Image.asset(
                        'assets/icons/heart.png',
                        color: kGreen,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                          text: 'Thank you for using',
                          style: kBodyText.copyWith(
                            color: kBlack,
                            fontSize: 20,
                          ),
                          children: [
                            TextSpan(
                              text: 'My Modern Society',
                              style: kBodyText.copyWith(
                                  color: kGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                ]),
          ),
          Container(
            height: size.height * 0.55,
            width: size.width,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'How was your experience with My Modern Society',
                      style: kBodyText.copyWith(
                          color: kBlack,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var firestore = FirebaseFirestore.instance;
                          DocumentSnapshot qn = await firestore
                              .collection('users')
                              .doc(_auth.getCurrentUser())
                              .get();
                          await DatabaseService(uid: _auth.getCurrentUser())
                              .sendExperienceData(
                                  qn['name'], qn['email'], 'Bad');
                          Navigator.pop(context);
                          Get.snackbar(
                            'Thank You for your kind feedback',
                            'We will keep improving your experience at My Modern Society',
                            duration: Duration(seconds: 5),
                            backgroundColor: kBlack,
                            colorText: kWhite,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 0,
                            margin: EdgeInsets.all(0),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/icons/bad.png',
                                  color: kGreen,
                                )),
                            SizedBox(height: 10),
                            Text(
                              'Bad',
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);

                          Get.snackbar(
                            'Thank You for your kind feedback',
                            'We will keep improving your experience at My Modern Society',
                            duration: Duration(seconds: 5),
                            backgroundColor: kBlack,
                            colorText: kWhite,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 0,
                            margin: EdgeInsets.all(0),
                          );
                          var firestore = FirebaseFirestore.instance;
                          DocumentSnapshot qn = await firestore
                              .collection('users')
                              .doc(_auth.getCurrentUser())
                              .get();
                          await DatabaseService(uid: _auth.getCurrentUser())
                              .sendExperienceData(
                                  qn['name'], qn['email'], 'Average');
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/icons/average.png',
                                  color: kGreen,
                                )),
                            SizedBox(height: 10),
                            Text(
                              'Average',
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          var firestore = FirebaseFirestore.instance;
                          DocumentSnapshot qn = await firestore
                              .collection('users')
                              .doc(_auth.getCurrentUser())
                              .get();
                          await DatabaseService(uid: _auth.getCurrentUser())
                              .sendExperienceData(
                                  qn['name'], qn['email'], 'Good');
                          Navigator.pop(context);
                          Get.snackbar(
                            'Thank You for your kind feedback',
                            'We will keep improving your experience at My Modern Society',
                            duration: Duration(seconds: 5),
                            backgroundColor: kBlack,
                            colorText: kWhite,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 0,
                            margin: EdgeInsets.all(0),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/icons/good.png',
                                  color: kGreen,
                                )),
                            SizedBox(height: 10),
                            Text(
                              'Good',
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var firestore = FirebaseFirestore.instance;
                          DocumentSnapshot qn = await firestore
                              .collection('users')
                              .doc(_auth.getCurrentUser())
                              .get();
                          await DatabaseService(uid: _auth.getCurrentUser())
                              .sendExperienceData(
                                  qn['name'], qn['email'], 'Very Good');
                          Navigator.pop(context);
                          Get.snackbar(
                            'Thank You for your kind feedback',
                            'We will keep improving your experience at My Modern Society',
                            duration: Duration(seconds: 5),
                            backgroundColor: kBlack,
                            colorText: kWhite,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 0,
                            margin: EdgeInsets.all(0),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/icons/veryGood.png',
                                  color: kGreen,
                                )),
                            SizedBox(height: 10),
                            Text(
                              'Very Good',
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          var firestore = FirebaseFirestore.instance;
                          DocumentSnapshot qn = await firestore
                              .collection('users')
                              .doc(_auth.getCurrentUser())
                              .get();
                          await DatabaseService(uid: _auth.getCurrentUser())
                              .sendExperienceData(
                                  qn['name'], qn['email'], 'Awesome');

                          var id = Uuid().v4();
                          FirebaseFirestore.instance
                              .collection('adminNotifications')
                              .doc(id)
                              .set({
                                "id": id,
                                "timestamp": DateTime.now(),
                                "isRead": false,
                                "notification":
                                    'A New app experience recieved from ${qn['name']}',
                              })
                              .then((_) {})
                              .catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                          Navigator.pop(context);
                          Get.snackbar(
                            'Thank You for your kind feedback',
                            'We will keep improving your experience at My Modern Society',
                            duration: Duration(seconds: 5),
                            backgroundColor: kBlack,
                            colorText: kWhite,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 0,
                            margin: EdgeInsets.all(0),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/icons/awesome.png',
                                  color: kGreen,
                                )),
                            SizedBox(height: 10),
                            Text(
                              'Awesome',
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ],
      )),
    );
  }
}

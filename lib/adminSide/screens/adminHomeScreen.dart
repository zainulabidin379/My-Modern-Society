import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'screens.dart';
import 'package:get/get.dart';
import '../shared/constants.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthService _auth = AuthService();
  String? admin;
  bool newNotification = false;

  newNotificationCheck() async {
    await FirebaseFirestore.instance
        .collection('adminNotifications')
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['isRead'] == true) {
          setState(() {
            newNotification = false;
          });
        } else if (value.docs[i]['isRead'] == false) {
          setState(() {
            newNotification = true;
          });
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    newNotificationCheck();
    String uid = _auth.getCurrentUser();
    if (uid == 'SUj5uhm9jDX3EqRVW5uxDu5rWph1') {
      setState(() {
        admin = 'Admin';
      });
    } else {
      setState(() {
        admin = 'Co-Admin';
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No', style: TextStyle(color: kGreen)),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes', style: TextStyle(color: kBlack)),
              ),
            ],
          ),
        ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          elevation: 0,
          title: Text('Control Panel ($admin)'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kGreen,
          //notification Icon
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                Get.to(() => Notifications())!.then((_) {
                  setState(() {
                    newNotificationCheck();
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        child: Icon(
                      FontAwesomeIcons.bell,
                      size: 27,
                    )),
                    newNotification
                        ? Positioned(
                            top: 15,
                            right: 0,
                            child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                )),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: size.height * 0.2,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/adBanner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //1ST ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.to(() => Vendors())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/vendors.png',
                        'Service Providers'),
                    menuCard(
                        size,
                        () => {
                              Get.to(() => ComplaintsScreen())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/complaints.png',
                        'Complaints'),
                  ],
                ),
                //2ND ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.to(() => NoticeBoard())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/notice.png',
                        'Notice Board'),
                    menuCard(
                        size,
                        () => {
                              Get.to(() => Gallery())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/gallery.png',
                        'Gallery'),
                  ],
                ),
                //3RD ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.to(() => Events())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/events.png',
                        'Events'),
                    menuCard(
                        size,
                        () => {
                              Get.to(() => SocietyRules())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/rules.png',
                        'Society Rules'),
                  ],
                ),
                //4th ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(size, () {
                      Get.to(() => Alerts())!.then((_) {
                        setState(() {
                          newNotificationCheck();
                        });
                      });
                    }, 'assets/icons/alerts.png', 'Alerts'),
                    menuCard(
                        size,
                        () => {
                              Get.to(() => UsersScreen())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/approve.png',
                        'Approve Users'),
                  ],
                ),
                //5th ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.to(() => PickAndDrop())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/pickAndDrop.png',
                        'Pick and Drop'),
                    menuCard(
                        size,
                        () => {
                              Get.to(() => FeedbackScreen())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/feedback.png',
                        'Feedback'),
                  ],
                ),
                //6th ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.to(() => Directory())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/directory.png',
                        'Directory'),
                    menuCard(
                        size,
                        () => {
                              Get.to(() => AdsScreen())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              })
                            },
                        'assets/icons/ads.png',
                        'Manage Ads'),
                  ],
                ),
                //7th ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.to(() => MainPlaces())!.then((_) {
                                setState(() {
                                  newNotificationCheck();
                                });
                              }),
                            },
                        'assets/icons/places.png',
                        'Main Places'),
                    menuCard(size, () async {
                      Get.to(() => AdminSetting())!.then((_) {
                        setState(() {
                          newNotificationCheck();
                        });
                      });
                    }, 'assets/icons/admin.png', 'Admin Settings'),
                  ],
                ),
                //8th ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard(
                        size,
                        () => {
                              Get.snackbar(
                                'Message',
                                'This function is not yet implemented',
                                duration: Duration(seconds: 3),
                                backgroundColor: kBg,
                                colorText: kBlack,
                                borderRadius: 10,
                              )
                            },
                        'assets/icons/polling.png',
                        'Polls'),
                    menuCard(
                        size,
                        () => {
                              Get.snackbar(
                                'Message',
                                'This function is not yet implemented',
                                duration: Duration(seconds: 3),
                                backgroundColor: kBg,
                                colorText: kBlack,
                                borderRadius: 10,
                              ),
                            },
                        'assets/icons/discussion.png',
                        'Discussion'),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget menuCard(Size size, Function onTap, String icon, String name) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          height: size.width * 0.45,
          width: size.width * 0.45,
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: size.width * 0.15,
                      child: Image.asset(
                        icon,
                        color: kGreen,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: Text(name,
                          style: kBodyText.copyWith(
                              color: kBlack, fontSize: size.width * 0.04))),
                ]),
          ),
        ),
      ),
    );
  }
}

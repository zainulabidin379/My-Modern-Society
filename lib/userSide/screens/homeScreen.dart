import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'screens.dart';
import 'package:get/get.dart';
import '../shared/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  Future getAds() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('ads').get();
    return qn.docs;
  }

  //Function to manage exit app button
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

  bool newNotification = false;
  bool approved = false;

  newNotificationCheck() async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc('notificationsDoc')
        .collection(_auth.getCurrentUser())
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['isRead'] == true) {
          setState(() {
            newNotification = false;
            print("::: Notification false");
          });
        } else if (value.docs[i]['isRead'] == false) {
          setState(() {
            newNotification = true;
            print("::: Notification true");
          });
          break;
        }
      }
    });
  }

  approvalCheck() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.getCurrentUser())
        .get()
        .then((value) {
      if (value['isApproved'] == true) {
        setState(() {
          approved = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newNotificationCheck();
    approvalCheck();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kBg,
        //AppBar
        appBar: AppBar(
          elevation: 0,
          title: Text('My Modern Society'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kGreen,
          //Menu Button
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  'assets/icons/menu.jpg',
                  color: kWhite,
                  height: 5,
                  width: 5,
                ),
              ),
            ),
          ),
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
        drawer: NavDrawer(),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top Banner
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
                //Main Categories
                Container(
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Vendors'),
                          menuCard(
                              size,
                              () => {
                                    if (approved)
                                      {
                                        Get.to(() => Complaints())!.then((_) {
                                          setState(() {
                                            newNotificationCheck();
                                          });
                                        }),
                                      }
                                    else
                                      {
                                        Get.snackbar(
                                          'Restricted',
                                          'This function is not available for you yet, please wait for your account approval.',
                                          duration: Duration(seconds: 6),
                                          backgroundColor: kBg,
                                          colorText: Colors.red,
                                          borderRadius: 10,
                                        ),
                                      }
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
                                    if (approved)
                                      {
                                        Get.to(() => Alerts())!.then((_) {
                                          setState(() {
                                            newNotificationCheck();
                                          });
                                        }),
                                      }
                                    else
                                      {
                                        Get.snackbar(
                                          'Restricted',
                                          'This function is not available for you yet, please wait for your account approval.',
                                          duration: Duration(seconds: 6),
                                          backgroundColor: kBg,
                                          colorText: Colors.red,
                                          borderRadius: 10,
                                        ),
                                      }
                                  },
                              'assets/icons/alerts.png',
                              'Send Alerts'),
                        ],
                      ),
                      //Ads Container
                      Container(
                        width: size.width,
                        height: 200,
                        child: FutureBuilder<dynamic>(
                            future: getAds(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SpinKitFadingCircle(color: kGreen),
                                );
                              } else {
                                return PageView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (var i = 0;
                                        i < snapshot.data.length;
                                        i++)
                                      buildAd(snapshot.data[i]['url']),
                                  ],
                                );
                              }
                            }),
                      ),
                      //4th ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                    if (approved)
                                      {
                                        Get.to(() => FeedbackScreen())!
                                            .then((_) {
                                          setState(() {
                                            newNotificationCheck();
                                          });
                                        }),
                                      }
                                    else
                                      {
                                        Get.snackbar(
                                          'Restricted',
                                          'This function is not available for you yet, please wait for your account approval.',
                                          duration: Duration(seconds: 6),
                                          backgroundColor: kBg,
                                          colorText: Colors.red,
                                          borderRadius: 10,
                                        ),
                                      }
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
                                    Get.to(() => MainPlaces())!.then((_) {
                                      setState(() {
                                        newNotificationCheck();
                                      });
                                    }),
                                  },
                              'assets/icons/places.png',
                              'Main Places'),
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
                      //7th ROW
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
                                    ),
                                  },
                              'assets/icons/polling.png',
                              'Polls'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
    );
  }

  //Categories Card
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
                              color: kBlack, fontSize: size.width * 0.05))),
                ]),
          ),
        ),
      ),
    );
  }

  //Ad Widget
  Widget buildAd(String image) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
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
            ],
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

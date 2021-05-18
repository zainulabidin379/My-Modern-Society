import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../screens/screens.dart';
import '../services/services.dart';

import 'constants.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final AuthService _auth = AuthService();
  Future getUser() async {
    var currentUser = _auth.getCurrentUser();
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(currentUser).get();

    // setState(() {
    //   isActivated = snapshot.data['isVerified'];
    // });
    return snapshot;
  }

  bool isActivated = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<dynamic>(
                    future: getUser(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                  height: size.height * 0.09,
                                  width: size.height * 0.09,
                                  child: CircleAvatar(
                                    backgroundColor: kGreen,
                                  )),
                            ),
                            Row(
                              children: [
                                Text(
                                  '',
                                  style: kBodyText.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              '',
                              style: kBodyText.copyWith(fontSize: 15),
                            )
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            snapshot.data['isApproved']
                                ? Get.snackbar(
                                    'Congratulations!',
                                    'Your Account is approved.',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: kGreen,
                                    borderRadius: 10,
                                  )
                                : Get.snackbar(
                                    'Sorry!',
                                    'Your Account is not approved yet.',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: Colors.red,
                                    borderRadius: 10,
                                  );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    height: size.height * 0.09,
                                    width: size.height * 0.09,
                                    child: CircleAvatar(
                                      backgroundColor: kWhite,
                                      backgroundImage: (snapshot
                                                  .data['gender'] ==
                                              'male')
                                          ? AssetImage('assets/images/male.png')
                                          : AssetImage(
                                              'assets/images/female.png'),
                                    )),
                              ),
                              Row(
                                children: [
                                  Text(
                                    snapshot.data['name'],
                                    style: kBodyText.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10),
                                  snapshot.data['isApproved']
                                      ? Icon(FontAwesomeIcons.solidCheckCircle,
                                          color: kWhite, size: 20)
                                      : Icon(FontAwesomeIcons.solidTimesCircle,
                                          color: Colors.redAccent, size: 20),
                                ],
                              ),
                              Text(
                                snapshot.data['email'],
                                style: kBodyText.copyWith(fontSize: 15),
                              )
                            ],
                          ),
                        );
                      }
                    }),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.home,
              color: kGreen,
              size: 25,
            ),
            title: Text('Home',
                style: kBodyText.copyWith(
                    fontWeight: FontWeight.bold, color: kGreen)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.userAlt,
              color: kGreen,
              size: 25,
            ),
            title: Text('My Account', style: kBodyText.copyWith(color: kBlack)),
            onTap: () => {Get.to(()=> MyAccount())},
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.users,
              color: kGreen,
              size: 25,
            ),
            title: Text('About Us', style: kBodyText.copyWith(color: kBlack)),
            onTap: () => {
              Get.to(() => AboutUs()),
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
              color: kGreen,
              size: 25,
            ),
            title: Text('Logout', style: kBodyText.copyWith(color: kBlack)),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              Get.snackbar(
                'Message',
                'Loged Out Successfully',
                duration: Duration(seconds: 3),
                backgroundColor: kBg,
                colorText: kGreen,
                borderRadius: 10,
              );
            },
          ),
        ],
      ),
    );
  }
}

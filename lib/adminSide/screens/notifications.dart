import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../services/auth.dart';
import '../shared/shared.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final AuthService _auth = AuthService();

  var uid;
  @override
  void initState() {
    super.initState();
    uid = _auth.getCurrentUser();
  }

  Future getNotifications() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('adminNotifications')
        .orderBy('timestamp', descending: true)
        .get();

    return qn.docs;
  }

  int notifications = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('Notifications'),
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
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Do you want to clear all notifications?'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: new Text('No', style: TextStyle(color: kGreen)),
                    ),
                    new TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('adminNotifications')
                            .get()
                            .then((snapshot) {
                          for (DocumentSnapshot ds in snapshot.docs) {
                            ds.reference.delete();
                          }
                        }).catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).pop();
                        setState(() {});
                        setState(() {});
                        Get.snackbar(
                          'Notifications Cleared',
                          'All the notifications are cleared!',
                          duration: Duration(seconds: 3),
                          backgroundColor: kBg,
                          colorText: kBlack,
                          borderRadius: 10,
                        );
                        
                      },
                      child:
                          new Text('Clear', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                FontAwesomeIcons.trash,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          FutureBuilder<dynamic>(
              future: getNotifications(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(color: kGreen),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        notificationCard(
                          size,
                          snapshot.data[i]['id'],
                          snapshot.data[i]['notification'],
                          snapshot.data[i]['isRead'],
                          snapshot.data[i]['timestamp'],
                        ),
                      (notifications == 0)
                          ? noNotifications(size, 'No New Notifications')
                          : SizedBox(),
                    ],
                  );
                }
              }),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  //No notifications
  Widget noNotifications(Size size, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Center(
        child: Container(
          height: 60,
          width: size.width * 0.95,
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kGreen, width: 2),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Center(
                child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
          ),
        ),
      ),
    );
  }

  Widget notificationCard(
      Size size, String id, String notification, bool isRead, Timestamp date) {
    notifications++;
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          title: 'Notification Details',
          titleStyle: TextStyle(color: kGreen),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
              Text(notification,
                  textAlign: TextAlign.center,
                  style: kBodyText.copyWith(color: kGrey, fontSize: 18)),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  FirebaseFirestore.instance
                      .collection('adminNotifications')
                      .doc(id)
                      .update({
                        "isRead": true,
                      })
                      .then((_) {})
                      .catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                      });
                  setState(() {});
                },
                child: Container(
                    height: 30,
                    width: size.width,
                    child: Center(
                        child: Text('Mark as Read',
                            style: kBodyText.copyWith(
                                color: kGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)))),
              ),
            ]),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5),
        child: Center(
          child: Container(
            width: size.width * 0.95,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: kGreen),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(notification,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: kBodyText.copyWith(
                                color: kBlack, fontSize: 16)),
                      ),
                      Text('Read',
                          textAlign: TextAlign.center,
                          style: kBodyText.copyWith(
                              color: kGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isRead
                          ? SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, top: 5),
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kGreen,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                        ),
                                        child: Text('New',
                                            style: kBodyText.copyWith(
                                                color: kWhite, fontSize: 12)),
                                      ),
                                    ),
                                  )),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                            DateTimeFormat.format(date.toDate(),
                                format: DateTimeFormats.american),
                            textAlign: TextAlign.left,
                            style: kBodyText.copyWith(
                                color: kGreen, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

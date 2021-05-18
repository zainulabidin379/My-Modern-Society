import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../shared/shared.dart';
import 'screens.dart';

class DisapprovedUsers extends StatefulWidget {
  DisapprovedUsers({Key? key}) : super(key: key);

  @override
  _DisapprovedUsersState createState() => _DisapprovedUsersState();
}

class _DisapprovedUsersState extends State<DisapprovedUsers> {
  Future getUsers() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection('users').orderBy('timestamp').get();

    return qn.docs;
  }

  int disapprovedUsers = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('Disapproved Users'),
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
        child: Column(children: [
          SizedBox(height: 8),
          FutureBuilder<dynamic>(
              future: getUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(color: kGreen),
                  );
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        snapshot.data[i]['isApproved']
                            ? SizedBox()
                            : eventCard(
                                size,
                                snapshot.data[i]['uid'],
                                snapshot.data[i]['name'],
                                snapshot.data[i]['email'],
                                snapshot.data[i]['cnic'],
                                snapshot.data[i]['address'],
                                snapshot.data[i]['gender'],
                                snapshot.data[i]['isApproved'],
                                snapshot.data[i]['timestamp'],
                              ),
                      (disapprovedUsers == 0)
                          ? noUsers(size, 'No Users here!')
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

//No Users
  Widget noUsers(Size size, String name) {
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

  Widget eventCard(
      Size size,
      String? uid,
      String name,
      String email,
      String cnic,
      String address,
      String gender,
      bool? verified,
      Timestamp date) {
    disapprovedUsers++;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text('Are you sure?'),
                    content: new Text('Do you want to approve this user?'),
                    actions: <Widget>[
                      new TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child:
                            new Text('No', style: TextStyle(color: Colors.red)),
                      ),
                      new TextButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .update({
                            'isApproved': true,
                          }).catchError((e) {
                            print(e);
                          });
                          disapprovedUsers--;
                          var id = Uuid().v4();
                          FirebaseFirestore.instance
                              .collection('notifications')
                              .doc('notificationsDoc')
                              .collection(uid!)
                              .doc(id)
                              .set({
                                "id": id,
                                "timestamp": DateTime.now(),
                                "isRead": false,
                                "notification":
                                    'Congratulations! Your Account has been approved.',
                              })
                              .then((_) {})
                              .catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                          Navigator.of(context).pop();
                          setState(() {});
                          Get.snackbar(
                            'Message',
                            'User is approved',
                            duration: Duration(seconds: 3),
                            backgroundColor: kBg,
                            colorText: kBlack,
                            borderRadius: 10,
                          );
                        },
                        child: new Text('Approve',
                            style: TextStyle(color: kGreen)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                height: 50,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.zero,
                    bottomLeft: Radius.zero,
                  ),
                  border: Border.all(width: 2, color: kGreen),
                ),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      color: kWhite,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Approve User',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                )),
              ),
            ),
            Container(
              width: size.width * 0.95,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: Border.all(width: 2, color: kGreen),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Text(name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: kBodyText.copyWith(
                            color: kGreen,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text('Email: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(email,
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text('CNIC: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(cnic,
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text('Address: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(address,
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text('Gender: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(gender,
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text('Approved: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(verified.toString(),
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text('Date: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                              DateTimeFormat.format(date.toDate(),
                                  format: DateTimeFormats.american),
                              textAlign: TextAlign.justify,
                              style: kBodyText.copyWith(
                                  color: kBlack, fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

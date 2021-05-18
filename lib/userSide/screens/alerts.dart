import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'screens.dart';

class Alerts extends StatefulWidget {
  Alerts({Key? key}) : super(key: key);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kBg,
        //Appbar
        appBar: AppBar(
          elevation: 0,
          title: Text('Send Alerts'),
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
            SizedBox(height: 10),
            alertsCard(size, 'assets/icons/fireA.png', 'Fire'),
            alertsCard(size, 'assets/icons/gasA.png', 'Gas Leakage'),
            alertsCard(size, 'assets/icons/robberyA.png', 'Robbery'),
            alertsCard(size, 'assets/icons/healthA.png', 'Health Emergency'),
            SizedBox(height: 10),
          ]),
        ));
  }

  Widget alertsCard(Size size, String icon, String type) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to send alert?'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('No', style: TextStyle(color: kGreen)),
              ),
              new TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SpinKitFadingCircle(
                      color: kGreen,
                      size: 50.0,
                    ),
                  );
                  var firestore = FirebaseFirestore.instance;
                  DocumentSnapshot qn = await firestore
                      .collection('users')
                      .doc(_auth.getCurrentUser())
                      .get();
                  await DatabaseService(uid: _auth.getCurrentUser())
                      .sendAlertData(qn['name'], qn['address'], type);
                  var id = Uuid().v4();
                  FirebaseFirestore.instance
                      .collection('adminNotifications')
                      .doc(id)
                      .set({
                        "id": id,
                        "timestamp": DateTime.now(),
                        "isRead": false,
                        "notification":
                            'A New Alert from ${qn['name']}, check it out ASAP',
                      })
                      .then((_) {})
                      .catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                      });
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Get.to(() => SendAlert(
                        alertType: type,
                      ));
                  Get.snackbar(
                    'Message',
                    'Alert is sent successfully!',
                    duration: Duration(seconds: 4),
                    backgroundColor: kBg,
                    colorText: kBlack,
                    borderRadius: 10,
                  );
                },
                child: new Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
        child: Center(
          child: Container(
            height: 60,
            width: size.width * 0.93,
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Icon
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 40,
                        child: Image.asset(
                          icon,
                          color: kGreen,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    //Text
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        type,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

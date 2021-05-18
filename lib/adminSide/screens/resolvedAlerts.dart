import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../shared/shared.dart';

class ResolvedAlerts extends StatefulWidget {
  ResolvedAlerts({Key? key}) : super(key: key);

  @override
  _ResolvedAlertsState createState() => _ResolvedAlertsState();
}

class _ResolvedAlertsState extends State<ResolvedAlerts> {
  Future getAlerts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('alerts').orderBy('timestamp').get();

    return qn.docs;
  }
  int alerts = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('Resolved Alerts'),
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
              future: getAlerts(),
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
                        (snapshot.data[i]['resolved'] == true)? alertsCard(
                          size,
                          snapshot.data[i]['uid'],
                          snapshot.data[i]['type'],
                          snapshot.data[i]['name'],
                          snapshot.data[i]['address'],
                          snapshot.data[i]['dateResolved'],
                          snapshot.data[i]['timestamp'],
                        ): SizedBox(),
                        (alerts == 0)? noAlerts(size, 'No alerts here!'): SizedBox()
                    ],
                  );
                }
              }),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

 //No alerts button
  Widget noAlerts(Size size, String name) {
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

Widget alertsCard(Size size, String uid, String type, String name, String address, Timestamp dateResolved, Timestamp date) {
        alerts++;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.95,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(10),
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
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Text(type,
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
                          child: Text('Name: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(name,
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
                          child: Text('Resolved: ',
                              style: kBodyText.copyWith(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                              DateTimeFormat.format(dateResolved.toDate(),
                                  format: DateTimeFormats.american),
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
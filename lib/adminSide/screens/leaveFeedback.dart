import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../shared/shared.dart';

class LeaveFeedbackScreen extends StatefulWidget {
  LeaveFeedbackScreen({Key? key}) : super(key: key);

  @override
  _LeaveFeedbackScreenState createState() => _LeaveFeedbackScreenState();
}

class _LeaveFeedbackScreenState extends State<LeaveFeedbackScreen> {
  Future getEvents() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('feedback').orderBy('timestamp', descending: true).get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('User Feedbacks'),
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
              future: getEvents(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(color: kGreen),
                  );
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        eventCard(
                          size,
                          snapshot.data[i]['name'],
                          snapshot.data[i]['email'],
                          snapshot.data[i]['feedback'],
                          snapshot.data[i]['timestamp'],
                        ),
                    ],
                  );
                }
              }),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget eventCard(
      Size size, String name, String email, String feedback, Timestamp date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
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
                        width: 80,
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
                        width: 80,
                        child: Text('Feedback: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(feedback,
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
                        width: 80,
                        child: Text('Date: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                            DateTimeFormat.format(
                                date.toDate(),
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
    );
  }
}

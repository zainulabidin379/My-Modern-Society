import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../shared/shared.dart';

class Events extends StatefulWidget {
  Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Future getEvents() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('events').get();

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
        title: Text('Events'),
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
                          snapshot.data[i]['event'],
                          snapshot.data[i]['description'],
                          snapshot.data[i]['venue'],
                          snapshot.data[i]['date'],
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
      Size size, String event, String description, String venue, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Row(
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
                  Text(event,
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
                        width: 85,
                        child: Text('Description: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(description,
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
                        width: 85,
                        child: Text('Venue: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(venue,
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
                        width: 85,
                        child: Text('Date: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(date,
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

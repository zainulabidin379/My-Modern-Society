import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../shared/shared.dart';
import 'screens.dart';

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
                      addEventButton(size, 'Add New Event'),
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

  //Add New Notice Button
  Widget addEventButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddNewEvent());
      },
      child: Padding(
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
      ),
    );
  }

  Widget eventCard(
      Size size, String event, String description, String venue, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(()=> UpdateEvent(id: '$event($date)'));
                },
                child: Container(
                  height: 50,
                  width: (size.width * 0.949)/2,
                  decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.zero,
                    ),
                    border: Border.all(width: 2, color: kGreen),
                  ),
                  child: Center(
                      child: Icon(
                    FontAwesomeIcons.pen,
                    color: kWhite,
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text('Are you sure?'),
                        content: new Text('Do you want to delete this event?'),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: new Text('No', style: TextStyle(color: kGreen)),
                          ),
                          new TextButton(
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection('events')
                                  .doc('$event($date)')
                                  .delete()
                                  .catchError((e) {
                                print(e);
                              });
                              Navigator.of(context).pop();
                              setState(() {});
                              Get.snackbar(
                                'Message',
                                'Event is deleted from database',
                                duration: Duration(seconds: 3),
                                backgroundColor: kBg,
                                colorText: kBlack,
                                borderRadius: 10,
                              );
                            },
                            child: new Text('Yes',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                },
                child: Container(
                  height: 50,
                  width: (size.width * 0.949)/2,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(10),
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.zero,
                    ),
                    border: Border.all(width: 2, color: Colors.red),
                  ),
                  child: Center(
                      child: Icon(
                    FontAwesomeIcons.trash,
                    color: kWhite,
                  )),
                ),
              ),
            ],
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
                        width: 80,
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
                        width: 80,
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
                        width: 80,
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

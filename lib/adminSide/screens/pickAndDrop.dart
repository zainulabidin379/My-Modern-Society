import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_modern_society/adminSide/screens/screens.dart';
import '../shared/shared.dart';

class PickAndDrop extends StatefulWidget {
  PickAndDrop({Key? key}) : super(key: key);

  @override
  _PickAndDropState createState() => _PickAndDropState();
}

class _PickAndDropState extends State<PickAndDrop> {
  Future getPickAndDropData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('pickAndDrop').get();

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
        title: Text('Pick and Drop'),
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
        child: Column(
          children: [
            SizedBox(height: 8),
            FutureBuilder<dynamic>(
                future: getPickAndDropData(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitFadingCircle(color: kGreen),
                    );
                  } else {
                    return Column(
                      children: [
                        addContactButton(size, 'Add New Contact'),
                        for (var i = 0; i < snapshot.data.length; i++)
                          pickAndDropCard(
                              size,
                              snapshot.data[i]['name'],
                              snapshot.data[i]['phone'],
                              snapshot.data[i]['routes']),
                      ],
                    );
                  }
                }),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  //Add New contact Button
  Widget addContactButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddNewPickAndDrop());
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

  Widget pickAndDropCard(Size size, String name, String phone, String routes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.17,
            width: size.width * 0.77,
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.zero,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                  //Bottom Border
                  BoxShadow(
                    color: kGreen,
                    offset: Offset(0, 2),
                  ),
                  //Top Border
                  BoxShadow(
                    color: kGreen,
                    offset: Offset(0, -2),
                  ),
                  //Left Border
                  BoxShadow(
                    color: kGreen,
                    offset: Offset(-2, 0),
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Name
                    Row(
                      children: [
                        Text('Name: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold)),
                        Text(name,
                            style: kBodyText.copyWith(
                                color: kBlack, fontSize: size.width * 0.04)),
                      ],
                    ),
                    //Phone Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold)),
                        Text(phone,
                            style: kBodyText.copyWith(
                                color: kBlack, fontSize: size.width * 0.04)),
                      ],
                    ),
                    //routes
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Routes: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            routes,
                            style: kBodyText.copyWith(
                                color: kBlack, fontSize: size.width * 0.04),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          Column(
            children: [
              Ink(
                decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(color: kGreen, width: 2)),
                child: InkWell(
                  splashColor: kWhite.withOpacity(0.1),
                  onTap: () {
                    Get.to(()=> UpdatePickAndDrop(id: phone,));
                  },
                  child: Container(
                    height: (size.height * 0.165)/2,
                    width: size.width * 0.18,
                    child: Icon(FontAwesomeIcons.pen, color: kWhite),
                  ),
                ),
              ),
              Ink(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.red, width: 2)),
                child: InkWell(
                  splashColor: kWhite.withOpacity(0.1),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text('Are you sure?'),
                        content: new Text('Do you want to delete this contact?'),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: new Text('No', style: TextStyle(color: kGreen)),
                          ),
                          new TextButton(
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection('pickAndDrop')
                                  .doc(phone)
                                  .delete()
                                  .catchError((e) {
                                print(e);
                              });
                              Navigator.of(context).pop();
                              setState(() {});
                              Get.snackbar(
                                'Message',
                                'Contact is deleted from database',
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
                    height: (size.height * 0.165)/2,
                    width: size.width * 0.18,
                    child: Icon(FontAwesomeIcons.trash, color: kWhite),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
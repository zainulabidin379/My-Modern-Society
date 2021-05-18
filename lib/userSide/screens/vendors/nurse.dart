
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/shared.dart';

class Nurse extends StatefulWidget {
  Nurse({Key? key}) : super(key: key);

  @override
  _NurseState createState() => _NurseState();
}

class _NurseState extends State<Nurse> {
  Future getVendor() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('nurses').get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text('Available Nurses'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kGreen,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(height: 8),
          FutureBuilder<dynamic>(
              future: getVendor(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(color: kGreen),
                  );
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        detailCard(
                            size,
                            snapshot.data[i]['name'],
                            snapshot.data[i]['phone'],
                            snapshot.data[i]['address']),
                    ],
                  );
                }
              }),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget detailCard(Size size, String name, String phone, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.15,
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
                    //Address
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: size.width * 0.51,
                          child: AutoSizeText(
                            address,
                            style: kBodyText.copyWith(
                                color: kBlack, fontSize: size.width * 0.04),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          Ink(
            decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.circular(10),
                ),
                border: Border.all(color: kGreen, width: 2)),
            child: InkWell(
              splashColor: kWhite.withOpacity(0.1),
              onTap: () {
                launch("tel://$phone");
              },
              child: Container(
                height: size.height * 0.15,
                width: size.width * 0.18,
                child: Icon(FontAwesomeIcons.phoneAlt, color: kWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
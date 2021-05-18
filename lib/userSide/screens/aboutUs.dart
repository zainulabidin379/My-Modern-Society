import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../shared/shared.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('About Us'),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'This mobile application is about a modern society that will simply facilitate the members residing in the society by giving them indoor facilitations like:',
              style: TextStyle(fontSize: 22, height: 1.2),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 8),
          featuresList('Hiring vendors'),
          featuresList('Registering complaints'),
          featuresList('Society Notices'),
          featuresList('Society Gallery'),
          featuresList('Society Events'),
          featuresList('Sending Alerts'),
          featuresList('Society Rules'),
          featuresList('Society Directory'),
          featuresList('Pick and Drop Service'),
          featuresList('Feedback'),
          featuresList('Polls'),
          featuresList('Discussion'),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Get.snackbar(
                'Message',
                'Video will be available soon.',
                duration: Duration(seconds: 3),
                backgroundColor: kBg,
                colorText: kBlack,
                borderRadius: 10,
              );
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.youtube,
                          color: Colors.red,
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'How to Use App (Guide)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Developed with ',
                    style: TextStyle(fontSize: 15, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 13,),
                  ),
                  Text(
                    ' by Basir Akbar & Saad Ali',
                    style: TextStyle(fontSize: 15, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(FontAwesomeIcons.copyright, size: 13,),
                  ),
                  Text(
                    '2021. All Rights Reserved',
                    style: TextStyle(fontSize: 15, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget featuresList(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
      child: Row(
        children: [
          Text(
            '-> ',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: kGreen),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

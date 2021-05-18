import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/shared.dart';

class Bazaar extends StatefulWidget {
  Bazaar({Key? key}) : super(key: key);

  @override
  _BazaarState createState() => _BazaarState();
}

class _BazaarState extends State<Bazaar> {
  Future getBazaar() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('bazaars').get();

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
        title: Text('Bazaars'),
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
              future: getBazaar(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(color: kGreen),
                  );
                } else {
                  return Column(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        bazaarCard(
                          size,
                          snapshot.data[i]['name'],
                          snapshot.data[i]['address'],
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

  Widget bazaarCard(
      Size size, String name, String address) {
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
                  Text(name,
                      textAlign: TextAlign.center,
                      style: kBodyText.copyWith(
                          color: kGreen,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(address,
                  textAlign: TextAlign.center,
                      style: kBodyText.copyWith(
                          color: kBlack, fontSize: 16)),
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

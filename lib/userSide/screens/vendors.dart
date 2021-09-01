import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/shared.dart';
import 'package:uuid/uuid.dart';
import '../screens/screens.dart';

class Vendors extends StatefulWidget {
  @override
  _VendorsState createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //AppBar
      appBar: AppBar(
        elevation: 0,
        title: Text('Service Providers'),
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
          //1ST ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Electricians()),
                      },
                  'assets/icons/electrician.png',
                  'Electrician'),
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Mechanic()),
                      },
                  'assets/icons/mechanic.png',
                  'Mechanic'),
              
            ],
          ),

          //2ND ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Plumber()),
                      },
                  'assets/icons/plumber.png',
                  'Plumber'),
              vendorCard(
                  size,
                  () => {
                    Get.to(()=> Carpenter()),
                        // FirebaseFirestore.instance
                        //     .collection('chefs')
                        //     .doc(Uuid().v1())
                        //     .set({
                        //   "name": 'Saad',
                        //   "phone": '0300-1234567',
                        //   "address": '123 Street, City ABC',
                        // }).then((_) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text('Successfully Added')));
                        // }).catchError((onError) {
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(SnackBar(content: Text(onError)));
                        // }),
                      },
                  'assets/icons/carpenter.png',
                  'Carpenter'),
              
            ],
          ),
          //3RD ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Painter()),
                      },
                  'assets/icons/painter.png',
                  'Painter'),
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Sweeper()),
                      },
                  'assets/icons/sweeper.png',
                  'Sweeper'),
              
            ],
          ),
          //4TH ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Nurse()),
                      },
                  'assets/icons/nurse.png',
                  'Nurse'),
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Gardener()),
                      },
                  'assets/icons/gardener.png',
                  'Gardener'),
              
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Maid()),
                      },
                  'assets/icons/maid.png',
                  'House Maid'),
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Qari()),
                      },
                  'assets/icons/qari.png',
                  'Qari'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Qariya()),
                      },
                  'assets/icons/qariya.png',
                  'Qariya'),
              vendorCard(
                  size,
                  () => {
                        Get.to(()=> Chef()),
                      },
                  'assets/icons/chef.png',
                  'Chef'),
            ],
          ),
        ]),
      ),
    );
  }

  //Vendor Card
  Widget vendorCard(Size size, Function onTap, String icon, String name) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          height: size.width * 0.45,
          width: size.width * 0.45,
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: size.width * 0.15,
                      child: Image.asset(
                        icon,
                        color: kGreen,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: Text(name,
                          style: kBodyText.copyWith(
                              color: kBlack, fontSize: size.width * 0.04))),
                ]),
          ),
        ),
      ),
    );
  }
}

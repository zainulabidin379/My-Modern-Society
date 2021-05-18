import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../shared/shared.dart';
import 'screens.dart';

class Complaints extends StatefulWidget {
  Complaints({Key? key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('Complaints'),
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
            SizedBox(height: 10),
            complaintCard(size, 'assets/icons/waterC.png', 'Water Supply'),
            complaintCard(size, 'assets/icons/electricityC.png', 'Electricity'),
            complaintCard(size, 'assets/icons/streetsC.png', 'Cleanliness of Street'),
            complaintCard(size, 'assets/icons/gasC.png', 'Gas Supply'),
            complaintCard(size, 'assets/icons/cableC.png', 'Tv Cable'),
            complaintCard(size, 'assets/icons/internetC.png', 'Internet Connectivity'),
            complaintCard(size, 'assets/icons/roadMaintC.png', 'Road/Street Maintenance'),
            complaintCard(size, 'assets/icons/misbehaveC.png', 'Misbehavior of Staff'),
            SizedBox(height: 10),
          ]
        ),
        )
    );
  }
  //Complaint Card
  Widget complaintCard(Size size, String icon, String type) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> RegisterComplaint(complaintOf: type, icon: icon,));
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
                    child: Text(type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/shared.dart';
import '../services/services.dart';

class SendAlert extends StatefulWidget {
  String? alertType;
  SendAlert({Key? key, this.alertType}) : super(key: key);

  @override
  _SendAlertState createState() => _SendAlertState();
}

class _SendAlertState extends State<SendAlert> {
  @override
  
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
          //Appbar
          appBar: AppBar(
            elevation: 0,
            title: Text('Alert Sent'),
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
          body: Column(
            children: [
              Center(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Emergency Numbers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              )),
              (widget.alertType == 'Fire')? phoneCard(size, 'Ambulance', '1122'): SizedBox(),
              (widget.alertType == 'Fire')? phoneCard(size, 'Fire Fighters', '112'): SizedBox(),
              (widget.alertType == 'Fire')? phoneCard(size, 'Police', '15'): SizedBox(),

              (widget.alertType == 'Gas Leakage')? phoneCard(size, 'Ambulance', '1122'): SizedBox(),
              (widget.alertType == 'Gas Leakage')? phoneCard(size, 'Fire Fighters', '112'): SizedBox(),
              (widget.alertType == 'Gas Leakage')? phoneCard(size, 'Police', '15'): SizedBox(),

              (widget.alertType == 'Robbery')? phoneCard(size, 'Police', '15'): SizedBox(),

              (widget.alertType == 'Health Emergency')? phoneCard(size, 'Ambulance', '1122'): SizedBox(),
              
            ]
          ),
    );
  }
  Widget phoneCard(Size size, String type, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: size.width * 0.77,
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.zero,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('$type: ',
                            style: kBodyText.copyWith(
                                color: kBlack,
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.bold)),
                        Text(phone,
                            style: kBodyText.copyWith(
                                color: kBlack, fontSize: size.width * 0.06)),
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
                height: 66,
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
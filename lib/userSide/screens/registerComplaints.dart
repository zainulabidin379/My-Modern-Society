import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import 'package:the_validator/the_validator.dart';
import '../shared/shared.dart';

class RegisterComplaint extends StatefulWidget {
  final String? complaintOf;
  final String? icon;
  const RegisterComplaint({Key? key, this.complaintOf, this.icon})
      : super(key: key);

  @override
  _RegisterComplaintState createState() => _RegisterComplaintState();
}

class _RegisterComplaintState extends State<RegisterComplaint> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final detailsController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    detailsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: kBg,
          //Appbar
          appBar: AppBar(
            elevation: 0,
            title: Text('Register Complaint'),
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
          body: Column(children: [
            SizedBox(height: 10),
            complaintCard(size, widget.icon!, widget.complaintOf!),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: size.width * 0.04),
                  child: TextFormField(
                    controller: detailsController,
                    style: kBodyText.copyWith(color: kBlack),
                    cursorColor: kGreen,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    maxLines: 6,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kWhite,
                      hintText: 'Complaint Details',
                      hintStyle: kBodyText.copyWith(fontSize: 18, color: kGrey),
                      errorStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kGreen, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: FieldValidator.multiple([
                      FieldValidator.required(),
                      FieldValidator.minLength(4,
                          message:
                              'Please enter proper details of your complaint'),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              SpinKitFadingCircle(
                            color: kGreen,
                            size: 50.0,
                          ),
                        );
                        var firestore = FirebaseFirestore.instance;
                        DocumentSnapshot qn = await firestore
                            .collection('users')
                            .doc(_auth.getCurrentUser())
                            .get();
                        await DatabaseService(uid: _auth.getCurrentUser())
                            .registerComplaint(qn['name'], qn['address'],
                                widget.complaintOf, detailsController.text);
                                var id = Uuid().v4();
                          FirebaseFirestore.instance
                              .collection('adminNotifications')
                              .doc(id)
                              .set({
                                "id": id,
                                "timestamp": DateTime.now(),
                                "isRead": false,
                                "notification":
                                    'A New Complaint from ${qn['name']} has been registered, check it out ASAP',
                              })
                              .then((_) {})
                              .catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Get.snackbar(
                          'Message',
                          'Your complaint is registered!',
                          duration: Duration(seconds: 3),
                          backgroundColor: kBg,
                          colorText: kBlack,
                          borderRadius: 10,
                        );
                        return;
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
                      height: 50,
                      width: size.width * 0.93,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                          'Register Complaint',
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ])),
    );
  }

  Widget complaintCard(Size size, String icon, String type) {
    return Padding(
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
                    child: Text(
                      type,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class LeaveFeedback extends StatefulWidget {
  LeaveFeedback({Key? key}) : super(key: key);

  @override
  _LeaveFeedbackState createState() => _LeaveFeedbackState();
}

class _LeaveFeedbackState extends State<LeaveFeedback> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final feedbackController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    feedbackController.dispose();
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
          title: Text('Feedback'),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04, vertical: 6),
              child: Text('Please enter your feedback: ',
                  style: TextStyle(fontSize: 20)),
            ),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: size.width * 0.04),
                  child: TextFormField(
                    controller: feedbackController,
                    style: kBodyText.copyWith(color: kBlack),
                    cursorColor: kGreen,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kWhite,
                      hintText: 'Your Feedback',
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
                          message: 'Please enter proper feedback'),
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
                            .sendFeedbackData(qn['name'], qn['email'],
                                feedbackController.text);
                        var id = Uuid().v4();
                        FirebaseFirestore.instance
                            .collection('adminNotifications')
                            .doc(id)
                            .set({
                              "id": id,
                              "timestamp": DateTime.now(),
                              "isRead": false,
                              "notification":
                                  'A New Feedback recieved from ${qn['name']}.',
                            })
                            .then((_) {})
                            .catchError((onError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(onError)));
                            });
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Get.snackbar(
                          'Thank You!',
                          'Your feedback is recieved',
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
                          'Send Feedback',
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}

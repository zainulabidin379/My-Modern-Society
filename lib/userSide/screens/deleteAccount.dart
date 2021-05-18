import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:my_modern_society/userSide/screens/logIn.dart';
import 'package:the_validator/the_validator.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class DeleteAccount extends StatefulWidget {
  DeleteAccount({Key? key}) : super(key: key);

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Description Text
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "We're Sorry to see you go. Please let us know why you want to delete your account.",
                            textAlign: TextAlign.center,
                            style: kBodyText.copyWith(
                                fontSize: size.width * 0.05, color: kBlack),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //Reason
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: TextFormField(
                            controller: reasonController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14, top: 8),
                              hintText: 'Reason',
                              hintStyle: kBodyText.copyWith(
                                  fontSize: 20, color: kGrey),
                              errorStyle: TextStyle(
                                fontSize: 14,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: kGreen, width: 1.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: kGreen,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: kGreen,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: FieldValidator.multiple([
                              FieldValidator.required(),
                              FieldValidator.minLength(2,
                                  message:
                                      'Please enter an appropriate reason'),
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
                                FirebaseAuth firebaseAuth =
                                    FirebaseAuth.instance;
                                User? user = firebaseAuth.currentUser;
                                var firestore = FirebaseFirestore.instance;

                                user!.delete().then((_) async {
                                  Get.offAll(() => Login());
                                  DocumentSnapshot qn = await firestore
                                      .collection('users')
                                      .doc(user.uid)
                                      .get();
                                  FirebaseFirestore.instance
                                      .collection('deletedAccounts')
                                      .doc(user.uid)
                                      .set({
                                    "email": qn['email'],
                                    "name": qn['name'],
                                    "date": DateTime.now(),
                                    "reason": reasonController.text,
                                  }).then((_) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .delete();
                                  }).catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(onError)));
                                  });
                                  Get.snackbar(
                                    'GoodBye!',
                                    'Your account is deleted.',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: kGreen,
                                    borderRadius: 10,
                                  );
                                }).catchError((error) {
                                  Navigator.pop(context);
                                  Get.snackbar(
                                    'Failed',
                                    "Please log out and log in again to perform this action.",
                                    duration: Duration(seconds: 6),
                                    backgroundColor: Colors.red,
                                    colorText: kWhite,
                                    borderRadius: 10,
                                  );
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              height: 50,
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  'Delete Account',
                                  style: kBodyText.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

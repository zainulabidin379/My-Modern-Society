import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class AddNewRule extends StatefulWidget {
  AddNewRule({Key? key}) : super(key: key);

  @override
  _AddNewRuleState createState() => _AddNewRuleState();
}

class _AddNewRuleState extends State<AddNewRule> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final ruleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Rule'),
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //rule
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: TextFormField(
                            controller: ruleController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14, top: 8),
                              hintText: 'Rule',
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
                              FieldValidator.minLength(6,
                                  message: 'Please enter a valid rule'),
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
                                var collectionRef = await FirebaseFirestore
                                    .instance
                                    .collection('societyRules')
                                    .doc(ruleController.text)
                                    .get();

                                if (collectionRef.exists) {
                                  Navigator.pop(context);
                                  Get.snackbar(
                                    'Error',
                                    'This rule already exists. Try another',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: Colors.red,
                                    borderRadius: 10,
                                  );
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('societyRules')
                                      .doc(ruleController.text)
                                      .set({
                                    "rule": ruleController.text,
                                  }).then((_) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .get()
                                        .then((value) {
                                      var id = Uuid().v4();

                                      for (var i = 0;
                                          i < value.docs.length;
                                          i++) {
                                        FirebaseFirestore.instance
                                            .collection('notifications')
                                            .doc('notificationsDoc')
                                            .collection(value.docs[i]['uid'])
                                            .doc(id)
                                            .set({
                                              "id": id,
                                              "timestamp": DateTime.now(),
                                              "isRead": false,
                                              "notification":
                                                  'A new rule has been added to society rules, kindly check it out in Society Rules section.',
                                            })
                                            .then((_) {})
                                            .catchError((onError) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(onError)));
                                            });
                                      }
                                    });

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Get.snackbar(
                                      'Successfully Added',
                                      'New rule successfully added.',
                                      duration: Duration(seconds: 4),
                                      backgroundColor: kBg,
                                      colorText: kGreen,
                                      borderRadius: 10,
                                    );
                                  }).catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(onError)));
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              height: 50,
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  'Add Rule',
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

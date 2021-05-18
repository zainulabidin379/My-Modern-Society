import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class AddNewNotice extends StatefulWidget {
  AddNewNotice({Key? key}) : super(key: key);

  @override
  _AddNewNoticeState createState() => _AddNewNoticeState();
}

class _AddNewNoticeState extends State<AddNewNotice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final subjectController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Notice'),
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
                        //Subject
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: TextFormField(
                            controller: subjectController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              hintText: 'Subject',
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
                              FieldValidator.minLength(4,
                                  message: 'Please enter a valid subject'),
                            ]),
                          ),
                        ),

                        //Date
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: TextFormField(
                            controller: dateController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              hintText: 'Date (01-01-2020 or 01/01/2020)',
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
                              FieldValidator.minLength(8,
                                  message:
                                      'Please enter a valid date (01-01-2020 or 01/01/2020)'),
                              FieldValidator.maxLength(10,
                                  message:
                                      'Please enter a valid date (01-01-2020 or 01/01/2020)'),
                            ]),
                          ),
                        ),

                        //description
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: TextFormField(
                            controller: descriptionController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              hintText: 'Description',
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
                              FieldValidator.minLength(4,
                                  message:
                                      'Please enter a valid description'),
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
                                var collectionRef = await FirebaseFirestore
                                    .instance
                                    .collection(
                                        'noticeBoard')
                                    .doc(subjectController.text)
                                    .get();

                                if (collectionRef.exists) {
                                  Get.snackbar(
                                    'Error',
                                    'This notice already exists. Try another',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: Colors.red,
                                    borderRadius: 10,
                                  );
                                } else {
                                  FirebaseFirestore.instance
                                      .collection(
                                          'noticeBoard')
                                      .doc(subjectController.text)
                                      .set({
                                    "subject": subjectController.text,
                                    "date": dateController.text,
                                    "description": descriptionController.text,
                                    "timestamp": DateTime.now(),
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
                                                  'A new notice has been issued, kindly check it out in Notice Board section.',
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
                                    Get.snackbar(
                                      'Successfully Added',
                                      'New notice successfully added.',
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
                                  'Add Notice',
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

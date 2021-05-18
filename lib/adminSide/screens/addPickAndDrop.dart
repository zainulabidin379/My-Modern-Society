import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class AddNewPickAndDrop extends StatefulWidget {
  final String? vendor;
  AddNewPickAndDrop({Key? key, this.vendor}) : super(key: key);

  @override
  _AddNewPickAndDropState createState() => _AddNewPickAndDropState();
}

class _AddNewPickAndDropState extends State<AddNewPickAndDrop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final routesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
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
                        //Name
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: TextFormField(
                            controller: nameController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              hintText: 'Full Name',
                              hintStyle: kBodyText.copyWith(
                                  fontSize: 20, color: kGrey),
                              errorStyle: TextStyle(
                                fontSize: 10.0,
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
                                  message: 'Please enter a valid name'),
                            ]),
                          ),
                        ),

                        //CNIC
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: TextFormField(
                            controller: phoneController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              hintText: 'Phone Number',
                              hintStyle: kBodyText.copyWith(
                                  fontSize: 20, color: kGrey),
                              errorStyle: TextStyle(
                                fontSize: 10.0,
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
                              FieldValidator.minLength(11,
                                  message:
                                      'Please enter a valid phone number (03001234567)'),
                              FieldValidator.maxLength(11,
                                  message:
                                      'Please enter a valid phone number (03001234567)'),
                              FieldValidator.number(noSymbols: true),
                            ]),
                          ),
                        ),

                        //routes
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: TextFormField(
                            controller: routesController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: 2,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14, top: 8),
                              hintText: 'Routes',
                              hintStyle: kBodyText.copyWith(
                                  fontSize: 20, color: kGrey),
                              errorStyle: TextStyle(
                                fontSize: 10.0,
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
                                      'Correct format: route1, route2, route3'),
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
                                        'pickAndDrop')
                                    .doc(phoneController.text)
                                    .get();

                                if (collectionRef.exists) {
                                  Get.snackbar(
                                    'Error',
                                    'This contact number already exists. Try another',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: Colors.red,
                                    borderRadius: 10,
                                  );
                                } else {
                                  FirebaseFirestore.instance
                                      .collection(
                                          'pickAndDrop')
                                      .doc(phoneController.text)
                                      .set({
                                    "name": nameController.text,
                                    "phone": phoneController.text,
                                    "routes": routesController.text,
                                  }).then((_) async{
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
                                                  'A new Pick and Drop contact has been added, go and check it out in Pick and Drop section.',
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
                                      'Pick and Drop contact successfully added.',
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
                                  'Add Contact',
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

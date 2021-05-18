import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';
import '../../services/services.dart';
import '../../shared/shared.dart';

class UpdatePlace extends StatefulWidget {
  final String? place;
  final String? id;
  UpdatePlace({Key? key, @required this.place, @required this.id})
      : super(key: key);

  @override
  _UpdatePlaceState createState() => _UpdatePlaceState();
}

class _UpdatePlaceState extends State<UpdatePlace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  var nameController = TextEditingController();
  var addressController = TextEditingController();

  Future getplace() async {
    var firestore = FirebaseFirestore.instance;
    var qn = await firestore
        .collection('${widget.place!.toLowerCase()}s')
        .doc(widget.id)
        .get();
    setState(() {
      nameController.text = qn.get('name');
      addressController.text = qn.get('address');
    });
  }

  @override
  void initState() {
    super.initState();
    getplace();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update ${widget.place}'),
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
                              hintText: '${widget.place} Name',
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

                        //Address
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: TextFormField(
                            controller: addressController,
                            style: kBodyText.copyWith(color: kBlack),
                            cursorColor: kGreen,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              hintText: 'Address',
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
                                      'Please enter a valid address'),
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
                                        '${widget.place!.toLowerCase()}s')
                                    .doc(nameController.text)
                                    .get();

                                if (collectionRef.exists) {
                                  FirebaseFirestore.instance
                                      .collection(
                                          '${widget.place!.toLowerCase()}s')
                                      .doc(nameController.text)
                                      .update({
                                    "name": nameController.text,
                                    "address": addressController.text,
                                  }).then((_) {
                                    Navigator.pop(context);
                                    Get.snackbar(
                                      'Successfully Updated',
                                      '${widget.place} successfully updated.',
                                      duration: Duration(seconds: 4),
                                      backgroundColor: kBg,
                                      colorText: kGreen,
                                      borderRadius: 10,
                                    );
                                  }).catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(onError)));
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection(
                                          '${widget.place!.toLowerCase()}s')
                                      .doc(nameController.text)
                                      .set({
                                    "name": nameController.text,
                                    "address": addressController.text,
                                  }).then((_) {
                                    FirebaseFirestore.instance
                                        .collection('${widget.place!.toLowerCase()}s')
                                        .doc(widget.id)
                                        .delete();
                                    Navigator.pop(context);
                                    Get.snackbar(
                                      'Successfully Updated',
                                      '${widget.place} successfully updated.',
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
                                  'Update ${widget.place}',
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

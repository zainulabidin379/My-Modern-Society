import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class AddNewAd extends StatefulWidget {
  AddNewAd({Key? key}) : super(key: key);

  @override
  _AddNewAdState createState() => _AddNewAdState();
}

class _AddNewAdState extends State<AddNewAd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  late File _image;
  final picker = ImagePicker();
  bool fileUploaded = false;

  Future getImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        showDialog(
          context: context,
          builder: (BuildContext context) => SpinKitFadingCircle(
            color: kGreen,
            size: 50.0,
          ),
        );
        uploadImageToFirebase();
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
        Get.snackbar(
          'Successfully Uploaded',
          'Selected Ad is successfully uploaded.',
          duration: Duration(seconds: 4),
          backgroundColor: kBg,
          colorText: kGreen,
          borderRadius: 10,
        );
      } else {
        Get.snackbar(
          'No Ad Selected',
          'Please select an Ad and try again.',
          duration: Duration(seconds: 4),
          backgroundColor: kBg,
          colorText: kGreen,
          borderRadius: 10,
        );
      }
    });
  }

  Future uploadImageToFirebase() async {
    String id = basename(Uuid().v4());
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('ads/$id');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      String url = await firebaseStorageRef.getDownloadURL();
      FirebaseFirestore.instance.collection("ads").doc(id).set({
        "url": url,
        "id": id,
      }).then((_) {
        setState(() {
          fileUploaded = true;
        });
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Ad'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      getImage(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                      height: 50,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                          'Choose Ad',
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

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

class AddGallery extends StatefulWidget {
  AddGallery({Key? key}) : super(key: key);

  @override
  _AddGalleryState createState() => _AddGalleryState();
}

class _AddGalleryState extends State<AddGallery> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  late File _image;
  final picker = ImagePicker();
  bool fileUploaded = false;

  Future getImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() async {
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
        await FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((value) {
          var id = Uuid().v4();

          for (var i = 0; i < value.docs.length; i++) {
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
                      'A new image has been added, go and check it out in Gallery section.',
                })
                .then((_) {})
                .catchError((onError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(onError)));
                });
          }
        });
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
        Get.snackbar(
          'Successfully Uploaded',
          'Selected Image is successfully uploaded.',
          duration: Duration(seconds: 4),
          backgroundColor: kBg,
          colorText: kGreen,
          borderRadius: 10,
        );
      } else {
        Get.snackbar(
          'No Image Selected',
          'Please select an image and try again.',
          duration: Duration(seconds: 4),
          backgroundColor: kBg,
          colorText: kGreen,
          borderRadius: 10,
        );
      }
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(Uuid().v4());
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('gallery/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      String url = await firebaseStorageRef.getDownloadURL();
      FirebaseFirestore.instance.collection("gallery").doc(fileName).set({
        "url": url,
        "fileName": fileName,
        "timestamp": DateTime.now(),
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
        title: Text('Add New Image'),
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
                      setState(() {});
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
                          'Choose Image',
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

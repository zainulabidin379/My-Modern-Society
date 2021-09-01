import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../screens/screens.dart';
import '../shared/shared.dart';

class Gallery extends StatefulWidget {
  Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Future getImages() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('gallery')
        .orderBy('timestamp', descending: true).get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kBg,
        //Appbar
        appBar: AppBar(
          elevation: 0,
          title: Text('Gallery'),
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
          child: Column(
            children: [
              SizedBox(height: 10),
              FutureBuilder<dynamic>(
                  future: getImages(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitFadingCircle(color: kGreen),
                      );
                    } else {
                      return Column(
                        children: [
                          addImage(size, 'Add New Image'),
                          for (var i = 0; i < snapshot.data.length; i++)
                            imageCard(size, snapshot.data[i]['url'],
                                snapshot.data[i]['fileName']),
                        ],
                      );
                    }
                  }),
              SizedBox(height: 10),
            ],
          ),
        ));
  }

  //Add New image Button
  Widget addImage(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddGallery());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
        child: Center(
          child: Container(
            height: 60,
            width: size.width * 0.95,
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
              child: Center(
                  child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageCard(Size size, String image, String? fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Do you want to delete this image?'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: new Text('No', style: TextStyle(color: kGreen)),
                    ),
                    new TextButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('gallery')
                            .doc(fileName)
                            .delete()
                            .catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).pop();
                        setState(() {});
                        Get.snackbar(
                          'Message',
                          'Image is deleted from database',
                          duration: Duration(seconds: 3),
                          backgroundColor: kBg,
                          colorText: kBlack,
                          borderRadius: 10,
                        );
                      },
                      child:
                          new Text('Yes', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              height: 50,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
                border: Border.all(width: 2, color: Colors.red),
              ),
              child: Center(
                  child: Icon(
                FontAwesomeIcons.trash,
                color: kWhite,
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => ShowFullScreenImage(
                    image: image,
                  ));
            },
            child: Container(
              height: 230,
              width: size.width,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: Border.all(color: kGreen, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

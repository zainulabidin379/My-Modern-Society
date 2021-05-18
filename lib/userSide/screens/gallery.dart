import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'screens.dart';
import '../shared/shared.dart';

class Gallery extends StatefulWidget {
  Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Future getImages() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('gallery').get();

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
                      for (var i = 0; i < snapshot.data.length; i++)
                        imageCard(size, snapshot.data[i]['url']),
                    ],
                  );
                }
              }),
              SizedBox(height: 10),
            ],
          ),
        ));
  }

  Widget imageCard(Size size, String image) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> ShowFullScreenImage(image: image,));
      },
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        child: Container(
          height: 230,
          width: size.width,
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
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
                  ]
              ),
        ),
      ),
    );
  }
}

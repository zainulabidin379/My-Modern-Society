import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screens.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'package:get/get.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final AuthService _auth = AuthService();
  bool isEditing = false;

  final nameController = TextEditingController();
  final addressController = TextEditingController();

  String? name;
  String? email;
  String? cnic;
  String? address;
  String? gender;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    addressController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('My Account'),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: (gender == 'male')? AssetImage('assets/images/male.png'): AssetImage('assets/images/female.png'),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    enabled: isEditing,
                    controller: nameController,
                    cursorColor: kGreen,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: kGreen, fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: name,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    enabled: false,
                    cursorColor: kGreen,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: kGreen, fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: email,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    enabled: false,
                    cursorColor: kGreen,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      labelText: 'CNIC',
                      labelStyle: TextStyle(color: kGreen, fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: cnic,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    controller: addressController,
                    enabled: false,
                    cursorColor: kGreen,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      labelText: 'Address',
                      labelStyle: TextStyle(color: kGreen, fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: address,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: kGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                isEditing ? saveButtonRow() : editInfoButton(),
                deleteAccountButton(),
              ],
            ),
          ),
        ));
  }

  Widget editInfoButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            isEditing = true;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          child: Center(
            child: Text(
              'Edit Name',
              style: kBodyText.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Row saveButtonRow() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 5.0, top: 20.0, bottom: 20),
          child: InkWell(
            onTap: () {
              setState(() {
                isEditing = false;
              });
            },
            child: Container(
                alignment: Alignment.center,
                height: 50.0,
                decoration: BoxDecoration(
                    color: kGrey, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Cancel',
                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                )),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 20.0, top: 20.0, bottom: 20),
          child: InkWell(
            onTap: () async {
              setState(() {
                isEditing = false;
                if (nameController.text == '') {
                  nameController.text = name!;
                }
                if (addressController.text == '') {
                  addressController.text = address!;
                }
              });
              await DatabaseService(uid: _auth.getCurrentUser()).updateUserData(
                nameController.text,
                addressController.text,
              );

              Get.snackbar(
                'Message',
                'Account information updated Successfully',
                duration: Duration(seconds: 3),
                backgroundColor: kWhite,
                colorText: kGreen,
                borderRadius: 10,
              );
            },
            child: Container(
                alignment: Alignment.center,
                height: 50.0,
                decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Save',
                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                )),
          ),
        )),
      ],
    );
  }

  fetchData() async {
    var currentUser = _auth.getCurrentUser();
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();
    setState(() {
      name = variable['name'];
      email = variable['email'];
      cnic = variable['cnic'];
      address = variable['address'];
      gender = variable['gender'];
    });
  }

    Widget deleteAccountButton() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: InkWell(
        onTap: () {
          showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Deleting your account will remove all of your information from our database. This cannot be undone.'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: new Text('No', style: TextStyle(color: kGreen)),
                    ),
                    new TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Get.to(()=> DeleteAccount());
                      },
                      child:
                          new Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: Center(
            child: Text(
              'Delete Account',
              style: kBodyText.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

}

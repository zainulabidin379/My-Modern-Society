import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_modern_society/userSide/screens/logIn.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'screens.dart';

class AdminSetting extends StatefulWidget {
  AdminSetting({Key? key}) : super(key: key);

  @override
  _AdminSettingState createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBg,
      //Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text('Admin Setting'),
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
        child: Column(children: [
          SizedBox(height: 8),
          resetPasswordButton(size, 'Change Password'),
          logOutButton(size, 'Log Out'),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  //Reset password button
  Widget resetPasswordButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> ChangePassword());
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

  //unResolved complaints button
  Widget logOutButton(Size size, String name) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to log out?'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('No', style: TextStyle(color: kGreen)),
              ),
              new TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  Get.offAll(()=> Login());
                  Get.snackbar(
                    'Message',
                    'Admin logged out successfully',
                    duration: Duration(seconds: 3),
                    backgroundColor: kBg,
                    colorText: kBlack,
                    borderRadius: 10,
                  );
                },
                child: new Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
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
}

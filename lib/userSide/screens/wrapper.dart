import 'package:my_modern_society/adminSide/screens/adminHomeScreen.dart';

import 'screens.dart';
import '../shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TheUser? user = Provider.of<TheUser?>(context);

    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.hasData &&
              snapshot.data != ConnectivityResult.none) {
            if (user == null) {
              return Login();
            } else {
              if(user.uid == 'SUj5uhm9jDX3EqRVW5uxDu5rWph1' || user.uid == '7Lgs69T0Ebcm2pTTpueetVCsT6h1'){
                return AdminHomeScreen();
              } else {
                return HomeScreen();
              }
            }
          } else {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        width: size.width * 0.3,
                        child: Image.asset('assets/icons/internet.png')),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Center(
                      child: Text(
                    'Looks like you are Offline!',
                    style: TextStyle(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: size.height * 0.01),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Please check your internet connection and try again. ",
                      style: TextStyle(fontSize: size.width * 0.04),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ),
            );
          }
        });
  }
}
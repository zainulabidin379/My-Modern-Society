import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_modern_society/userSide/screens/logIn.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late bool _obscurePassword;
  late bool _obscureConfirmPassword;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void initState() {
    _obscurePassword = true;
    _obscureConfirmPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
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
                        //Password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: TextFormField(
                              controller: passwordController,
                              style: kBodyText.copyWith(color: kBlack),
                              obscureText: _obscurePassword,
                              cursorColor: kGreen,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Password',
                                hintStyle: kBodyText.copyWith(
                                    fontSize: 20, color: kGrey),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.lock,
                                  color: kBlack,
                                  size: 20,
                                ),
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kBlack,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toggle the state of passwordVisible variable
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty)
                                  return 'This field is required';
                                if (val.length < 6) {
                                  return 'Password must be of at least 6 characters';
                                }
                                return null;
                              }),
                        ),

                        //Confirm Password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: TextFormField(
                              controller: confirmPasswordController,
                              style: kBodyText.copyWith(color: kBlack),
                              obscureText: _obscureConfirmPassword,
                              cursorColor: kGreen,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Confirm Password',
                                hintStyle: kBodyText.copyWith(
                                    fontSize: 20, color: kGrey),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.lock,
                                  color: kBlack,
                                  size: 20,
                                ),
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obscureConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kBlack,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toggle the state of passwordVisible variable
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty)
                                  return 'This field is required';
                                if (val != passwordController.text)
                                  return 'Password must be same';
                                if (val.length < 6) {
                                  return 'Password must be same';
                                }
                                return null;
                              }),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SpinKitFadingCircle(
                                    color: kGreen,
                                    size: 50.0,
                                  ),
                                );

                                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                User? user = firebaseAuth.currentUser;
                                user!
                                    .updatePassword(passwordController.text)
                                    .then((_) {
                                  print("Successfully changed password");
                                  
                                  Get.offAll(() => Login());
                                  Get.snackbar(
                                    'Password Changed Successfully',
                                    'Your password is changed successfully.',
                                    duration: Duration(seconds: 4),
                                    backgroundColor: kBg,
                                    colorText: kGreen,
                                    borderRadius: 10,
                                  );
                                }).catchError((error) {
                                  Navigator.pop(context);
                                  Get.snackbar(
                                    'Failed',
                                    "Please log out and log in again to perform this action.",
                                    duration: Duration(seconds: 6),
                                    backgroundColor: Colors.red,
                                    colorText: kWhite,
                                    borderRadius: 10,
                                  );
                                });
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
                                  'Update Password',
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

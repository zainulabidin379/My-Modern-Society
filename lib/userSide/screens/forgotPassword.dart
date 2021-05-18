import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_modern_society/adminSide/screens/adminHomeScreen.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_validator/the_validator.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final emailController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        //Background Image and Black shade
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/authBG.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken))),
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 30.0),
                    child: Image.asset(
                      'assets/images/logoWhite.png',
                      width: size.width * 0.35,
                    ),
                  ),
                  //Heading
                  Padding(
                    padding: EdgeInsets.only(top: size.width * 0.05),
                    child: Text(
                      'Reset Password',
                      textAlign: TextAlign.center,
                      style: kBodyText.copyWith(
                          fontSize: size.width * 0.1,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Description Text
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'An email with password reset link will be sent to your email.',
                      textAlign: TextAlign.center,
                      style: kBodyText.copyWith(fontSize: size.width * 0.05),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Email
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: TextFormField(
                              controller: emailController,
                              style: kBodyText,
                              cursorColor: kGreen,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Email',
                                hintStyle: kBodyText.copyWith(
                                    fontSize: 20, color: kGrey),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.envelope,
                                  color: kWhite,
                                  size: 20,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 16.0,
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
                              validator: FieldValidator.email(),
                            ),
                          ),

                          SizedBox(
                            height: 25,
                          ),
                          //Login Button
                          Center(
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await _auth.sendPasswordResetEmail(
                                        emailController.text);
                                        Navigator.pop(context);
                                    Get.snackbar(
                                      'Email Sent',
                                      'Email with password reset instructions is sent',
                                      duration: Duration(seconds: 3),
                                      backgroundColor: kWhite,
                                      colorText: kGreen,
                                      borderRadius: 10,
                                    );
                                  } on FirebaseAuthException catch (error) {
                                    switch (error.code) {
                                      case "ERROR_EMAIL_ALREADY_IN_USE":
                                      case "account-exists-with-different-credential":
                                      case "email-already-in-use":
                                        setState(() {
                                          errorMessage =
                                              "Email already used. Go to login page.";
                                        });
                                        break;
                                      case "ERROR_WRONG_PASSWORD":
                                      case "wrong-password":
                                        setState(() {
                                          errorMessage =
                                              "Wrong email/password combination.";
                                        });
                                        break;
                                      case "ERROR_USER_NOT_FOUND":
                                      case "user-not-found":
                                        setState(() {
                                          errorMessage =
                                              "No user found with this email.";
                                        });
                                        break;
                                      case "ERROR_USER_DISABLED":
                                      case "user-disabled":
                                        setState(() {
                                          errorMessage = "User disabled.";
                                        });

                                        break;

                                      case "ERROR_OPERATION_NOT_ALLOWED":
                                      case "operation-not-allowed":
                                        setState(() {
                                          errorMessage =
                                              "Server error, please try again later.";
                                        });
                                        break;
                                      case "ERROR_INVALID_EMAIL":
                                      case "invalid-email":
                                        setState(() {
                                          errorMessage =
                                              "Email address is invalid.";
                                        });
                                        break;
                                      default:
                                        setState(() {
                                          errorMessage =
                                              "Login failed. Please try again.";
                                        });
                                        break;
                                    }
                                    Get.snackbar(
                                    'Error',
                                    errorMessage!,
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                    colorText: kWhite,
                                    borderRadius: 10,
                                  );
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
                                    'Send Request',
                                    style: kBodyText.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
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
      ],
    );
  }
}

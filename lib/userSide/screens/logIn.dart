import 'package:flutter/material.dart';
import 'package:my_modern_society/adminSide/screens/adminHomeScreen.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_validator/the_validator.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _obscurePassword;
  bool loading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void initState() {
    _obscurePassword = true;
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
        loading
            ? Loading()
            : GestureDetector(
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
                          padding:
                              EdgeInsets.symmetric(vertical: size.width * 0.05),
                          child: Text(
                            'Log In',
                            style: kBodyText.copyWith(
                                fontSize: size.width * 0.1,
                                fontWeight: FontWeight.bold),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                            color: kGreen, width: 1.5),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: kGreen,
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: kGreen,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    validator: FieldValidator.email(),
                                  ),
                                ),

                                //Password
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: TextFormField(
                                    controller: passwordController,
                                    style: kBodyText,
                                    obscureText: _obscurePassword,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'Password',
                                      hintStyle: kBodyText.copyWith(
                                          fontSize: 20, color: kGrey),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.lock,
                                        color: kWhite,
                                        size: 20,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                            color: kGreen, width: 1.5),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: kGreen,
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                          color: kWhite,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toggle the state of passwordVisible variable
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: FieldValidator.password(
                                        errorMessage:
                                            'Password must be of at least 6 characters',
                                        minLength: 6),
                                  ),
                                ),

                                //Forgot Password Button
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(()=> ForgotPassword());
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: kBodyText,
                                    ),
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
                                        setState(() {
                                          loading = true;
                                        });

                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                emailController.text,
                                                passwordController.text);


                                        //How Admin and homescreen is handled.
                                        if (result == null) {
                                          if (_auth.getCurrentUser() ==
                                              'SUj5uhm9jDX3EqRVW5uxDu5rWph1' || _auth.getCurrentUser() == '7Lgs69T0Ebcm2pTTpueetVCsT6h1') {
                                            Get.offAll(() => AdminHomeScreen());
                                          } else {
                                            Get.offAll(() => HomeScreen());
                                          }
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });

                                          Get.snackbar(
                                            'Error',
                                            result,
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
                                          'Log In',
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
                                //Widget to navigate to register screen
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: kBodyText,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Register",
                                          style: kBodyText.copyWith(
                                              color: kGreen,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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

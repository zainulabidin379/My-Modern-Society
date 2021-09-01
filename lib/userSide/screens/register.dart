import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_validator/the_validator.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final sectorController = TextEditingController();

  late bool _obscurePassword;
  late bool _obscureConfirmPassword;
  bool loading = false;
  bool isMale = false;
  bool isFemale = false;

  String? gender;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    cnicController.dispose();
    houseController.dispose();
    streetController.dispose();
    sectorController.dispose();
    super.dispose();
  }

  void initState() {
    _obscurePassword = true;
    _obscureConfirmPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        //Background image and black shade
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
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: size.width * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 10.0),
                          child: Image.asset(
                            'assets/images/logoWhite.png',
                            width: size.width * 0.35,
                          ),
                        ),
                        //Main Heading
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.width * 0.02),
                          child: Text(
                            'Register',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Name
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: TextFormField(
                                    controller: nameController,
                                    style: kBodyText,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'Full Name',
                                      hintStyle: kBodyText.copyWith(
                                          fontSize: 20, color: kGrey),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.user,
                                        color: kWhite,
                                        size: 20,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 10.0,
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
                                    validator: FieldValidator.multiple([
                                      FieldValidator.required(),
                                      FieldValidator.minLength(4,
                                          message: 'Please enter a valid name'),
                                    ]),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text('Gender: ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: kWhite,
                                          )),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isMale = true;
                                            isFemale = false;
                                            gender = 'male';
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: kGreen, width: 2),
                                              color: isMale
                                                  ? kGreen
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                                child: Text('Male',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: kWhite,
                                                    )))),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isFemale = true;
                                            isMale = false;
                                            gender = 'female';
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: kGreen, width: 2),
                                              color: isFemale
                                                  ? kGreen
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                                child: Text('Female',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: kWhite,
                                                    )))),
                                      )
                                    ],
                                  ),
                                ),

                                //Email
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: TextFormField(
                                    controller: emailController,
                                    style: kBodyText,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
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
                                        fontSize: 10.0,
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
                                    validator: FieldValidator.multiple([
                                      FieldValidator.required(),
                                      FieldValidator.email(),
                                    ]),
                                  ),
                                ),

                                //CNIC
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: TextFormField(
                                    controller: cnicController,
                                    style: kBodyText,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'CNIC',
                                      hintStyle: kBodyText.copyWith(
                                          fontSize: 20, color: kGrey),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.idCard,
                                        color: kWhite,
                                        size: 20,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 10.0,
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
                                    validator: FieldValidator.multiple([
                                      FieldValidator.required(),
                                      FieldValidator.minLength(13,
                                          message:
                                              'Please enter a valid CNIC (12345-1234567-0)'),
                                      FieldValidator.maxLength(15,
                                          message:
                                              'Please enter a valid CNIC (12345-1234567-0)'),
                                      FieldValidator.number(noSymbols: true),
                                    ]),
                                  ),
                                ),

                                //House Number
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: TextFormField(
                                    controller: houseController,
                                    style: kBodyText,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'House Number',
                                      hintStyle: kBodyText.copyWith(
                                          fontSize: 20, color: kGrey),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.home,
                                        color: kWhite,
                                        size: 20,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 10.0,
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
                                    validator: FieldValidator.multiple([
                                      FieldValidator.required(),
                                      FieldValidator.minLength(1,
                                          message:
                                              'Please enter a valid house number'),
                                    ]),
                                  ),
                                ),

                                //Street Number
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: TextFormField(
                                    controller: streetController,
                                    style: kBodyText,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'Street Number',
                                      hintStyle: kBodyText.copyWith(
                                          fontSize: 20, color: kGrey),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.home,
                                        color: kWhite,
                                        size: 20,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 10.0,
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
                                    validator: FieldValidator.multiple([
                                      FieldValidator.required(),
                                      FieldValidator.minLength(1,
                                          message:
                                              'Please enter a valid street number'),
                                    ]),
                                  ),
                                ),

                                //sector
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: TextFormField(
                                    controller: sectorController,
                                    style: kBodyText,
                                    cursorColor: kGreen,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'Sector',
                                      hintStyle: kBodyText.copyWith(
                                          fontSize: 20, color: kGrey),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.home,
                                        color: kWhite,
                                        size: 20,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 10.0,
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
                                    validator: FieldValidator.multiple([
                                      FieldValidator.required(),
                                      FieldValidator.minLength(0,
                                          message:
                                              'Please enter a valid sector'),
                                    ]),
                                  ),
                                ),

                                //Password
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: TextFormField(
                                      controller: passwordController,
                                      style: kBodyText,
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
                                          color: kWhite,
                                          size: 20,
                                        ),
                                        errorStyle: TextStyle(
                                          fontSize: 10.0,
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
                                      style: kBodyText,
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
                                          color: kWhite,
                                          size: 20,
                                        ),
                                        errorStyle: TextStyle(
                                          fontSize: 10.0,
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
                                            _obscureConfirmPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: kWhite,
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
                                        if (isFemale == false &&
                                            isMale == false) {
                                          Get.snackbar(
                                            'Error',
                                            'Please choose your gender!',
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.red,
                                            colorText: kWhite,
                                            borderRadius: 10,
                                          );
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result = await _auth
                                              .registerWithEmailAndPassword(
                                                  nameController.text,
                                                  gender,
                                                  emailController.text,
                                                  cnicController.text,
                                                  houseController.text,
                                                  streetController.text,
                                                  sectorController.text,
                                                  passwordController.text);

                                          if (result == null) {
                                            Get.offAll(() => HomeScreen());
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .sendEmailVerification();
                                            Get.snackbar(
                                              'Verification Email Sent!',
                                              'Check you email inbox or spam folder and follow the given link to verify your email',
                                              duration: Duration(seconds: 4),
                                              backgroundColor: kBg,
                                              colorText: kGreen,
                                              borderRadius: 10,
                                            );
                                          } else {
                                            setState(() {
                                              loading = false;
                                              Get.snackbar(
                                                'Error',
                                                result,
                                                duration: Duration(seconds: 3),
                                                backgroundColor: Colors.red,
                                                colorText: kWhite,
                                                borderRadius: 10,
                                              );
                                            });
                                          }
                                        }
                                        return;
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
                                          'Register',
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => Login());
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Already have an account?",
                                          style: kBodyText,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Log In",
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

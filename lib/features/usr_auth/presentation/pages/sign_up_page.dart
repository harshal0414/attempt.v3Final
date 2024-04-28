import 'dart:ffi';

import 'package:attempt3/features/usr_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:attempt3/features/usr_auth/presentation/pages/login_page.dart';
import 'package:attempt3/features/usr_auth/presentation/widgets/form_container_widget.dart';
import 'package:attempt3/global/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package: toast/toast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningup = false;


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  // bool passwordConfirmed(){
  //   if(_passwordController.text.trim() == _confirmpasswordController.text.trim()){
  //     return true;
  //   } else{
  //     return false;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login.png"),
            // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container for signup details
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1.0),
                    // Adjust opacity as needed
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _nameController,
                        hintText: "Name",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _ageController,
                        hintText: "Age",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _genderController,
                        hintText: "Gender",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _emailController,
                        hintText: "Email",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _passwordController,
                        hintText: "Password",
                        isPasswordField: true,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          _signUp();
                          showToast(message: "User is Successfully Created!");
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isSigningup
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),)
                                : Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()), (
                                      route) => false);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() {
      isSigningup = true;
    });

    String name = _nameController.text.trim();
    int age = int.parse(_ageController.text.trim());
    String gender = _genderController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        isSigningup = false;
      });

      User? user = userCredential.user;

      if (user != null) {
        showToast(message: "User successfully created");
        Navigator.pushNamed(context, "/home_page");

        // Add user details to Firestore
        await addUserDetails(name, age, gender, email);
      } else {
        showToast(message: "Failed to create user");
      }
    } catch (e) {
      setState(() {
        isSigningup = false;
      });

      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        showToast(message: "Email already in use");
      } else {
        print("Sign up failed: $e");
      }
    }
  }



  Future addUserDetails(String name, int age, String gender, String email) async{
    await FirebaseFirestore.instance.collection('Users').add({
      'Name':name,
      'Age':age,
      'Gender':gender,
      'Email':email,
    });

  }

}

class _confirmpasswordController {
}
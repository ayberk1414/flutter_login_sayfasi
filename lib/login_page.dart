import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/AppColors.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/service/auth_service.dart';
import 'package:flutter_application_1/widegets/custom_test_button.dart';

import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside of TextField
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Add this line
                children: [
                  buildTopImage(height),
                  buildLoginForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildTopImage(double height) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/topImage.png"))),
    );
  }

  Padding buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildWelcomeText(),
          buildEmailField(),
          customSizedBox(),
          buildPasswordField(),
          customSizedBox(),
          buildSignInButton(),
          buildForgotPasswordButton(),
          buildSignUpButton(context),
          customSizedBox(),
          buildGuestSignInButton(context),
        ],
      ),
    );
  }

  Text buildWelcomeText() {
    return Text("Merhaba,\nHosgeldın",
        style: TextStyle(fontSize: 30, color: Colors.white));
  }

  TextFormField buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz giriniz";
        } else {}
      },
      onSaved: ((newValue) => email = newValue!),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz giriniz";
        } else {}
      },
      onSaved: ((newValue) => password = newValue!),
      decoration: customInputDecoration("Password"),
    );
  }

  ElevatedButton buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        signInWithEmailAndPassword();
      },
      child: Text('Giriş Yap'),
      style: ElevatedButton.styleFrom(primary: AppColors.primaryDarkColor),
    );
  }

  TextButton buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // TODO: Implement forgot password functionality
      },
      child: Text('Şifremi Unuttum', style: TextStyle(color: Colors.white)),
    );
  }

  void signInWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final result = await authService.signIn(email, password);
      if (result == "success") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => homePage()));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Hata"),
            content: Text(result!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // AlertDialog'u kapatır
                },
                child: Text('Tamam', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );
      }
    } else {}
  }

  CustomButton buildSignUpButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        // Navigate to SignUpPage
        navigateToSignUpPage(context);
      },
      buttonText: 'Hesap Oluştur',
      buttonColor: Colors.blue,
    );
  }

  CustomButton buildGuestSignInButton(BuildContext context) {
    return CustomButton(
      buttonText: "Misafir girişi",
      onPressed: (() async {
        signInAsGuest(context);
      }),
    );
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
  }

  void navigateToSignUpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void signInAsGuest(BuildContext context) async {
    final result = await authService.signInAnonymous();
    if (result != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => homePage())));
    } else {
      print("hata ile karsilandi");
    }
  }
}

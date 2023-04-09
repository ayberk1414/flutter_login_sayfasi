import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/service/auth_service.dart';

import 'color/AppColors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String email, password, firstName, lastName, userName;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkColor,
        title: Text("Hesap Oluştur"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildSignUpForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildSignUpForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            buildTitleText(),
            customSizedBox(),
            buildNameFields(),
            customSizedBox(),
            buildUserNameField(),
            customSizedBox(),
            buildEmailField(),
            customSizedBox(),
            buildPasswordField(),
            customSizedBox(),
            buildCreateAccountButton(context),
          ],
        ),
      ),
    );
  }

  Text buildTitleText() {
    return Text("Hesap Oluştur",
        style: TextStyle(fontSize: 30, color: Colors.white));
  }

  TextFormField buildFirstNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz giriniz";
        } else {}
      },
      onSaved: ((newValue) => firstName = newValue!),
      decoration: customInputDecoration("Ad"),
    );
  }

  TextFormField buildLastNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz giriniz";
        } else {}
      },
      onSaved: ((newValue) => lastName = newValue!),
      decoration: customInputDecoration("Soyad"),
    );
  }

  TextFormField buildUserNameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz giriniz";
        } else {}
      },
      onSaved: ((newValue) => userName = newValue!),
      decoration: customInputDecoration("Kullanıcı Adı"),
    );
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

  ElevatedButton buildCreateAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        createAccount(context);
      },
      child: Text('Hesap Oluştur'),
      style: ElevatedButton.styleFrom(primary: AppColors.primaryDarkColor),
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

  void showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Kullanıcı başarıyla oluşturuldu, giriş sayfasına yönlendiriliyorsunuz")));
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Widget buildNameFields() {
    return Row(
      children: [
        Expanded(child: buildFirstNameField()),
        SizedBox(width: 10),
        Expanded(child: buildLastNameField()),
      ],
    );
  }

  void createAccount(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String? signUpResult =
          await authService.signUp(email, password, firstName, lastName);

      if (signUpResult == "success") {
        formKey.currentState?.reset();
        showSuccessSnackBar(context);
        navigateToLoginPage(context);
      } else {
        showErrorSnackBar(context, signUpResult);
      }
    }
  }

  void showErrorSnackBar(BuildContext context, String? errorMessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Hata: $errorMessage")));
  }
}

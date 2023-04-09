import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  Future signInAnonymous() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      print(result.user!.uid);
      return result.user;
    } catch (e) {
      print("Anon error $e*");
      return null;
    }
  }

  Future forgotPassword(String email) async {
    try {
      final result = await firebaseAuth.sendPasswordResetEmail(email: email);
      print("epostayı kontrol et");
    } catch (e) {}
  }

  Future signIn(String email, String password) async {
    String? res;
    try {
      final reault = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "Kullanıcı bulamadı";
      } else if (e.code == "arong-password") {
        res = "Sifre yanliş";
      } else if (e.code == "user-disabled") {
        res = "Kullanıcı pasif";
      } else {}
    }
    return res;
  }

  Future<String?> signUp(
      String email, String password, String fullname, String lastName) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      try {
        final resultData = await firebaseFirestore.collection("Users").add({
          "email": email,
          "fullname": fullname,
          "post": [],
          "followers": [],
          "following": [],
          "bio": "",
          "website": ""
        });
      } catch (e) {
        print("$e");
      }
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          res = "Mail Zaten Kayıtlı";
          break;
        case "invalid-email":
          res = "Gecersiz Mail";
          break;
        case "operation-not-allowed":
          res = "Operasyon izin verilmedi";
          break;
        case "weak-password":
          res = "Zayıf şifre";
          break;
        default:
          res = "Bir hata oluştu";
      }
    } catch (e) {
      res = "Bir hata oluştu: $e";
    }
    return res;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import '../../../configs/app_strings.dart';
import '../../ui/views/login/login_screen.dart';
import '../models/base_model.dart';
import '../models/user_entity_model.dart';
import '../utils/firebase_exception_utility.dart';

class RegisterViewModel extends BaseModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? errorMessage;

  void signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(status: AppStrings.loading);
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then<void>((value) => postDetailsToFirestore())
            .catchError((e) {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: e!.message);
        });
        EasyLoading.dismiss();
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        firebaseCurrentFailure(error);
      }
    }
  }

  void postDetailsToFirestore() async {
    EasyLoading.show(status: AppStrings.loading);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.password = passwordController.text;

    await firebaseFirestore
        .collection(AppStrings.user)
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: AppStrings.accountCreated);

    clearController();
    EasyLoading.dismiss();
    Get.offAll(()=>LoginScreen());
  }

  clearController() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}

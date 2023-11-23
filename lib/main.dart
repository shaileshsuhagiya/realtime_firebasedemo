import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/binding/binding_view_models.dart';
import 'package:firebasedemo/src/user_functionality/ui/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebasedemo/src/constant/constants.dart';
import 'package:firebasedemo/src/core/helpers/dark_light_helper.dart';
import 'package:firebasedemo/src/user_functionality/business_logic/utils/app_preference.dart';
import 'package:firebasedemo/src/user_functionality/services/dependency_assembler_education.dart'
    as user;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'src/user_functionality/ui/views/login/login_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppPreference.init();
  await Firebase.initializeApp();
  await user.setupDependencyAssemblerEducation();
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final email = AppPreference.getString(PreferencesConstants.USER_EMAIL);

  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      initialBinding: BindingViewModels(),
      home: email == null ? LoginScreen() : HomeScreen(),
    );
  }
}

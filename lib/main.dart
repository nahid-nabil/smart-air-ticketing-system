import 'package:booktickets/screens/bottom_bar.dart';
import 'package:booktickets/screens/login_screen.dart';
import 'package:booktickets/services/auth_service.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(

        primaryColor: primary,
      ),
      home: Obx(() {
        final authService = AuthService.instance;
        return authService.firebaseUser.value != null
            ? const BottomBar()
            : const LoginScreen();
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../controller/seller_controller.dart';
import '../../model/seller_model.dart';
import '../auth_screen/business_details_inputs.dart';
import '../auth_screen/login_screen.dart';
import '../bottom_navigation/bottom_navigation.dart';


class SplashScreen extends StatelessWidget {
  final FirebaseController _firebaseController = Get.find();

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delay for 2 seconds before navigating to the next screen
    Future.delayed(const Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? phoneNumber = prefs.getString('phonee');

      if (phoneNumber != null) {
        // Check if there is seller data
        SellerModel? sellerData = await _firebaseController.getSellerData();
        if (sellerData == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Business_details_input()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Bottom_navigation()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });

    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Image.asset(
          bayapar,
          height: MediaQuery.of(context).size.height / 1,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }
}

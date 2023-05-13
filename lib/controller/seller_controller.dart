
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/seller_model.dart';
class FirebaseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<void> saveSellerData(SellerModel seller) async {
    try {
      final uid = _auth.currentUser!.uid;
      final sellerRef = _firestore.collection('seller').doc(uid);
      await sellerRef.set(seller.toMap());
      Get.snackbar('Success', 'Seller data saved successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save seller data.');
    }
  }

  Future<SellerModel?> getSellerData() async {
    try {
      final uid = _auth.currentUser!.uid;

      final sellerRef = _firestore.collection('seller').doc(uid);
      final sellerSnapshot = await sellerRef.get();
      if (sellerSnapshot.exists) {
        final sellerData = SellerModel.fromMap(sellerSnapshot.data()!);
        return sellerData;
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get seller data.');
      return null;
    }
  }


}

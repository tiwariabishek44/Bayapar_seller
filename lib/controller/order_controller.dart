import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/order_model.dart';


class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _orderCollection =
  FirebaseFirestore.instance.collection('orders');

  // Define the order list as an RxList
  RxList<Orders> _orders = <Orders>[].obs;

  // Getter method to access the products list
  List<Orders> get orders => _orders.value;

  Future<void> getorders(String sellerPhone) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('orders')
        .where('sellerPhone', isEqualTo: sellerPhone)
        .get();
    final ordr = querySnapshot.docs.map((doc) {
      return Orders.fromMap(doc.data());
    }).toList();
    _orders.assignAll(ordr);
  }

  Future<void> onroad(String orderId) async {
    try {
      await _orderCollection.doc(orderId).update({'isOnRoad': true});
    } catch (e) {
      print(e);
    }
  }

  Future<void> confirmOrder(String orderId) async {
    try {
      await _orderCollection.doc(orderId).update({'isConfirmed': true});
    } catch (e) {
      print(e);
    }
  }
  Future<void> orderPack(String orderId) async {
    try {
      await _orderCollection.doc(orderId).update({'isPackaging': true});
    } catch (e) {
      print(e);
    }
  }

  Future<void> markOrderAsDelivered(String orderId) async {
    try {
      await _orderCollection.doc(orderId).update({'isDelivered': true});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteOrder(Orders order) async {
    try {
      await _orderCollection.doc(order.id!).delete();
      Get.snackbar('Success', 'Order deleted');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  Future<void> discoutUpdate(String orderId,double discountPrice,double totalprice) async {
    try {
      await _orderCollection.doc(orderId).update({'discount': discountPrice,'totalPrice':totalprice});
      Get.snackbar('Success', 'Price update succesfully');

    } catch (e) {
      Get.snackbar('Success', 'Price doesnot update');
    }
  }



}


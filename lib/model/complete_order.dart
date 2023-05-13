

import 'cart_model.dart';

class CompleteOrders {
  String? id;
  late final String buyerPhone;

  late final String supplierName;
  late final String retailerShopName; // new field to identify retailer shop
  late final List<CartItem> cartItems;
  late final String municipality;
  late final String street;
  late final String address;
  late final double totalPrice;
  late final String orderDate;
  late final String paymentMethod;
  late final bool isConfirmed;
  late final bool isPackaging;
  late final bool isOnRoad;
  late final String time;

  CompleteOrders({
    this.id,
    required this.buyerPhone,
    required this.supplierName,
    required this.retailerShopName,
    required this.cartItems,
    required this.municipality,
    required this.street,
    required this.address,
    required this.totalPrice,
    required this.orderDate,
    required this.paymentMethod,
    required this.isConfirmed,
    required this.isPackaging,
    required this.isOnRoad,
    required this.time
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerPhone': buyerPhone,
      'supplierName': supplierName,
      'retailerShopName': retailerShopName,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'municipality': municipality,
      'street': street,
      'address': address,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'isConfirmed': isConfirmed,
      'isPackaging': isPackaging,
      'isOnRoad': isOnRoad,
      'time':time
    };
  }

  static CompleteOrders fromMap(Map<String, dynamic> map,) {
    return CompleteOrders(
      id: map['id'],
      buyerPhone: map['buyerPhone'],
      supplierName: map['supplierName'],
      retailerShopName: map['retailerShopName'],
      cartItems: List<CartItem>.from(
        map['cartItems'].map((item) => CartItem.fromMap(item)),
      ),
      municipality: map['municipality'],
      street: map['street'],
      address: map['address'],
      totalPrice: map['totalPrice'].toDouble(),
      orderDate: map['orderDate'],
      paymentMethod: map['paymentMethod'],
      isConfirmed: map['isConfirmed'],
      isPackaging: map['isPackaging'],
      isOnRoad: map['isOnRoad'],
      time:map['time'],
    );
  }
}

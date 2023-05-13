import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/consts.dart';
import '../../controller/order_controller.dart';
import '../../model/order_model.dart';
import 'orderStatus.dart';
import 'orders_details.dart';

class Order_completed extends StatefulWidget {


  @override
  State<Order_completed> createState() => _Order_completedState();
}

class _Order_completedState extends State<Order_completed> {
  NepaliDateTime _nepaliDate = NepaliDateTime.now();

  String phoneNumber ='';
  final orderController = Get.find<OrderController>();
  Future<String?> _getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phonee');

  }

  @override
  void initState() {
    super.initState();
    _getPhoneNumber().then((value) {
      setState(() {
        phoneNumber = value!.substring(4);
        orderController.getorders(phoneNumber);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          color: darkFontGrey, // set icon color to black
        ),
        title: Text(
          "Orders Completed",
          style: TextStyle(fontFamily: semibold, color: redColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              '${_nepaliDate.year}-${_nepaliDate.month}-${_nepaliDate.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: darkFontGrey,
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final reversedOrders = orderController.orders
              .where((order) => order.isOnRoad==true)
              .toList()
              .toList();
          if (reversedOrders.isEmpty) {
            return Center(
              child: Text('No orders completed to show'),
            );
          }

          return ListView.builder(
            itemCount: reversedOrders.length,
            itemBuilder: (context, index) {
              final order = reversedOrders[index];
              return InkWell(
                onTap: () {
                  Get.to(() => OrderDetails(orders: order,
                  ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order ID: ${order.id}",
                              style: TextStyle(
                                fontFamily: semibold,
                                fontSize: 16,
                                color: darkFontGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                icTrash,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                        10.heightBox,
                        Text(
                          "Shop: ${order.retailerShopName}",
                          style: TextStyle(
                            color: redColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.heightBox,
                        Text(
                          "Total: Rs. ${order.totalPrice}",
                          style: TextStyle(
                            color: darkFontGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.heightBox,
                        Text(
                          "Date: ${order.orderDate}",
                          style: TextStyle(
                            color: darkFontGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),5.heightBox,
                        Text(
                          "Date: ${order.time}",
                          style: TextStyle(
                            color: darkFontGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.heightBox,
                        OrderStatusWidget(orderStatusList: orderStatusList(order)),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );

  }
}

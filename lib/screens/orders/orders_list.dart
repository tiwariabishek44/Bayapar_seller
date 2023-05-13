import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/consts.dart';
import '../../controller/order_controller.dart';
import '../../model/discount_model.dart';
import '../../model/order_model.dart';
import 'orderStatus.dart';
import 'orders_details.dart';

class OrderPage extends StatefulWidget {


  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
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



  void _showDiscountPriceDialog(BuildContext context,String id, double totalprice, double actualdiscount) {
    double _discountPrice = 0.0;
    double total_discount =0.0;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Discount Price'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Update the discount price variable as the user types
              _discountPrice = double.tryParse(value) ?? 0.0;
               total_discount = _discountPrice + actualdiscount;
            },
            decoration: InputDecoration(
              hintText: 'Enter discount price',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update ,${_discountPrice.toStringAsFixed(2)}'),
              onPressed: () {
                // Do something with the updated discount price, e.g. update the state
                setState(() {
                  // Update the discount price in the state
                  orderController.discoutUpdate(id, total_discount, totalprice-_discountPrice);
                  orderController.getorders(phoneNumber);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          "Orders,",
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
          return  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'There are no orders.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          final incompleteOrder = orderController.orders
              .where((order) => !order.isOnRoad)
              .toList().toList();
          if (incompleteOrder.isEmpty) {
            return Center(
              child: Text('No orders to show'),
            );
          }

          return ListView.builder(
            itemCount: incompleteOrder.length,
            itemBuilder: (context, index) {
              final order = incompleteOrder[index];
              return InkWell(
                onTap: () {
                  Get.to(() => OrderDetails(orders: order,
                    updateCartList:  () {
                      orderController.getorders(phoneNumber);
                      // Your code to update the product list screen goes here
                    },



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
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Order'),
                                      content: Text('Are you sure you want to delete this order?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            orderController.deleteOrder(order);
                                            setState(() {
                                              orderController.getorders(phoneNumber);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );                              },
                              child: Image.asset(
                                icTrash,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                        10.heightBox,
                       order.isDiscount==true? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _showDiscountPriceDialog(context,'${order.id}',order.totalPrice,order.discount);
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ):Container(),

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
                          "Discount: Rs. ${order.discount}",
                          style: TextStyle(
                            color: darkFontGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),5.heightBox,
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

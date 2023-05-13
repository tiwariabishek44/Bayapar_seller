import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../consts/consts.dart';
import 'package:flutter/material.dart';
import '../../controller/order_controller.dart';
import '../../model/order_model.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class OrderDetails extends StatefulWidget {
  final Orders orders;
  final VoidCallback? _updateCartList;

  const OrderDetails({Key? key, required this.orders,VoidCallback? updateCartList})   :
        _updateCartList = updateCartList,  super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final orderController = Get.find<OrderController>();

  late bool _isOrderConfirmed;
  late bool _isOrderPackaged;
  late bool _isOnRoad;

  @override
  void initState() {
    super.initState();
    _isOrderConfirmed = widget.orders.isConfirmed;
    _isOrderPackaged = widget.orders.isPackaging;
    _isOnRoad = widget.orders.isOnRoad;
  }

  void _confirmOrder(String id) {
    if (_isOrderConfirmed==false) {
      _isOrderConfirmed = true;
      orderController.confirmOrder(id);
      setState(() {});
    }
  }

  void _packageOrder(String id) {
    if (_isOrderConfirmed ==true && _isOrderPackaged == false) {
      _isOrderPackaged = true;
      orderController.orderPack(id);
      setState(() {});
    }
  }

  void _markOnRoad(String id) {
    if (_isOrderPackaged == true  && _isOnRoad ==false) {
      _isOnRoad = true;
      orderController.onroad(id);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (widget._updateCartList != null) {
              widget._updateCartList!();
            }
            Navigator.pop(context);

            Get.back();},
          color: Colors.black,
        ),
             actions: [
            IconButton(
              icon: Icon(Icons.phone,color: Colors.red,),
              // ignore: deprecated_member_use
              onPressed: () async{

                FlutterPhoneDirectCaller.callNumber(widget.orders.buyerPhone);


              }
            ),
          ],
        title: Text(
          "Order Details",
          style: TextStyle(
            fontFamily: 'Bold',
            color: Colors.red,
            fontSize: 24,
          ),
        ),
      ),
      body:Obx(() {
      if (orderController.orders.isEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {



        return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Order confirmed'),
              trailing: Checkbox(
                value: _isOrderConfirmed,
                onChanged: (_) => _confirmOrder('${widget.orders.id}'),
              ),
            ),
            ListTile(
              title: Text('Order packaged'),
              trailing: Checkbox(
                value: _isOrderPackaged,
                onChanged: (_) => _packageOrder('${widget.orders.id}'),
              ),
              enabled: _isOrderConfirmed,
            ),
            ListTile(
              title: Text('On road'),
              trailing: Checkbox(
                value: _isOnRoad,
                onChanged: (_) => _markOnRoad('${widget.orders.id}'),
              ),
              enabled: _isOrderPackaged,
            ),

            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Products",
                    style: TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.orders.cartItems.length,
                    itemBuilder: (context, index) {
                      final orderproducts = widget.orders.cartItems[index];

                      return ListTile(
                        leading: Image.network(orderproducts.imageUrl),
                        title: Text("${orderproducts.productname}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            5.heightBox,
                            Text('Variant: ${orderproducts.variant}'),
                            5.heightBox,
                            Text('Quantity: ${orderproducts.quantity} set'),
                            5.heightBox,
                            Text('Total Price: \Rs  ${orderproducts.price}'),
                            10.heightBox,

                          ],
                        ),
                      ).box.green50.margin(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(const EdgeInsets.all(8)).make();
                    },
                  ),
                ],
              ),
            ),

            10.heightBox,// Accounting container
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop name:'),
                          Text('${widget.orders.retailerShopName}', style: TextStyle(color: darkFontGrey, fontFamily: semibold,),),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop Phone:'),
                          Text('${widget.orders.buyerPhone}', style: TextStyle(color: darkFontGrey, fontFamily: semibold,),),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Address:'),
                          Text('${widget.orders.address}', style: TextStyle(color: darkFontGrey, fontFamily: semibold,),),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Municipality'),
                          Text('${widget.orders.municipality}'),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Street'),
                          Text('${widget.orders.street}'),
                        ],
                      ),5.heightBox,

                    ]),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Code:'),
                          Text('${widget.orders.id}', style: TextStyle(color: redColor, fontFamily: semibold,),),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date:'),
                          Text('${widget.orders.orderDate}'),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time:'),
                          Text('${widget.orders.time}'),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment:'),
                          Text('COD'),
                        ],
                      ),5.heightBox,


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal:'),
                          Text('Rs.${widget.orders.totalPrice + widget.orders.discount}'),
                        ],
                      ),
                      SizedBox(height: 8.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logistic Cost:'),
                          Text('Rs.00'),
                        ],
                      ),
                      SizedBox(height: 8.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount:'),
                          Text('Rs.${widget.orders.discount}'),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Grand Total:'),
                          Text('Rs.${widget.orders.totalPrice}'),
                        ],
                      ),
                    ]),)
              ,
            ),20.heightBox,
          ],
        ),
      );
      }
      }),
    );
  }


}








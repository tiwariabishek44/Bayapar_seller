import 'package:bayapar_seller/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/product controller.dart';
import '../../model/product model.dart';
class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _generatePriceString(List<double> priceList) {
    if (priceList.length == 1) {
      return '[Rs.${priceList[0]}]';
    } else if (priceList.length == 2) {
      return '[Rs.${priceList[0]}, Rs.${priceList[1]}]';
    } else {
      List<String> priceStrings = priceList.map((price) => 'Rs.$price').toList();
      String lastTwoPrices = priceStrings.sublist(priceStrings.length - 2).join(', ');
      return '[${priceStrings.sublist(0, priceStrings.length - 2).join(', ')}, $lastTwoPrices]';
    }
  }

  bool loading = false;

  String phoneNumber ='';

  final productController = Get.find<ProductController>();

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
        productController.getProducts(phoneNumber);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.heightBox,
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 300,
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  20.heightBox,
                  Text(
                    'Size ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Variant : ${widget.product.variantList.join(", ")}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total pices: ${_generatePriceString(widget.product.mrpList)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  20.heightBox,
                  Text(
                    'Price Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    'Price of product: ${_generatePriceString(widget.product.priceList)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Margin to retailer: Rs${_generatePriceString(widget.product.marginList)}',
                    style: TextStyle(fontSize: 16),
                  ),


                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(widget.product.description ?? ''),
                  SizedBox(height: 16),

                  SizedBox(height: 8),
                ],
              ),
            ),


          ],
        ),
      ),
    );}}

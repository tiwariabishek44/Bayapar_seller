import 'package:bayapar_seller/screens/products/product_detail_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/consts.dart';
import '../../controller/product controller.dart';
import '../../model/product model.dart';
import 'add_product.dart';

class ProductListScreen extends StatefulWidget {
  @override

  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

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

  NepaliDateTime _nepaliDate = NepaliDateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          elevation: 0.5,
          title: Text(
            "Product list",
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
        if (productController.products.isEmpty) {
          return Center(
            child: Text('Add some product'),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GridView.builder(
              itemCount: productController.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return GestureDetector(
                    onTap: (){Get.to(()=>ProductDetailPage(product: product,));},
                    child: _buildItemCard(product));
              },
            ),
          );
        }
      }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddProductScreen(updateProductList: () {
              productController.getProducts(phoneNumber);
              // Your code to update the product list screen goes here
            }
            ));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xffff2d55), // Add this line to set the background color to red
        )

    );
  }
}

Widget _buildItemCard(ProductModel product) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: Colors.grey[300]!, width: 1.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded (
          child: Container(
            height: 150.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              image: DecorationImage(
                image: NetworkImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                'Price: Rs. ${product.priceList.first.toInt()}-${product.priceList.last.toInt()}',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 4.0),

            ],
          ),
        ),
      ],
    ),
  );
}
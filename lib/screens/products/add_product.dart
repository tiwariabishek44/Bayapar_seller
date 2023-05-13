
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts/consts.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../controller/product controller.dart';
import '../../widgets/custom_textfield.dart';





class AddProductScreen extends StatefulWidget {
  final VoidCallback? _updateProductList;

  AddProductScreen({Key? key, VoidCallback? updateProductList})
      : _updateProductList = updateProductList,
        super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}
class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController = Get.find<ProductController>();
  bool loading = false;

  String phoneNumber = '';
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
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final TextEditingController _variantController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _marginController = TextEditingController();
  final TextEditingController _productname =TextEditingController();
  final TextEditingController _subcategory = TextEditingController();

  @override
  void dispose() {
    _variantController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _marginController.dispose();
    super.dispose();
  }


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  List<double> parsePriceList(String priceList) {
    List<String> values = priceList.split(',');
    return values.map((value) => double.tryParse(value.trim()) ?? 0.0).toList();
  }
  List<String> parseStringList(String listString) {
    List<String> values = listString.split(',');
    return values.map((value) => value.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.1,
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
    onPressed: () => Get.back(),
    color: darkFontGrey, // set icon color to black
    ),
    title: Text(
    "Add product",
    style: TextStyle(fontFamily: semibold, color: redColor),
    ),),

    body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    )
                        : Center(
                      child: Text('Pick an image'),
                    ),
                  ),
                ),



                SizedBox(height: 16),
                TextFormField(
                  controller: _productname,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    labelText: 'Product name',
                    border: OutlineInputBorder(),
                  ),

                ),
                10.heightBox,

                SizedBox(height: 16.0),
                TextFormField(
                  controller: _subcategory,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  labelText: 'Sub Category',
                  border: OutlineInputBorder(),
                ),

              ),
              const SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    labelText: 'Price (comma-separated)',
                    border: OutlineInputBorder(),
                  ),

                ),
              const SizedBox(height: 16.0),
              TextFormField(
              controller: _variantController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  labelText: 'Variants (comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _marginController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  labelText: 'Margins (comma-separated)',
                  border: OutlineInputBorder(),
                ),

              ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller:  _mrpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    labelText: 'NO of. pices (comma-separated)',
                    border: OutlineInputBorder(),
                  ),

                ),
              const SizedBox(height: 32.0),

                SizedBox(
                  height: 50,
                  child:ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      // Create a dummy product

                      // Call the addProduct method of the ProductController to add the product
                      await productController.addProduct(
                          subcategory: _subcategory.text.trim(),
                          name: _productname.text,
                          priceList: parsePriceList(_priceController.text.trim()),
                          marginList: parsePriceList(_marginController.text.trim()),
                          mrpList: parsePriceList(_mrpController.text.trim()),
                          variantList: parseStringList(_variantController.text.trim()),
                          supplierName: 'Him Shikhar Traders',
                          supplierPhoneNumber: phoneNumber,
                          description: 'This is a dummy product.',
                          currentStock: 50,
                          minimumStockAlert: 10,
                          stockInput: 10,
                          totalUnitsSold: 100,
                          revenue: 1000.0,
                          imageFile: _imageFile!);

                      setState(() {
                        loading = false;
                      });

                      // Call the updateProductList callback to update the product list screen
                      if (widget._updateProductList != null) {
                        widget._updateProductList!();
                      }

                      // Navigate back to the previous screen
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: loading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text('Add Product'),
                  ),


                  // ElevatedButton(
                  //   onPressed: _submitForm,
                  //
                  // ),
                ),

              ]
            ),
          ),
        ),

    ));
  }
}

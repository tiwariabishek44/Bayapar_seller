


import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts/consts.dart';
import 'category controller.dart';

class AddCategory extends StatefulWidget {
  final VoidCallback? _updateProductList;

  AddCategory({Key? key, VoidCallback? updateProductList})
      : _updateProductList = updateProductList,
        super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}
class _AddCategoryState extends State<AddCategory> {
  final CategoriController productController = Get.find<CategoriController>();
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
      });
    });
  }
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  final TextEditingController range = TextEditingController();
  final TextEditingController _categoryname =TextEditingController();

  void dispose() {
    super.dispose();
  }


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
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
                      controller: _categoryname,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Category name',
                        border: OutlineInputBorder(),
                      ),

                    ),
                    10.heightBox,

                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: range,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Range',
                        border: OutlineInputBorder(),
                      ),

                    ),

                    SizedBox(
                      height: 50,
                      child:ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });

                          // Create a dummy product

                          // Call the addProduct method of the ProductController to add the product
                          await productController.addCategories(
                              name: _categoryname.text.trim(), range: range.text.trim(),

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
                    ),

                  ]
              ),
            ),
          ),

        ));
  }
}

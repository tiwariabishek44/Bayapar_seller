import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/colors.dart';
import '../consts/styles.dart';
import 'add categorypage.dart';
import 'category controller.dart';
import 'category mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add categorypage.dart';
import 'category controller.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  final categoryController = Get.find<CategoriController>();

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryController.getCategories();

    });
  }



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

      ),
      body: Obx(() {
        if (categoryController.categories.isEmpty) {
          return Center(
            child: Text('Add some product'),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GridView.builder(
              itemCount: categoryController.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = categoryController.categories[index];
                return  Container(
                  height: 100.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddCategory(
              updateProductList: () {
                categoryController.getCategories();
              }));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xffff2d55),
      ),
    );
  }
}

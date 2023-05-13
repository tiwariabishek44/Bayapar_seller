 import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../model/product model.dart';



 class ProductController extends GetxController {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   // Define the products list as an RxList
   RxList<ProductModel> _products = <ProductModel>[].obs;

   // Getter method to access the products list
   List<ProductModel> get products => _products.value;


   Future<void> addProduct({
     required String subcategory,
     required String name,
     required List<double> priceList,
     required List<double> marginList,
     required List<double> mrpList,
     required List<String> variantList,
     required String supplierName,
     required String supplierPhoneNumber,
     required String description,
     required int currentStock,
     required int minimumStockAlert,
     required int stockInput,
     required int totalUnitsSold,
     required double revenue,
     required File imageFile,
   }) async {
     // Get a reference to the Firebase Storage instance
     final storage = FirebaseStorage.instance;

     // Generate a unique filename for the image
     final filename = '${DateTime.now().microsecondsSinceEpoch}.jpg';

     // Upload the image to Firebase Storage
     final task = storage.ref().child(filename).putFile(imageFile);
     final snapshot = await task.whenComplete(() {});

     // Get the public URL of the uploaded image
     final imageUrl = await snapshot.ref.getDownloadURL();

     // Create a new product model with the uploaded image URL
     final product = ProductModel(
       subcategory: subcategory.trim(),
       name: name,
       image: imageUrl,
       priceList: priceList,
       marginList: marginList,
       mrpList: mrpList,
       variantList: variantList,
       supplierName: supplierName,
       supplierPhoneNumber: supplierPhoneNumber,
       description: description,
       currentStock: currentStock,
       minimumStockAlert: minimumStockAlert,
       stockInput: stockInput,
       totalUnitsSold: totalUnitsSold,
       revenue: revenue,
     );

     // Add the product to the "Products" collection in Firestore
     await _firestore.collection('product').add(product.toMap());
   }

   Future<void> updateProduct(ProductModel product) async {
     final docId = await _firestore
         .collection('product')
         .where('supplierPhoneNumber', isEqualTo: product.supplierPhoneNumber)
         .where('name', isEqualTo: product.name)
         .where('image', isEqualTo: product.image)
         .get()
         .then((snapshot) => snapshot.docs.first.id);
     await _firestore.collection('products').doc(docId).update(product.toMap());
   }

   Future<void> deleteProduct(ProductModel product, String phoneno) async {
     final docId = await _firestore
         .collection('product')
         .where('supplierPhoneNumber', isEqualTo: phoneno)
         .where('name', isEqualTo: product.name)
         .where('image', isEqualTo: product.image)
         .get()
         .then((snapshot) => snapshot.docs.first.id);
     await _firestore.collection('products').doc(docId).delete();
     Get.snackbar('Success', 'Product deleted');

   }

   Future<void> getProducts(String supplierPhoneNumber) async {
     final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
         .collection('product')
         .where('supplierPhoneNumber', isEqualTo: supplierPhoneNumber)
         .get();
     final products = querySnapshot.docs.map((doc) {
       return ProductModel.fromMap(doc.data());
     }).toList();
     _products.assignAll(products);
   }
 }

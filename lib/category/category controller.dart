import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'category mode.dart';
import 'package:firebase_storage/firebase_storage.dart';
class CategoriController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _categoryCollection =
  FirebaseFirestore.instance.collection('categor');

  RxList<Categories> _category = <Categories>[].obs;

  List<Categories> get categories => _category.value;

  Future<void> addCategories({
    required String name,
    required File imageFile,
    required String range,
  }) async {
    // Upload image file to Firebase Storage
    final storageReference =
    FirebaseStorage.instance.ref().child('categor/$name.jpg');
    final uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() {});

    // Get download URL for uploaded image
    final downloadURL = await storageReference.getDownloadURL();

    // Create category object with download URL
    final category = Categories(
      name: name,
      range: range,
      image: downloadURL,
    );

    // Add category to Firestore
    await _categoryCollection.add(category.toMap());
  }

  Future<void> getCategories() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _firestore.collection('categor').orderBy('range').get();
    final categories = querySnapshot.docs.map((doc) {
      return Categories.fromMap(doc.data());
    }).toList();
    _category.assignAll(categories);
  }
}

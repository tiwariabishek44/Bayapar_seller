import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';

class DA {
  String admin;
  String dcamount;

  DA({
    required this.admin,required this.dcamount});

  factory DA.fromMap(Map<String, dynamic> json) => new DA(
    admin: json["admin"],
    dcamount: json["dcamount"],
  );

  Map<String, dynamic> toMap() => {
    "admin": admin,
    "dcamount": dcamount,
  };
}



class DAController {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('das');

  Future<void> addDA(DA da) async {
    try {
      await collection.add(da.toMap());
      Get.snackbar('Success', 'Price doesnot update');
      Get.snackbar('Success', 'discount added');

    } catch (e) {
      Get.snackbar('Success', 'Price doesnot update');


    }
  }

  Future<DA?> getDA() async {
    try {
      var querySnapshot =
      await collection.where('admin', isEqualTo: 'admin').get();
      if (querySnapshot.docs.isNotEmpty) {
        var docSnapshot = querySnapshot.docs.first;
        return DA.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar('Success', 'Price does not update');
      return null;
    }
  }
}





class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _dcamount = '';

  @override
  void initState() {
    super.initState();
    _fetchDA();
  }

  Future<void> _fetchDA() async {
    var da = await DAController().getDA();
    setState(() {
      _dcamount = da?.dcamount ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DC Amount: $_dcamount'),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  }
}


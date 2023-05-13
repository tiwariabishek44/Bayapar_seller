import 'dart:async';
import 'package:bayapar_seller/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'category/category controller.dart';
import 'consts/colors.dart';
import 'consts/strings.dart';
import 'consts/styles.dart';
import 'controller/order_controller.dart';
import 'controller/product controller.dart';
import 'controller/seller_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CategoriController());
  Get.put(FirebaseController());
  Get.put(ProductController());
  Get.put(OrderController());
  runApp(BayaparSeller());
}
class BayaparSeller extends StatefulWidget {
  const BayaparSeller({Key? key}) : super(key: key);
  @override
  _BayaparSellerState createState() => _BayaparSellerState();
}
class _BayaparSellerState extends State<BayaparSeller> {
  DateTime? _lastPressed;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return WillPopScope(
      onWillPop: () async {
        if (_lastPressed == null || DateTime.now().difference(_lastPressed!) > Duration(seconds: 2)) {
          // Show pop-up message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Press back again to exit"),
              duration: Duration(seconds: 2),
            ),
          );
          _lastPressed = DateTime.now();
          return false;
        } else {
          // Exit the app
          return true;
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appname,
        theme: ThemeData(
          scaffoldBackgroundColor: whiteColor,
          appBarTheme: const AppBarTheme(backgroundColor: darkFontGrey),
          fontFamily: regular,
        ),
          home: _connectionStatus == ConnectivityResult.none
    ? OfflineScreen()
        : SplashScreen(),
    ),);
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

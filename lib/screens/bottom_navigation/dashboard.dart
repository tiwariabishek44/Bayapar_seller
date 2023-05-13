
import 'package:bayapar_seller/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/consts.dart';
import '../../controller/order_controller.dart';
import '../../controller/product controller.dart';
class DashboardPage extends StatefulWidget {


  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  NepaliDateTime _nepaliDate = NepaliDateTime.now();

  String phoneNumber ='';

  final productController = Get.find<ProductController>();

  Future<String?> _getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phonee');
  }
  final orderController = Get.find<OrderController>();
  @override
  void initState() {
    super.initState();
    _getPhoneNumber().then((value) {
      setState(() {
        phoneNumber = value!.substring(4);
        productController.getProducts(phoneNumber);
        orderController.getorders(phoneNumber);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: darkFontGrey, // set text color to black
          ),
        ),

        actions: [Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text('${_nepaliDate.year}-${_nepaliDate.month}-${_nepaliDate.day}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
              color: darkFontGrey),),
        )

        ],
      ),
      body: Obx(() {

        return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                'Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardSummaryCard(
                    title: 'Total Products',
                    value: '${productController.products.length}',
                    icon: Icons.shopping_bag,
                    color: Colors.blue,
                  ),

                  DashboardSummaryCard(
                    title: 'Pending Orders',
                    value: '${orderController.orders
                        .where((order) => order.isOnRoad==false)
                        .toList()
                        .toList().length}',
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  DashboardSummaryCard(
                    title: 'Completed Orders',
                    value: '${orderController.orders
                        .where((order) => order.isOnRoad==true)
                        .toList()
                        .reversed
                        .toList().length}',

                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),

                ],
              ),
            ),],
        ),
      );

      }),
    );
  }
}
class DashboardSummaryCard extends StatelessWidget {
  final String? title;
  final String? value;
  final IconData? icon;
  final Color? color;

  const DashboardSummaryCard({
    Key? key,
    this.title,
    this.value,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

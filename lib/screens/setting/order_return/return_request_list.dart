
import 'package:bayapar_seller/screens/setting/order_return/return_request_details.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../consts/consts.dart';

class Return_list extends StatefulWidget {
  Return_list({Key? key}) : super(key: key);

  @override
  State<Return_list> createState() => _Return_listState();
}

class _Return_listState extends State<Return_list> {
  NepaliDateTime _nepaliDate = NepaliDateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
          leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Get.back(),
      color: darkFontGrey, // set icon color to black
    ),
        title: Text(
          "Returns Orders",
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
      body: Padding(
        padding: EdgeInsets.all(9),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(() => Return_request_details());
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID: {order.id}",
                            style: TextStyle(
                              fontFamily: semibold,
                              fontSize: 16,
                              color: darkFontGrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              icTrash,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ],
                      ),
                      10.heightBox,
                      Text(
                        "Shop: {order.shopname}",
                        style: TextStyle(
                          color: redColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      5.heightBox,
                      Text(
                        "Total: Rs. {order.totalPrice}",
                        style: TextStyle(
                          color: darkFontGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      5.heightBox,
                      Text(
                        "Date: {order.date}",
                        style: TextStyle(
                          color: darkFontGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

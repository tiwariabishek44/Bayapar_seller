import 'package:bayapar_seller/consts/consts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../../category/categories_display.dart';
import '../../getX_controller.dart';
import '../orders/orders_list.dart';
import '../products/product_list.dart';
import '../setting/main_profile_screen.dart';
import 'dashboard.dart';


class Bottom_navigation extends StatelessWidget {
  const Bottom_navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Homecontroller());
    var navbaritem=[
      BottomNavigationBarItem(
        icon: Image.asset(icHome,height: 25,width: 25,color: darkFontGrey),
        label: "Dashboard",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icProducts,height: 25,width: 25,color: darkFontGrey),
        label: "Products",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icOrder,height: 25,width: 25,color: darkFontGrey,),
        label: "Orders",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icGeneralsetting,height: 25,width: 25,color: darkFontGrey),
        label: "Setting",
      ),

    ];

    var navbody=[
      DashboardPage(),
      ProductListScreen(),
      OrderPage(),
      MainProfile(),

    ];

    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
        return exit ?? false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(()=> Expanded(child: navbody.elementAt(controller.currentNavINdex.value))),
          ],
        ),
        bottomNavigationBar: Obx(

              ()=> BottomNavigationBar(unselectedItemColor: darkFontGrey,

            currentIndex: controller.currentNavINdex.value,

            selectedItemColor: redColor, // set color of selected item's icon
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            onTap: (value){
              controller.currentNavINdex.value =value;
            },
            items: navbaritem,
          ),
        ),
      ),
    );
  }
}

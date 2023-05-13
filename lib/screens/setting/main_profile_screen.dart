import 'package:bayapar_seller/screens/setting/policies.dart';
import 'package:bayapar_seller/screens/setting/terms_of_use.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts/consts.dart';
import '../../consts/lists.dart';
import '../auth_screen/login_screen.dart';
import '../orders/order_completed.dart';
import 'about_bayapar.dart';
import 'business_details.dart';
import 'contact_us.dart';

class MainProfile extends StatefulWidget {

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  NepaliDateTime _nepaliDate = NepaliDateTime.now();

  void logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Log out"),
              onPressed: () {
                // Add code here to handle the logout action
                prefs.remove('phonee');
                Get.offAll(() => LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          "Setting",
          style: TextStyle(
            fontFamily: semibold,
            color: redColor,
          ),
        ),

      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Profile Settings"),
            subtitle: Text("Manage your account settings"),
            leading: Icon(Icons.person,size: 40,).box.roundedFull.clip(Clip.antiAlias).make(),

          ),
          const Divider(),
          10.heightBox,
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    switch (index) {
                      case 0:
                        Get.to(() => StoreDetailsPage());
                        break;


                      case 1:
                        Get.to(()=>Order_completed());
                        break;

                      case 2:
                        Get.to(() => Contact_us(),arguments: profileButtonList[index]);
                        break;


                      case 3:
                        Get.to(() => Terms(),arguments: profileButtonList[index]);
                        break;
                      case 4:
                        Get.to(() => Policies(),arguments: profileButtonList[index]
                        );
                        break;
                      case 5:
                        Get.to(() => About(),arguments: profileButtonList[index]);
                        break;
                      case 6:
                        logout(); // Call the logout function here
                        break;


                    }
                  },
                  leading: Image.asset(
                    profileButtonicon[index],
                    width: 25,
                  ),
                  title: profileButtonList[index]
                      .text
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .make(),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: lightGrey,
                );
              },
              itemCount: profileButtonList.length,
            ).box.white.rounded.margin(const EdgeInsets.only(top: 10)).padding(const EdgeInsets.all(5)).shadowSm.make(),
          ),
        ],
      ),
    );
  }
}

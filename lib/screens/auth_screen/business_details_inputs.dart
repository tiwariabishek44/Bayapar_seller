import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/consts.dart';
import '../../controller/seller_controller.dart';
import '../../model/seller_model.dart';
import '../../widgets/custom_textfield.dart';


class Business_details_input extends StatefulWidget {
  @override
  State<Business_details_input> createState() => _Business_details_inputState();
}

class _Business_details_inputState extends State<Business_details_input> {
  final auth = FirebaseAuth.instance;

  final FirebaseController _firebaseController = Get.find();

  String _selectedValue = 'PAN';
  String phone = '';

  Future<String?> _getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phonee');
  }

  final _ownerNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _streetController = TextEditingController();
  final _municipalitycontroller = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: whiteColor,
          elevation: 0.1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
            color: darkFontGrey, // set icon color to black
          ),
          title: Text("Business Detail Form${phone}", style:
          TextStyle(fontFamily: semibold,color: redColor),),
        ),

        body:FutureBuilder<String?>(
          future: _getPhoneNumber(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              final String? phoneNumber = snapshot.data;
              final _phoneNumberController = TextEditingController(text: phoneNumber);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your Shop ${phoneNumber!}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      customTextField2(title: 'Owner Name', icon: Icon(Icons.person), hint: 'Enter owner name', controller: _ownerNameController),
                      SizedBox(height: 10),
                      customTextField2(title: 'Business Name', icon: Icon(Icons.store), hint: 'Enter shop name', controller: _shopNameController),
                      SizedBox(height: 10),
                      customTextField2(title: 'Address', icon: Icon(Icons.location_on), hint: 'Enter address', controller: _addressController),
                      SizedBox(height: 10),
                      customTextField2(title: 'Street', icon: Icon(Icons.streetview), hint: 'Enter street', controller: _streetController),
                      SizedBox(height: 10),
                      customTextField2(title: 'Municipality', icon: Icon(Icons.location_city), hint: 'Enter Municipality', controller: _municipalitycontroller),
                      SizedBox(height: 10),
                      customTextField2(title: 'Phone Number', icon: Icon(Icons.phone), hint: 'Enter phone number', controller: _phoneNumberController),

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String ownerName = _ownerNameController.text;
                          String businessName = _shopNameController.text;
                          String address = _addressController.text;
                          String street = _streetController.text;
                          String municipality = _municipalitycontroller.text;
                          String phoneNumber = _phoneNumberController.text;


                          if (ownerName.isEmpty ||
                              businessName.isEmpty ||
                              address.isEmpty ||
                              street.isEmpty ||
                              municipality.isEmpty||
                              phoneNumber.isEmpty ) {
                            Get.snackbar(
                              'Error',
                              'Please fill all the fields',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            SellerModel seller = SellerModel(
                              ownerName: ownerName,
                              businessName: businessName,
                              address: address,
                              street: street,
                              municipality:municipality ,

                              phoneNumber: phoneNumber,

                            );
                            _firebaseController.saveSellerData(seller);
                          }
                          Get.back();


                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Show a loading indicator until the phone number is retrieved
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }}

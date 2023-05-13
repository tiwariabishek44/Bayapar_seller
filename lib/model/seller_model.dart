class SellerModel {
  final String ownerName;
  final String businessName;
  final String address;
  final String street;
  final String municipality;
  final String phoneNumber;



  SellerModel({
    required this.ownerName,
    required this.businessName,
    required this.address,
    required this.street,
    required this.municipality,
    required this.phoneNumber,

  });

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'shopName': businessName,
      'address': address,
      'street': street,
      'municipality' :municipality,
      'phoneNumber': phoneNumber,

    };
  }

  static SellerModel fromMap(Map<String, dynamic> map) {
    return SellerModel(
      ownerName: map['ownerName'],
      businessName: map['shopName'],
      address: map['address'],
      street: map['street'],
      municipality: map['municipality'],
      phoneNumber: map['phoneNumber'],


     );
  }
}

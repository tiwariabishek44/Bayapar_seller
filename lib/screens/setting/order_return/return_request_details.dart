
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../consts/consts.dart';

class Return_request_details extends StatefulWidget {
  const Return_request_details({Key? key}) : super(key: key);

  @override
  State<Return_request_details> createState() => _Return_request_detailsState();
}

class _Return_request_detailsState extends State<Return_request_details> {
  bool _isOrderConfirmed = false;
  bool _isReturn = false;

  void _confirmOrder() {
    if (!_isOrderConfirmed) {
      _isOrderConfirmed = true;
      setState(() {});
    }
  }

  void _packageOrder() {
    if (_isOrderConfirmed && !_isReturn) {
      _isReturn = true;
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          color: Colors.black,
        ),
        title: Text(
          "Return Order Details",
          style: TextStyle(
            fontFamily: 'Bold',
            color: Colors.red,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Order confirmed'),
              trailing: Checkbox(
                value: _isOrderConfirmed,
                onChanged: (_) => _confirmOrder(),
              ),
            ),
            ListTile(
              title: Text('Order packaged'),
              trailing: Checkbox(
                value: _isReturn,
                onChanged: (_) => _packageOrder(),
              ),
              enabled: _isOrderConfirmed,
            ),


            SizedBox(height: 24),
            _buildOrderProductsSection(),


            10.heightBox,// Accounting container
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop name:'),
                          Text('{shop name}', style: TextStyle(color: darkFontGrey, fontFamily: semibold,),),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop Phone:'),
                          Text('{shop name}', style: TextStyle(color: darkFontGrey, fontFamily: semibold,),),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Address:'),
                          Text('{widget.order.address}', style: TextStyle(color: darkFontGrey, fontFamily: semibold,),),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Municipality'),
                          Text('{widget.order.municipality}'),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Street'),
                          Text('{widget.order.street}'),
                        ],
                      ),5.heightBox,

                    ]),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Code:'),
                          Text('{widget.order.id}', style: TextStyle(color: redColor, fontFamily: semibold,),),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date:'),
                          Text('{widget.order.date}'),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time:'),
                          Text('{widget.order.time}'),
                        ],
                      ),5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment:'),
                          Text('COD'),
                        ],
                      ),5.heightBox,


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal:'),
                          Text('{widget.order.totalPrice}'),
                        ],
                      ),
                      SizedBox(height: 8.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logistic Cost:'),
                          Text('Rs.00'),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Grand Total:'),
                          Text('{widget.order.totalPrice}'),
                        ],
                      ),
                    ]),)
              ,
            ),20.heightBox,
          ],
        ),
      ),
    );
  }


  Widget _buildOrderProductsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Products",
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {

              return GestureDetector(

                child: ListTile(
                  leading: Image.network('https://rukminim1.flixcart.com/image/416/416/l1mh7rk0/shopsy-infant-formula/r/q/p/400-nestle-nan-pro-1-nesle-original-imagd5hpfysb6pds.jpeg?q=70'),
                  title: Text("{product.name}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Quantity: {product.quantity}'),
                      Text('Total Price: \Rs  {product.price }'),
                    ],
                  ),
                ).box.green50.margin(const EdgeInsets.symmetric(horizontal: 4)).
                roundedSM.padding(const EdgeInsets.all(8)).make(),
              );

            },
          ),
        ],
      ),
    );
  }
}






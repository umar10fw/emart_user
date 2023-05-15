

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/controllers/home_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {

  var totalP = 0.obs;

  // Text Editing Controller

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var vendors = [];
  var placeOrder = false.obs;


  calculate(data){
    totalP.value = 0;
    for( var i=0; i < data.length; i++){
      totalP.value = totalP.value + int.parse(data[i]['tPrice'].toString());
    }
  }

  changePaymentMethod (index){
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod,required totalAmount}) async{
    placeOrder(true);
    await getProductDetail();
    await fireStore.collection(ordersCollection).doc().set({
      'order_code': "23324458802",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postal_code': postalCodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivery': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),
    });
    placeOrder(false);
  }

  getProductDetail(){
    products.clear();
    vendors.clear();
    for(var i = 0; i < productSnapshot.length; i++){
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vender_id': productSnapshot[i]['vender_id'],
        'tPrice': productSnapshot[i]['tPrice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vender_id']);
    }
  }

  clearCart(){
    for(var i = 0; i < productSnapshot.length; i++){
      fireStore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }


}

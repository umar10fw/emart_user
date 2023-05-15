import 'package:emart/consts/consts.dart';
import 'package:emart/controllers/cart_controller.dart';
import 'package:emart/views/cart_screen/payment_method.dart';
import 'package:emart/widget_common/custom_textfield.dart';
import 'package:emart/widget_common/our_button.dart';
import 'package:get/get.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor ,
      appBar: AppBar(iconTheme: const IconThemeData(color: Colors.black),title: "Shipping Info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: (){
            if(controller.addressController.text.length > 10 ){
              Get.to(()=> const PaymentMethod());
            } else {
              VxToast.show(context, msg: "Please Fill the Form");
            }
          },
          title: "Continue",
          textColor: whiteColor,
          color: redColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CustomTextField(title: "Address",hint: "Address",ispass: false,controller: controller.addressController),
            CustomTextField(title: "City",hint: "City",ispass: false,controller: controller.cityController),
            CustomTextField(title: "State",hint: "State",ispass: false,controller: controller.stateController),
            CustomTextField(title: "Postal Code",hint: "Postal Code",ispass: false,controller: controller.postalCodeController),
            CustomTextField(title: "Phone",hint: "Phone",ispass: false,controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}

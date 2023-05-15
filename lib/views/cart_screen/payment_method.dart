import 'package:emart/consts/consts.dart';
import 'package:emart/consts/list.dart';
import 'package:emart/controllers/cart_controller.dart';
import 'package:emart/views/home_screen/home.dart';
import 'package:emart/views/home_screen/home_screen.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:emart/widget_common/our_button.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<CartController>();

    return Obx(
      ()=>  Scaffold(
        backgroundColor: whiteColor ,
        appBar: AppBar(iconTheme: const IconThemeData(color: Colors.black),title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placeOrder.value
              ? Center(
                 child: loadingIndicator(),
                )
              : ourButton(
            onPress: () async {
               await controller.placeMyOrder(
                orderPaymentMethod: paymentMethods[controller.paymentIndex.value],
                totalAmount: controller.totalP.value,
              );
               await controller.clearCart();
               VxToast.show(context, msg: "Order Placed Successfully");

               Get.offAll(const Home());
            },
            title: "Place my order",
            textColor: whiteColor,
            color: redColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
              ()=> Column(
              children: List.generate(paymentMethodImg.length, (index) {
                return GestureDetector(
                  onTap: (){
                    controller.paymentIndex.value = index;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.paymentIndex.value == index ?  redColor : Colors.transparent,
                        width: 3,
                      )
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(paymentMethodImg[index],
                          width: double.infinity,
                          height: 120,fit:BoxFit.cover,
                          colorBlendMode: controller.paymentIndex.value == index ? BlendMode.darken : BlendMode.color,
                          color: controller.paymentIndex.value == index ? Colors.black.withOpacity(0.4) : Colors.transparent,
                        ),
                        controller.paymentIndex.value == index ? Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                            activeColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            value: true,
                            onChanged: (value){
                            },
                          ),
                        ) : Container(),
                        Positioned(
                          bottom: 10,
                            right: 10,
                            child: paymentMethods[index].text.white.fontFamily(semibold).size(16).make()
                        )
                      ],
                    ),
                  ),
                );
              })
            ),
          ),
        ),
      ),
    );
  }
}

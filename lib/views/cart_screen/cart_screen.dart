import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/cart_screen/shipping_screen.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:emart/widget_common/our_button.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FireStoreServices.getCart(currentUser!.uid),
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }else if (snapshot.data!.docs.isEmpty){
            return Center(
              child: "Cart is Empty".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Image.network(
                              "${data[index]['img']}",
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                            title: "${data[index]['title']} (x${data[index]['qty']})".text.fontFamily(semibold).size(16).make(),
                            subtitle: "${data[index]['tPrice']}".numCurrency.text.fontFamily(semibold).color(redColor).make(),
                            trailing: const Icon(Icons.delete,color: redColor,).onTap((
                                ) {
                              FireStoreServices.deleteDocument(data[index].id);
                            }),
                          ).box.margin(const EdgeInsets.all(3)).shadowSm.roundedSM.white.make();
                          },
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total".text.fontFamily(semibold).color(darkFontGrey).make(),
                      Obx(
                          () => "${controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor ).make()),
                    ],
                  ).box.width(context.screenWidth-60).padding(const EdgeInsets.all(12)).color(lightGolden).roundedSM.make(),
                  10.heightBox,
                  SizedBox(
                    width: context.screenWidth-60,
                    child: ourButton(
                      color: redColor,
                      onPress: (){
                        Get.to(()=> const ShippingScreen());
                      },
                      title: "Proceed to Shipping",
                      textColor: whiteColor,
                    ),
                  )
                ],
              ),
            );
          }
        },
      )
    );
  }
}

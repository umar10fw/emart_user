import 'package:emart/controllers/product_controller.dart';
import 'package:emart/views/chat_screen/chat_screen.dart';
import 'package:emart/widget_common/our_button.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../consts/list.dart';

class ItemDetail extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetail({Key? key, required this.title,this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          iconTheme: IconThemeData( color: Colors.black),
          leading: IconButton(onPressed: (){
              controller.resetValue();
              Get.back();
            }, icon: const Icon(Icons.arrow_back)
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.share,color: darkFontGrey,)),
            Obx(
                ()=>  IconButton(onPressed: (){

                    if(controller.isFav.value){
                      controller.removeFromWishList(data.id,context);
                      controller.isFav(false);
                    }else{
                      controller.addToWishList(data.id,context);
                      controller.isFav(true);
                    }

                    }, icon: Icon(Icons.favorite,color: controller.isFav.value ? redColor : darkFontGrey,)),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VxSwiper.builder(
                      autoPlay: true,
                      height: 200,
                      aspectRatio: 16 / 9,
                      itemCount: data['p_imgs'].length,
                      viewportFraction: 1.0,
                      itemBuilder:(context, index) {
                      return Image.network(data['p_imgs'][index],width: double.infinity,fit: BoxFit.cover);
                    },),
                    10.heightBox,
                    title!.text.size(16).fontFamily(semibold).color(darkFontGrey).make(),
                    10.heightBox,
                    VxRating(
                      value: double.parse(data['p_rating']),
                      onRatingUpdate: (value) {},
                      normalColor: textfieldGrey,
                      selectionColor: golden,
                      count: 5,
                      size: 25,
                      maxRating: 5,
                    ),
                    10.heightBox,
                    "${data['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(18).make(),
                    10.heightBox,
                    Row(
                      children: [
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${data['p_seller']}".text.white.fontFamily(semibold).make(),
                            5.heightBox,
                            "In House Brand".text.color(darkFontGrey).size(18).fontFamily(semibold).make(),
                          ],
                        )),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.message_rounded,color: darkFontGrey,).onTap(() {
                            Get.to(()=> const ChatScreen(),
                            arguments: [data['p_seller'], data['vender_id']],
                            );
                          }),
                        ),
                      ],
                    ).box.height(60).color(textfieldGrey).padding(const EdgeInsets.symmetric(horizontal: 16)).make(),
                    20.heightBox,
                    Obx(
                      ()=> Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Color: ".text.color(textfieldGrey).make(),
                              ),
                             Row(
                                  children: List.generate(
                                      data['p_colors'].length,
                                          (index) => Stack(
                                           alignment: Alignment.center,
                                        children: [
                                          VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]).withOpacity(1.0))
                                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                                          .make().onTap(() {
                                            controller.changeColorIndex(index);
                                          }),
                                          Visibility(
                                            visible: index == controller.colorIndex.value,
                                              child: const Icon(Icons.done,color: Colors.white,),
                                          )
                                        ],
                                      )),
                                ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity: ".text.color(textfieldGrey).make(),
                              ),
                             Row(
                                    children: [
                                      IconButton(onPressed: (){
                                        controller.decreaseQuantity();
                                        controller.calculateTotalPrice(int.parse(data['p_price']));
                                      }, icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text.size(16).fontFamily(bold).color(darkFontGrey).make(),
                                      IconButton(onPressed: (){
                                        controller.increaseQuantity(
                                          int.parse(data['p_quantity'])
                                        );
                                        controller.calculateTotalPrice(int.parse(data['p_price']));
                                      }, icon: const Icon(Icons.add)),
                                      10.widthBox,
                                      "${data['p_quantity']} available".text.color(textfieldGrey).make(),
                                    ],
                                  ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Total: ".text.color(textfieldGrey).make(),
                              ),
                              "${controller.totalPrice.value}".numCurrency.text.color(redColor).size(16).fontFamily(bold).make()
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                        ],
                      ).box.white.shadowSm.make(),
                    ),

                    10.heightBox,
                    "Description".text.fontFamily(bold).color(darkFontGrey).make(),
                    10.heightBox,
                    "${data['p_desc']}"
                        .text.color(darkFontGrey).make(),
                    10.heightBox,
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          itemDetailButtonList.length,
                              (index) => Container(
                                padding: const EdgeInsets.all(2),
                                child: ListTile(
                                  title: itemDetailButtonList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                                  trailing: const Icon(Icons.arrow_forward),
                      ).box.white.shadowSm.roundedSM.make(),
                              ),
                      ),
                    ),
                    10.heightBox,
                    productsYouMayLike.text.fontFamily(bold).size(16).color(darkFontGrey).make(),
                    10.heightBox,
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                            children: List.generate(6, (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(imgP1,width: 150,fit: BoxFit.cover,),
                                10.heightBox,
                                "Laptop 4GB/64GB".text.fontFamily(semibold).color(darkFontGrey).make(),
                                10.heightBox,
                                "\$600".text.color(redColor).fontFamily(bold).size(16).make()
                              ],
                            ).box.margin(const EdgeInsets.symmetric(horizontal: 4)).white.roundedSM.padding(const EdgeInsets.all(8)).make(),
                            )
                        )
                    )
                  ],
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                title: "Add to Cart",
                onPress: (){
                  if(controller.quantity.value > 0){
                    controller.addToCart(
                      color: data['p_colors'][controller.colorIndex.value],
                      context: context,
                      vendorID: data['vendor_id'],
                      img: data['p_imgs'][0],
                      qty: controller.quantity.value,
                      sellerName: data['p_seller'],
                      title: data['p_name'],
                      tPrice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added To Cart");
                  } else{
                    VxToast.show(context, msg: "Minimum Quantity is greater then 0");
                  }
                },
                textColor: whiteColor,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

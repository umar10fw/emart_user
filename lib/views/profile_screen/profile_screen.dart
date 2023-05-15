import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/list.dart';
import 'package:emart/controllers/auth_controller.dart';
import 'package:emart/controllers/profile_controller.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/auth_screen/login_screen.dart';
import 'package:emart/views/chat_screen/messaging_screen.dart';
import 'package:emart/views/orders_screen/orders_screen.dart';
import 'package:emart/views/profile_screen/component/profile_button.dart';
import 'package:emart/views/profile_screen/edit_profile_screen.dart';
import 'package:emart/views/wishlist_screen/wishlist_screen.dart';
import 'package:emart/widget_common/bg_widget.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
        child: Scaffold(
            body: SafeArea(
      child: StreamBuilder(
        stream: FireStoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else {
            var data = snapshot.data?.docs[0];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.edit,
                      color: whiteColor,
                    ),
                  ).onTap(() {
                    controller.nameController.text = data!['name'];
                    Get.to(() => EditScreen(data: data));
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      data!['imageUrl'] == ''
                          ? Image.asset(
                              imgProfile2,
                              width: 50,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.network(
                              data['imageUrl'],
                              width: 50,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                      10.widthBox,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${data['name']}"
                              .text
                              .fontFamily(semibold)
                              .white
                              .make(),
                          "${data['email']}".text.white.make(),
                        ],
                      )),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                          color: whiteColor,
                        )),
                        onPressed: () async {
                          await Get.put(AuthController())
                              .signOutMethod(context);
                          Get.offAll(() => const LoginScreen());
                        },
                        child: "Logout".text.fontFamily(semibold).white.make(),
                      ),
                    ],
                  ),
                ),
                10.heightBox,
                FutureBuilder(
                  future: FireStoreServices.getCounts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData){
                      return Center(
                        child: loadingIndicator(),
                      );
                    }else {
                      var countData = snapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailsCard(
                              count: countData[0].toString(),
                              title: "in your cart",
                              width: context.screenWidth / 3.4),
                          detailsCard(
                              count: countData[1].toString(),
                              title: "in your WishList",
                              width: context.screenWidth / 3.4),
                          detailsCard(
                              count: countData[2].toString(),
                              title: "your orders",
                              width: context.screenWidth / 3.4),
                        ],
                      );
                    }
                },),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     detailsCard(
                //         count: data['cart_count'],
                //         title: "in your cart",
                //         width: context.screenWidth / 3.4),
                //     detailsCard(
                //         count: data['wishlist_count'],
                //         title: "in your WishList",
                //         width: context.screenWidth / 3.4),
                //     detailsCard(
                //         count: data['order_count'],
                //         title: "your orders",
                //         width: context.screenWidth / 3.4),
                //   ],
                // ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: profileButtonList.length,
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 1, color: lightGrey);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        switch(index){
                          case 0:
                            Get.to(()=> const OrdersScreen());
                            break;
                          case 1:
                            Get.to(()=> const WishListScreen());
                            break;
                          case 2:
                            Get.to(()=> const MessagesScreen());
                            break;
                        }
                      },
                      leading: Image.asset(
                        profileButtonIcons[index],
                        width: 20,
                      ),
                      title: profileButtonList[index]
                          .text
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                    );
                  },
                )
                    .box
                    .white
                    .roundedSM
                    .margin(const EdgeInsets.all(12))
                    .padding(const EdgeInsets.symmetric(horizontal: 16))
                    .shadowSm
                    .make()
                    .box
                    .color(redColor)
                    .make()
              ],
            );
          }
        },
      ),
    )));
  }
}

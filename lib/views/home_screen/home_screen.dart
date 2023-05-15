import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/list.dart';
import 'package:emart/controllers/home_controller.dart';
import 'package:emart/controllers/product_controller.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/category_screen/item_detail.dart';
import 'package:emart/views/home_screen/search_screen.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widget_common/homebutton.dart';
import 'components/featured_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   var controller1 = Get.find<HomeController>();
    return Container(
      width: context.screenWidth,
      height: context.screenHeight,
      color: lightGrey,
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller1.searchController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search).onTap(() {
                   if(controller1.searchController.text.isNotEmptyAndNotNull){
                     Get.to(()=> SearchScreen(title: controller1.searchController.text,));
                   }
                  }),
                  filled: true,
                  border: InputBorder.none,
                  fillColor: whiteColor,
                  hintText: searchAnythings,
                  hintStyle: const TextStyle(
                    color: textfieldGrey,
                  )
                ),
              ),
            ),
           Expanded(
             child: SingleChildScrollView(
               physics: const BouncingScrollPhysics(),
               child: Column(
                 children: [
                   VxSwiper.builder(
                       aspectRatio: 16/9,
                       autoPlay: true,
                       height: 120,
                       enlargeCenterPage: true,
                       itemCount: sliderList.length,
                       itemBuilder: (context, index) {
                         return Image.asset(
                           sliderList[index],
                           fit: BoxFit.fill,)
                             .box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                       }),
                   10.heightBox,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: List.generate(2, (index) => homeButtons(
                       height: context.screenHeight * 0.15,
                       width: context.screenWidth / 2.5,
                       title: index == 0 ? todayDeal : flashSale,
                       icon: index == 0 ? icTodaysDeal : icFlashDeal,
                     )),
                   ),
                   10.heightBox,
                   VxSwiper.builder(
                       aspectRatio: 16/9,
                       autoPlay: true,
                       height: 120,
                       enlargeCenterPage: true,
                       itemCount: secondSliderList.length,
                       itemBuilder: (context, index) {
                         return Image.asset(
                           secondSliderList[index],
                           fit: BoxFit.fill,)
                             .box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                       }),
                   10.heightBox,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: List.generate(
                         3, (index) => homeButtons(
                       height: context.screenHeight * 0.15,
                       width: context.screenWidth / 3.5,
                       icon: index == 0 ? icTopCategories : index == 1 ? icBrands : icTopSeller,
                       title: index == 0 ? topCategories : index == 1 ? brand : topSeller,
                     )),
                   ),
                   20.heightBox,
                   Align(
                     alignment: Alignment.centerLeft,
                     child: featureCategories.text.fontFamily(semibold).color(darkFontGrey).make(),
                   ),
                   20.heightBox,
                   SingleChildScrollView(
                     physics: const BouncingScrollPhysics(),
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: List.generate(3, (index) => Column(
                         children: [
                           featuredButton(icon: featuredImages1[index],title: featuredTitle1[index]),
                           10.heightBox,
                           featuredButton(icon: featuredImages2[index], title: featuredTitle2[index]),
                         ],
                       )).toList(),
                     ),
                   ),
                   20.heightBox,
                   Container(
                     width: double.infinity,
                     padding: const EdgeInsets.all(12),
                     decoration: const BoxDecoration(color: redColor),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         featuredProducts.text.white.fontFamily(semibold).size(16).make(),
                         10.heightBox,
                         SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           physics: const BouncingScrollPhysics(),
                           child: FutureBuilder(
                             future: FireStoreServices.getFeaturedProducts(),
                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                               if(!snapshot.hasData){
                                 return Center(
                                   child: loadingIndicator(),
                                 );
                               }else if(snapshot.data!.docs.isEmpty){
                                 return " No Featured Data Yet!".text.white.fontFamily(bold).makeCentered();
                               } else{
                                 var featuredData = snapshot.data!.docs;
                                 return Row(
                                     children: List.generate(
                                       featuredData.length,
                                      (index) => Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Image.network(featuredData[index]['p_imgs'][0],width: 80,fit: BoxFit.cover,),
                                         10.heightBox,
                                         "${featuredData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                         10.heightBox,
                                         "${featuredData[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make()
                                       ],
                                     ).box.margin(const EdgeInsets.symmetric(horizontal: 4))
                                          .white.roundedSM
                                          .padding(const EdgeInsets.all(8))
                                          .make().onTap(() {
                                        Get.to(() => ItemDetail( title: featuredData[index]['p_name'].toString(), data: featuredData[index],));
                                      }),
                                     )
                                 );
                               }

                             },
                           )
                         )
                       ],
                     ),
                   ),
                   10.heightBox,
                   VxSwiper.builder(
                       aspectRatio: 16/9,
                       autoPlay: true,
                       height: 120,
                       enlargeCenterPage: true,
                       itemCount: secondSliderList.length,
                       itemBuilder: (context, index) {
                         return Image.asset(
                           secondSliderList[index],
                           fit: BoxFit.fill,)
                             .box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                       }),
                   20.heightBox,
                  StreamBuilder(
                    stream: FireStoreServices.allProducts(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(!snapshot.hasData){
                        return loadingIndicator();
                      } else {
                        var allProductsData = snapshot.data!.docs;
                        return  GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allProductsData.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(allProductsData[index]['p_imgs'][0],width: 200,height: 150,fit: BoxFit.cover,),
                                const Spacer(),
                                "${allProductsData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                10.heightBox,
                                "${allProductsData[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make()
                              ],
                            ).box.margin(const EdgeInsets.symmetric(horizontal: 4))
                                .white.shadowLg.roundedSM
                                .padding(const EdgeInsets.all(12  )).make()
                                .onTap(() {
                                   Get.to(() => ItemDetail( title: allProductsData[index]['p_name'].toString(), data: allProductsData[index],));
                            });
                          },);
                      }
                  },)
                 ],
               ),
             ),
           )
          ],
        ), 
      ),
    );
  }
}

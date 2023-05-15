import 'package:emart/consts/consts.dart';
import 'package:emart/views/category_screen/categories_detail.dart';
import 'package:get/get.dart';


Widget featuredButton({String? title, icon}){
  return Row(
    children: [
      Image.asset(icon,width: 60, fit: BoxFit.fill,),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make()
    ],
  ).box.width(200)
      .margin(EdgeInsets.symmetric(horizontal: 4))
      .padding(EdgeInsets.all(8))
      .roundedSM.outerShadowSm
      .white.make().onTap(() {
        Get.to(()=> CategoriesDetail(title: title));
  });
}
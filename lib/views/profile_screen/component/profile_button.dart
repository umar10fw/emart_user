import 'package:emart/consts/consts.dart';

Widget detailsCard({width, String? title, String? count}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(semibold).size(16).color(darkFontGrey).make(),
      5.heightBox,
      title!.text.color(darkFontGrey).size(12).make(),
    ],
  ).box.white.roundedSM.width(width).height(80).p4.make();
}

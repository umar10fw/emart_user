


import 'package:emart/consts/consts.dart';
import 'package:emart/widget_common/our_button.dart';
import 'package:flutter/services.dart';

Widget exitDialog(context){
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
        const Divider(),
        10.heightBox,
        "Are You sure want to exit".text.size(16).color(darkFontGrey).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(title: "Yes",color: redColor,textColor: whiteColor,onPress: (){
              SystemNavigator.pop();
            }),
            ourButton(title: "No",color: redColor,textColor: whiteColor,onPress: (){
              Navigator.pop(context);
            }),
          ],
        )
      ],
    ).box.color(lightGrey).p8.roundedSM.make(),
  );
}

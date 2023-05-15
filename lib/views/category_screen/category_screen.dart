import 'package:emart/consts/list.dart';
import 'package:emart/controllers/product_controller.dart';
import 'package:emart/views/category_screen/categories_detail.dart';
import 'package:emart/widget_common/bg_widget.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller =  Get.put(ProductController());

    return bgWidget(
        child: Scaffold(
           appBar: AppBar(
             title: categories.text.fontFamily(bold).white.make(),
      ),
          body: Container(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 170
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(categoriesImages[index],width: 200,height: 120, fit: BoxFit.fill,),
                      10.heightBox,
                      categoriesTitle[index].text.color(darkFontGrey).align(TextAlign.center).make()
                    ],
                  ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make().onTap(() {
                    controller.getSubCategories(categoriesTitle[index]);
                    Get.to(()=> CategoriesDetail(title: categoriesTitle[index],));
                  });
                },),
          ),
    ));
  }
}

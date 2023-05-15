import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/controllers/product_controller.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/widget_common/bg_widget.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widget_common/loading_indicator.dart';
import 'item_detail.dart';

class CategoriesDetail extends StatefulWidget {
  final String? title;
  final dynamic data;
  const CategoriesDetail({Key? key, required this.title,this.data}) : super(key: key);

  @override
  State<CategoriesDetail> createState() => _CategoriesDetailState();
}

class _CategoriesDetailState extends State<CategoriesDetail> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title){
    if(controller.subCat.contains(title)){
      productsMethod = FireStoreServices.getSubCategoryProducts(title);
    } else{
      productsMethod = FireStoreServices.getProducts(title);
    }
  }


  var controller = Get.find<ProductController>();
  dynamic productsMethod;

  @override
  Widget build(BuildContext context) {


    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.fontFamily(bold).white.make(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                    controller.subCat.length, (index) => "${controller.subCat[index]}"
                    .text
                    .size(12)
                    .fontFamily(semibold)
                    .color(darkFontGrey)
                    .makeCentered()
                    .box.white.roundedSM.size(120, 60)
                    .margin(const EdgeInsets.symmetric(horizontal: 4)).make().onTap(() {
                      switchCategory("${controller.subCat[index]}");
                      setState(() {

                      });
                })),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: productsMethod,
                // stream: FireStoreServices.getProducts(widget.title),
                builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(!snapshot.hasData){
                    return Expanded(
                      child: Center(
                        child: loadingIndicator()
                      ),
                    );
                  } else if(snapshot.data!.docs.isEmpty){
                    return Expanded(
                      child: Center(
                        child: "No Products found!".text.color(redColor).make(),
                      ),
                    );
                  }else {
                    var data = snapshot.data?.docs;
                    return Expanded(
                       child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: data!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          mainAxisExtent: 250,
                        ),
                        itemBuilder: (context, index) {
                          return  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(data[index]['p_imgs'][1],width: 200,height: 150,fit: BoxFit.cover,),
                              const Spacer(),
                              "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              10.heightBox,
                              "${data[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make()
                            ],
                          ).box.margin(const EdgeInsets.symmetric(horizontal: 4)).white.roundedSM.padding(const EdgeInsets.all(12  )).make()
                              .onTap(() {
                            controller.checkIfFav(data[index]);
                            Get.to(()=> ItemDetail(title: '${data[index]['p_name']}',data: data[index],));
                          });

                        },
                      )
                    );
                  }
                },
            ),
          ],
        )
      )
    );
  }
}

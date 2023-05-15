

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/category_screen/item_detail.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({Key? key,this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(Colors.black).make(),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: FutureBuilder(
        future: FireStoreServices.searchProducts(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }else if(snapshot.data!.docs.isEmpty){
            return "No Products Found".text.makeCentered();
          } else{
            var data = snapshot.data!.docs;
            var filtered = data.where((element) => element['p_name']
                .toString().toLowerCase().contains(title!.toLowerCase())
            ).toList();
            return filtered == data ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              children: data.mapIndexed((currentValue, index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(filtered[index]['p_imgs'][0],width: 200,height: 150,fit: BoxFit.cover,),
                    const Spacer(),
                    "${filtered[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                    10.heightBox,
                    "${filtered[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make()
                  ],
                ).box.margin(const EdgeInsets.symmetric(horizontal: 4))
                    .white.shadowLg.roundedSM
                    .padding(const EdgeInsets.all(12  )).make()
                    .onTap(() {
                  Get.to(() => ItemDetail( title: filtered[index]['p_name'].toString(), data: filtered[index],));
                });
              }).toList(),

            ) : "No Products Found".text.makeCentered();
          }
        },
      )
    );
  }
}


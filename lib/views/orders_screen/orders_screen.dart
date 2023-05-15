import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/orders_screen/orders_details.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FireStoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }else if (snapshot.data!.docs.isEmpty) {
            return "No Orders Yet!".text.color(darkFontGrey).makeCentered();
          } else{
            var data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: "${index + 1}".text.fontFamily(bold).color(darkFontGrey).xl.make(),
                    title: data[index]['order_code'].toString().text.fontFamily(semibold).color(redColor).make(),
                    subtitle: data[index]['total_amount'].toString().numCurrency.text.fontFamily(bold).color(darkFontGrey).make(),
                    trailing: IconButton(
                     onPressed: (){
                       Get.to(()=> OrderStatus(data: data[index]));
                     },
                     icon: const Icon(Icons.arrow_forward_ios_outlined,color: darkFontGrey,size: 20,),
                  ),
                  );
                },
            );
          }
        },
      ),
    );
  }
}

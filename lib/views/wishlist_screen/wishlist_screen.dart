import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/widget_common/loading_indicator.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
        title: "My WishList".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FireStoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }else if (snapshot.data!.docs.isEmpty) {
            return "No WishList Yet!".text.color(darkFontGrey).makeCentered();
          } else{
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network(
                          "${data[index]['p_imgs'][0]}",
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                        title: "${data[index]['p_name']}".text.fontFamily(semibold).size(16).make(),
                        subtitle: "${data[index]['p_price']}".numCurrency.text.fontFamily(semibold).color(redColor).make(),
                        trailing: const Icon(Icons.favorite,color: redColor,)
                            .onTap(() async {
                              await fireStore.collection(productsCollection).doc(data[index].id).set({
                                'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                              },SetOptions(merge: true));
                        }),

                      ).box.margin(const EdgeInsets.all(3)).shadowSm.roundedSM.white.make();

                      },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/services/firestore_services.dart';
import 'package:emart/views/chat_screen/chat_screen.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
        title: "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FireStoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }else if (snapshot.data!.docs.isEmpty) {
            return "No Messages Yet!".text.color(darkFontGrey).makeCentered();
          } else{
            var data = snapshot.data!.docs;
            return Padding(
                padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: (){
                                Get.to(()=> const ChatScreen(),
                                arguments:[
                                  data[index]['friend_name'],
                                  data[index]['toId'],
                                ]
                                );
                              },
                              leading: const CircleAvatar(
                                backgroundColor: redColor,
                                child: Icon(Icons.message,color: whiteColor,),
                              ),
                              title: "${data[index]['friend_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              subtitle: "${data[index]['last_msg']}".text.make(),
                            ),
                          );
                          },
                      )
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

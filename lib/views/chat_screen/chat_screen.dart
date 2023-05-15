import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:emart/controllers/chats_controller.dart';
import 'package:emart/views/chat_screen/component/sender_bubble.dart';
import 'package:emart/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../services/firestore_services.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData( color: Colors.black),
        title: "${controller.friendName}".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Obx(
             ()=> controller.isLoading.value
               ? Center(
                      child: loadingIndicator(),
                  )
               : Expanded(
                  child: StreamBuilder(
                      stream: FireStoreServices.getChatMessage(controller.chatDocId.toString()),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(!snapshot.hasData){
                          return Center(
                            child: loadingIndicator(),
                          );
                        }else if (snapshot.data!.docs.isEmpty){
                          return Center(
                            child: "Send a message...".text.color(darkFontGrey).make(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs.mapIndexed((currentValue, index) {
                              var data = snapshot.data!.docs[index];
                              return Align(
                                  alignment: data['uid'] == currentUser!.uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: senderBubble(data));
                            }).toList(),
                          );
                        }
                      }, )
              ),
            ),
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      )
                    ),
                     focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(
                           color: textfieldGrey,
                         )
                     ),
                    hintText: "Type a message....",
                  ),
                )),
                IconButton(onPressed: (){
                  controller.sendMsg(controller.msgController.text);
                  controller.msgController.clear();
                }, icon: const Icon(Icons.send,color: redColor,)),
              ],
            ).box.height(80).margin(const EdgeInsets.only(bottom: 8)).padding(const EdgeInsets.all(12)).make()
          ],
        ),
      ),
    );
  }
}

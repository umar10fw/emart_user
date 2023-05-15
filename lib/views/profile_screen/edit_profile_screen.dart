import 'dart:io';

import 'package:emart/controllers/profile_controller.dart';
import 'package:emart/widget_common/bg_widget.dart';
import 'package:emart/widget_common/custom_textfield.dart';
import 'package:emart/widget_common/our_button.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class EditScreen extends StatelessWidget {
  final dynamic data;
  const EditScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
          appBar: AppBar(),
         body: Obx(
            () => SingleChildScrollView(
               child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   data['imageUrl'] == '' && controller.profileImaPath.isEmpty
                      ? Image.asset(
                      imgProfile2,
                      width: 60,
                      fit: BoxFit.cover,
                       ).box.roundedFull.clip(Clip.antiAlias).make()
                         : data['imageUrl'] != '' && controller.profileImaPath.isEmpty
                          ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                           ).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.file(
                          File(controller.profileImaPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ourButton(
                  title: "Change",
                  textColor: whiteColor,
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  }),
              const Divider(),
              20.heightBox,
              CustomTextField(
                  controller: controller.nameController,
                  title: name,
                  hint: nameHint,
                  ispass: false),
              CustomTextField(
                  controller: controller.oldPassController,
                  title: oldPass,
                  hint: passwordHint,
                  ispass: true),
              CustomTextField(
                  controller: controller.newPassController,
                  title: newPass,
                  hint: passwordHint,
                  ispass: true),
              20.heightBox,
              if (controller.isLoading.value)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                )
              else
                SizedBox(
                    width: context.screenWidth - 60,
                    child: ourButton(
                        title: "Save",
                        textColor: whiteColor,
                        color: redColor,
                        onPress: () async {
                          controller.isLoading(true);

                          if (controller.profileImaPath.isNotEmpty) {
                            await controller.uploadProfileImage();
                          } else {
                            controller.profileImageLink = data!['imageUrl'];
                          }

                          if (data!['password'] ==
                              controller.oldPassController.text) {
                            await controller.changeAuthPassword(
                              email: data!['email'],
                              password: controller.oldPassController.text,
                              newPassword: controller.newPassController.text,
                            );

                            await controller.uploadProfileImage();
                            await controller.updateProfile(
                              name: controller.nameController.text,
                              password: controller.newPassController.text,
                              imgUrl: controller.profileImageLink,
                            );
                            VxToast.show(context, msg: "Updated");
                          } else {
                            VxToast.show(context, msg: "Wrong old Password");
                            controller.isLoading(false);
                          }
                        }))
            ],
          )
              .box
              .white
              .rounded
              .shadowSm
              .padding(const EdgeInsets.all(12))
              .margin(const EdgeInsets.only(left: 12, right: 12, top: 50))
              .make(),
        ),
      ),
    ));
  }
}

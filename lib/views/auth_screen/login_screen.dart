import 'package:emart/consts/list.dart';
import 'package:emart/controllers/auth_controller.dart';
import 'package:emart/views/auth_screen/signup_screen.dart';
import 'package:emart/views/home_screen/home.dart';
import 'package:emart/widget_common/applogo_widget.dart';
import 'package:emart/widget_common/custom_textfield.dart';
import 'package:get/get.dart';
import '../../consts/consts.dart';
import '../../widget_common/bg_widget.dart';
import '../../widget_common/our_button.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(AuthController());

    return bgWidget(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogowidget(),
            10.heightBox,
            "Log In as $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(() =>
              Column(
                children: [
                  CustomTextField(title: email,hint: emailHint,ispass: false,controller: controller.emailController),
                  CustomTextField(title: password,hint: passwordHint,ispass: true,controller: controller.passwordController),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){}, child: forgetpass.text.make())),
                  5.heightBox,
                 controller.isLoading.value ? const CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation(redColor),
                 ) : ourButton(
                     onPress: () async {
                        controller.isLoading(true);
                       await controller.loginMethod(context: context).then((value){
                         if (value != null){
                           VxToast.show(context, msg: loggedIn);
                           Get.offAll(()=> const Home());
                         }else{
                           controller.isLoading(false);
                         }
                       });

                     },
                     color: redColor,
                     textColor: whiteColor,
                     title: login)
                     .box.width(context.screenWidth-50).make(),
                  5.heightBox,
                  CreateNewAccout.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                      onPress: (){
                        Get.to(()=> const SignupScreen());
                      },
                      color: lightGolden,
                      textColor: redColor,
                      title: signup)
                      .box.width(context.screenWidth-50).make(),
                  10.heightBox,
                  loginwith.text.color(fontGrey).make(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: lightGrey,
                        child: Image.asset(socialIconList[index],width: 30,),
                      ),
                    ))
                  )
                ],
              ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth-70).shadowSm.make(),
            )
          ],
        ),
      ),
    ));
  }
}

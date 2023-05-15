import 'package:emart/views/home_screen/home.dart';
import 'package:emart/widget_common/applogo_widget.dart';
import 'package:emart/widget_common/custom_textfield.dart';
import 'package:get/get.dart';
import '../../consts/consts.dart';
import '../../controllers/auth_controller.dart';
import '../../widget_common/bg_widget.dart';
import '../../widget_common/our_button.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller1 = Get.put(AuthController());

  // Text Controller

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogowidget(),
              10.heightBox,
              "Join the $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
               () => Column(
                  children: [
                    CustomTextField(title: name,hint: nameHint,controller: nameController,ispass: false),
                    CustomTextField(title: email,hint: emailHint,controller: emailController,ispass: false),
                    CustomTextField(title: password,hint: passwordHint,controller: passwordController,ispass: true),
                    CustomTextField(title: password,hint: retypePassword,controller: passwordRetypeController,ispass: true),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){}, child: forgetpass.text.make())),
                    5.heightBox,
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (newValue){
                            setState(() {
                              isCheck = newValue;
                            });
                            },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )
                              ),
                              TextSpan(
                                  text: term,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  )
                              ),
                              TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )
                              ),
                              TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  )
                              )
                            ]
                          )),
                        )
                      ],
                    ),
                   controller1.isLoading.value ?
                       const CircularProgressIndicator(
                         valueColor: AlwaysStoppedAnimation(redColor),
                       )
                       : ourButton(
                        onPress: () async {
                          controller1.isLoading(true);
                          if(isCheck != false){
                            try {
                              await controller1.signupMethod(context: context, email: emailController.text, password: passwordController.text).then((value){
                                return controller1.storeUserData(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                );
                              }).then((value) {
                                VxToast.show(context, msg: loggedIn);
                                Get.offAll(()=> const Home());
                              });
                            } catch (e){
                              auth.signOut();
                              VxToast.show(context, msg: e.toString());
                              controller1.isLoading(false);
                            }
                          }
                        },
                        color: isCheck == true ? redColor : lightGrey,
                        textColor: whiteColor,
                        title: signup)
                        .box.width(context.screenWidth-50).make(),
                    5.heightBox,
                    RichText(text: const TextSpan(
                      children: [
                        TextSpan(
                          text: alreadyAccount,
                          style: TextStyle(
                            fontFamily: bold,
                            color: fontGrey,
                          )
                        ),
                        TextSpan(
                            text: login,
                            style: TextStyle(
                              fontFamily: bold,
                              color: redColor,
                            )
                        )
                      ]
                    )).onTap(() {
                      Get.back();
                    })
                  ],
                ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth-70).shadowSm.make(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

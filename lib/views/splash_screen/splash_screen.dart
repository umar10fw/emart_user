import 'package:emart/consts/consts.dart';
import 'package:emart/views/auth_screen/login_screen.dart';
import 'package:emart/views/home_screen/home.dart';
import 'package:emart/widget_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  
  ChangeScreen(){
    Future.delayed(Duration(seconds: 3),(){
      // Get.to(()=> LoginScreen());
      auth.authStateChanges().listen((User? user) {
        if(user == null && mounted){
          Get.to(()=> const LoginScreen());
        } else {
          Get.to(()=> const Home());
        }
      });
    });
  }

  @override
  void initState() {
    ChangeScreen();
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: Image.asset(icSplashBg,width: 300,)),
            20.heightBox,
            applogowidget(),
            10.heightBox,
            appname.text.white.fontFamily(bold).size(22).make(),
            5.heightBox,
            const Spacer(),
            appversion.text.white.fontFamily(semibold).make(),
            30.heightBox
          ],
        ),
      ),
    );
  }
}

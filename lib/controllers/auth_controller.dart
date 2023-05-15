import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Text Field Controller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isLoading = false.obs;

  // LogIn Method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // Signup Method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // storing data method

  storeUserData({name, email, password}) async {
    DocumentReference store =
        fireStore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'id': currentUser!.uid,
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      "cart_count": "00",
      "wishlist_count": "00",
      "order_count": "00",
    });
  }
  // SignOut Method

  signOutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}

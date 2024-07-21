import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';

class AuthController extends GetxController {
  // To Know which Screen User is Exist
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  //
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
// these ever Method created by firebase to check if user is login or not
    //  ever(_user, _startScreen);
  }

  // SignOut Method
  void logOut() async {
    await auth.signOut();
    await googleSignIn.signOut();

    CacheHelper.removeData(key: "uId");
  }
}

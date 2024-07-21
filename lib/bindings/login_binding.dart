import 'package:get/get.dart';
import 'package:gouantum/screens/login/login_controller.dart';

class LoginScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );

    // Get.put<LoginController>(LoginController());
    //////
    // Get.putAsync(() async{
    //   LoginController();
    // });
    /////
    //Get.create(() => LoginController());
  }
}

import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  Timer? timer;
  // ignore: non_constant_identifier_names
  RxInt Seconds = 1.obs;
  final time = '00.00'.obs;
  Duration duration = const Duration(seconds: 0);
  // @override
  // void onReady() {
  //   startTimer(0);
  //   super.onReady();
  // }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  startTimer(int seconds) {
    duration = const Duration(seconds: 1);
    Seconds.value = seconds;
    timer = Timer.periodic(duration, (Timer timer) {
      int minutes = Seconds.value ~/ 60;
      int seconds = (Seconds.value % 60);
      time.value =
          "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
      Seconds.value++;
    });
  }
}

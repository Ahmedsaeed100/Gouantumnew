
extension FormatDuration on int {
  String formatDuration() {
    int sec = this % 60;
    int min = (this / 60).floor();
    String minute = "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute: $second";
  }
}

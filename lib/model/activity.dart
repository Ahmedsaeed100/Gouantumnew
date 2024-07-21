class Activity {
  final String? activityAR;
  final String? activityEN;

  Activity({
    this.activityAR,
    this.activityEN,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityAR: json['ActivityAR'],
      activityEN: json['ActivityEN'],
    );
  }
}

class Countries {
  final String? nameCountriesEN;
  final String? nameCountriesAR;

  Countries({
    this.nameCountriesEN,
    this.nameCountriesAR,
  });

  factory Countries.fromJson(Map<String, dynamic> json) {
    return Countries(
      nameCountriesEN: json['name'],
      nameCountriesAR: json['nameCountriesAR'],
    );
  }
}

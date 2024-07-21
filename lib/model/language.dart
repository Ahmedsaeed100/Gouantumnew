class Language {
  final String? languageNameEN;
  final String? languageNameAR;

  Language({this.languageNameEN, this.languageNameAR});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
        languageNameEN: json['languageNameEN'],
        languageNameAR: json['languageNameAR']);
  }
}

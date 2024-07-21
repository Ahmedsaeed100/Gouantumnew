class EducationCategory {
  final String? nameEN;
  final String? nameAR;

  EducationCategory({
    this.nameEN,
    this.nameAR,
  });

  factory EducationCategory.fromJson(Map<String, dynamic> json) {
    return EducationCategory(
      nameEN: json['name'],
      nameAR: json['nameAR'],
    );
  }
}

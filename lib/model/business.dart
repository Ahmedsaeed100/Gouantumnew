class Business {
  final String? businessAR;
  final String? businessEN;

  Business({
    this.businessAR,
    this.businessEN,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessAR: json['name'],
      businessEN: json['businessEN'],
    );
  }
}

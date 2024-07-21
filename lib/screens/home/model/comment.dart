class Comment {
  final String id;
  final String uid;
  final String comment;
  final String name;
  final String imageUser;
  final String imagePost;

  final DateTime createdAt;

  Comment({
    required this.id,
    required this.uid,
    required this.comment,
    required this.name,
    required this.createdAt,
    required this.imagePost,
    required this.imageUser,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      uid: json["uid"],
      comment: json['comment'],
      name: json['name'],
      imageUser: json['image'],
      imagePost: json['imagePost'],
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "comment": comment,
      "name": name,
      "image": imageUser,
      "imagePost": imagePost,
      "createdAt": createdAt,
    };
  }
}

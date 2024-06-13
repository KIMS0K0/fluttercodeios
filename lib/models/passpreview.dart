class PassPreview{
  int passid;
  String title;
  String imageURL;

  PassPreview({
    required this.passid,
    required this.title,
    required this.imageURL,
  });

  factory PassPreview.fromJson(Map<String, dynamic> json) {
    return PassPreview(
      passid: json['id'],
      title: json['title'],
      imageURL: json['imageUrl'],
    );
  }
}
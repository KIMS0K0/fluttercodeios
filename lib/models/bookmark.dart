class Bookmark {
  final int passid;
  final String imageURL;
  final String title;
  final String cityNames;
  final String price;

  Bookmark({
    required this.passid,
    required this.imageURL,
    required this.title,
    required this.cityNames,
    required this.price,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      passid: json['passID'] ?? 0,
      imageURL: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      cityNames: json['cityNames'] ?? '',
      price: json['price'] ?? '',
    );
  }
}
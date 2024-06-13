class PassSearchResult {
  final int passid;
  final String imageURL;
  final String title;
  final String routeInformation;
  final String price;

  PassSearchResult({
    required this.passid,
    required this.imageURL,
    required this.title,
    required this.routeInformation,
    required this.price,
  });

  factory PassSearchResult.fromJson(Map<String, dynamic> json) {
    return PassSearchResult(
      passid: json['passID'],
      imageURL: json['imageUrl'],
      title: json['title'],
      routeInformation: json['routeInformation'],
      price: json['price'],
    );
  }
}
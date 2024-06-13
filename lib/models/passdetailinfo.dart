class PassDetailInfo{
  int passid;
  String transportType;
  String imageURL;
  String title;
  String price;
  String stationNames;
  int period;
  String Map_Url;
  String routeInformation;
  String break_even_usage;
  String description_information;
  String benefit_information;
  String reservation_information;
  String refund_information;

  PassDetailInfo({
    required this.passid,
    required this.transportType,
    required this.imageURL,
    required this.title,
    required this.price,
    required this.stationNames,
    required this.routeInformation,
    required this.period,
    required this.Map_Url,
    required this.break_even_usage,
    required this.description_information,
    required this.benefit_information,
    required this.reservation_information,
    required this.refund_information,
  });

  factory PassDetailInfo.fromJson(Map<String, dynamic> json) {
    return PassDetailInfo(
      passid: json['passId'] ?? 0,
      imageURL: json['imageUrl'] ?? '',
      transportType: json['transportType'] ?? '',
      title: json['title'] ?? '',
      routeInformation: json['routeInformation'] ?? '',
      price: json['price'] ?? '',
      period: json['period'] ?? 0,
      Map_Url: json['map_Url'] ?? '',
      stationNames: json['stationNames'] ?? '',
      break_even_usage: json['break_even_usage'] ?? '',
      description_information: json['productDescription'] ?? '',
      benefit_information: json['benefit_information'] ?? '별도로 제공되는 혜택이 없습니다.',
      reservation_information: json['reservation_information'] ?? '',
      refund_information: json['refund_information'] ?? '',
    );
  }
}

List<PassDetailInfo> passdetailinfo = [

];

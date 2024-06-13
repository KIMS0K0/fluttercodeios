class SearchParameter{
  String query;
  String departureCity;
  String arrivalCity;
  String transportType;
  String cityNames;
  int period;
  int minPrice;
  int maxPrice;
  int quantityAdults;
  int quantityChildren;

  SearchParameter({
    required this.query,
    required this.departureCity,
    required this.arrivalCity,
    required this.transportType,
    required this.cityNames,
    required this.period,
    required this.minPrice,
    required this.maxPrice,
    required this.quantityAdults,
    required this.quantityChildren,
  });
}

List<SearchParameter> searchparameters = [
  SearchParameter(
      query: '0',
      departureCity: '0',
      arrivalCity: '0',
      transportType: '0',
      cityNames: '0',
      period: 0,
      minPrice: 0,
      maxPrice: 0,
      quantityAdults: 0,
      quantityChildren: 0
  )
];
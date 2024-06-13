import 'package:jtpi/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jtpi/models/searchparameters.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jtpi/models/cities.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:jtpi/screens/searchscreen.dart';

class filterscreen extends StatefulWidget {
  final int screennumber;
  final String searchText;

  filterscreen({required this.searchText, required this.screennumber});


  @override
  State<filterscreen> createState() => _filterscreenState();
}

class _filterscreenState extends State<filterscreen> {
  TextEditingController minpriceController = TextEditingController();
  TextEditingController maxpriceController = TextEditingController();
  double _lowerValue = 0.0;
  double _upperValue = 50000.0;
  final focus = FocusNode();
  final focus2 = FocusNode();

  //final List<SearchParameter> SearchParameters = searchparameters;
  List<SearchParameter> SearchParameters = [
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
  final tpt = [-1, -1, -1];
  final date = [-1, -1, -1];

  String? selectedValue;
  List<String> selectedItems = [];

  TextEditingController departureController = TextEditingController();
  TextEditingController arrivalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SearchParameters[0].query = widget.searchText;
    SearchParameters[0].departureCity = '0';
    SearchParameters[0].arrivalCity = '0';
    SearchParameters[0].transportType = '0';
    SearchParameters[0].cityNames = '0';
    SearchParameters[0].period = 0;
    SearchParameters[0].minPrice = 0;
    SearchParameters[0].maxPrice =0;
    SearchParameters[0].quantityAdults = 0;
    SearchParameters[0].quantityChildren = 0;

    minpriceController.text = _lowerValue.toInt().toString();
    maxpriceController.text = _upperValue.toInt().toString();
  }

  void swapText() {
    // 텍스트 교환
    String temp = departureController.text;
    departureController.text = arrivalController.text;
    arrivalController.text = temp;

    // SearchParameter 업데이트
    setState(() {
      SearchParameters[0].departureCity = departureController.text;
      SearchParameters[0].arrivalCity = arrivalController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          SearchParameters[0].departureCity = '0';
          SearchParameters[0].arrivalCity = '0';
          SearchParameters[0].transportType = '0';
          SearchParameters[0].cityNames = '0';
          SearchParameters[0].period = 0;
          SearchParameters[0].minPrice = 0;
          SearchParameters[0].maxPrice =0;
          SearchParameters[0].quantityAdults = 0;
          SearchParameters[0].quantityChildren = 0;
          if (widget.screennumber == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  searchscreen(searchparameter: SearchParameters[0], screennumber: 2,)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(initialTabIndex: 0,)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60.0,
            foregroundColor: Color.fromRGBO(254, 254, 254, 1.0),
            backgroundColor: Color.fromRGBO(254, 254, 254, 1.0),
            surfaceTintColor: Color.fromRGBO(254, 254, 254, 1.0),
            elevation: 0, // appBar 그림자 제거
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade800,
              ),
              onPressed: () {
                SearchParameters[0].departureCity = '0';
                SearchParameters[0].arrivalCity = '0';
                SearchParameters[0].transportType = '0';
                SearchParameters[0].cityNames = '0';
                SearchParameters[0].period = 0;
                SearchParameters[0].minPrice = 0;
                SearchParameters[0].maxPrice =0;
                SearchParameters[0].quantityAdults = 0;
                SearchParameters[0].quantityChildren = 0;

                if (widget.screennumber == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        searchscreen(searchparameter: SearchParameters[0], screennumber: 2,)),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(initialTabIndex: 0,)),
                  );
                }
              },
            ),
            title: Center(
                child: Container(
                  height: 45,
                  child: Center(
                    child: Text(
                      '검색 조건 설정',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
            ),
            actions: [
              SizedBox(width: 50,)
            ],
          ),
          body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () { focus.unfocus(); focus2.unfocus();},
              child: Container(
                  color: Color.fromRGBO(254, 254, 254, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(100, 100, 100, 0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SearchField(
                                        onSearchTextChanged: (query) {
                                          final filter = stationNames
                                              .where((element) =>
                                              element.toLowerCase().contains(query.toLowerCase()))
                                              .toList();
                                          if (filter.contains(query)) {print(query); }
                                          return filter
                                              .map((e) => SearchFieldListItem<String>(e,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 0),
                                                child: Container( child: Text(e,
                                                    style: TextStyle(fontSize: 12, color: Colors.black))),
                                              )))
                                              .toList();
                                        },
                                        key: const Key('departureCity'),
                                        controller: departureController,
                                        hint: '출발역 입력',
                                        itemHeight: 25,
                                        searchStyle: TextStyle(fontSize: 15, color: Colors.black),
                                        searchInputDecoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        suggestionsDecoration: SuggestionDecoration(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(2),
                                            border: Border.all(color: Colors.transparent),
                                            borderRadius: BorderRadius.all(Radius.circular(12))),
                                        suggestions: stationNames
                                            .map((e) => SearchFieldListItem<String>(e,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 0),
                                              child: Text(e,
                                                  style: TextStyle(fontSize: 12, color: Colors.black)),
                                            )))
                                            .toList(),
                                        focusNode: focus,
                                        suggestionState: Suggestion.expand,
                                        onSuggestionTap: (SearchFieldListItem<String> x) {
                                          SearchParameters[0].departureCity = x.searchKey;
                                          focus.unfocus();
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 4), // 출발지 입력 후 공간 추가
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(100, 100, 100, 0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SearchField(
                                        onSearchTextChanged: (query) {
                                          final filter = stationNames
                                              .where((element) =>
                                              element.toLowerCase().contains(query.toLowerCase()))
                                              .toList();
                                          if (filter.contains(query)) {print(query); }
                                          return filter
                                              .map((e) => SearchFieldListItem<String>(e,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 0),
                                                child: Text(e,
                                                    style: TextStyle(fontSize: 12, color: Colors.black)),
                                              )))
                                              .toList();
                                        },
                                        key: const Key('arrivalCity'),
                                        controller: arrivalController,
                                        hint: '도착역 입력',
                                        itemHeight: 25,
                                        searchStyle: TextStyle(fontSize: 15, color: Colors.black),
                                        searchInputDecoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        suggestionsDecoration: SuggestionDecoration(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(2),
                                            border: Border.all(color: Colors.transparent),
                                            borderRadius: BorderRadius.all(Radius.circular(12))),
                                        suggestions: stationNames
                                            .map((e) => SearchFieldListItem<String>(e,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 0),
                                              child: Text(e,
                                                  style: TextStyle(fontSize: 12, color: Colors.black)),
                                            )))
                                            .toList(),
                                        focusNode: focus2,
                                        suggestionState: Suggestion.expand,
                                        onSuggestionTap: (SearchFieldListItem<String> x) {
                                          SearchParameters[0].arrivalCity = x.searchKey;
                                          focus2.unfocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.swap_vert_sharp,
                                      color: Colors.grey.shade800,
                                    ),
                                    iconSize: 28,
                                    padding: EdgeInsets.zero,
                                    onPressed: swapText,
                                  )
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 50), // 위쪽 여백 추가

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 2),
                              Text(
                                '교통수단',
                                style: TextStyle(
                                  letterSpacing: -0.5,
                                  fontSize: 18, // 텍스트 크기 조정
                                  fontWeight: FontWeight.w800, // 굵은 글꼴로 설정
                                  color: Color.fromRGBO(0, 51, 102, 1.0), // 텍스트 색상 설정
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (SearchParameters[0].transportType == '1')
                                    SearchParameters[0].transportType = '0';
                                  else SearchParameters[0].transportType = '1';
                                  setState(() {
                                    tpt[0] = tpt[0] * -1;
                                    if (tpt[0] == 1) {
                                      tpt[1] = -1;
                                      tpt[2] = -1;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
                                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (tpt[0] == 1) ? Colors.grey.shade100 : Colors.transparent;
                                  }),
                                  side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                                    return BorderSide(
                                      color: (tpt[0] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade500,
                                      width: 0.8, // 테두리 두께
                                    );
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (tpt[0] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade700;
                                  }),
                                ),
                                child: Text(
                                  '전철, 버스 혼합',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  if (SearchParameters[0].transportType == '2')
                                    SearchParameters[0].transportType = '0';
                                  else SearchParameters[0].transportType = '2';
                                  setState(() {
                                    tpt[1] = tpt[1] * -1;
                                    if (tpt[1] == 1) {
                                      tpt[0] = -1;
                                      tpt[2] = -1;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
                                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (tpt[1] == 1) ? Colors.grey.shade100 : Colors.transparent;
                                  }),
                                  side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                                    return BorderSide(
                                      color: (tpt[1] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade500,
                                      width: 0.8, // 테두리 두께
                                    );
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (tpt[1] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade700;
                                  }),
                                ),
                                child: Text(
                                  '전철',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  if (SearchParameters[0].transportType == '3')
                                    SearchParameters[0].transportType = '0';
                                  else SearchParameters[0].transportType = '3';
                                  setState(() {
                                    tpt[2] = tpt[2] * -1;
                                    if (tpt[2] == 1) {
                                      tpt[0] = -1;
                                      tpt[1] = -1;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
                                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (tpt[2] == 1) ? Colors.grey.shade100 : Colors.transparent;
                                  }),
                                  side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                                    return BorderSide(
                                      color: (tpt[2] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade500,
                                      width: 0.8, // 테두리 두께
                                    );
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (tpt[2] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade700;
                                  }),
                                ),
                                child: Text(
                                  '버스',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 50), // 위쪽 여백 추가

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 2),
                              Text(
                                '지역',
                                style: TextStyle(
                                  letterSpacing: -0.5,
                                  fontSize: 18, // 텍스트 크기 조정
                                  fontWeight: FontWeight.w800, // 굵은 글꼴로 설정
                                  color: Color.fromRGBO(0, 51, 102, 1.0), // 텍스트 색상 설정
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Wrap(
                            spacing: 10.0, // 버튼 간의 간격
                            children: selectedItems.map((item) {
                              return Chip(
                                labelPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                backgroundColor: Colors.grey.shade100,
                                label: Text(item, style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),
                                deleteIcon: Icon(
                                  Icons.close,
                                  color: Colors.grey[700],
                                  size: 15,
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade500,
                                  width: 0.8, // 테두리 두께
                                ),
                                onDeleted: () {
                                  setState(() {
                                    selectedItems.remove(item);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 6.0),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Container(
                                width: MediaQuery.of(context).size.width - 40,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_sharp,
                                      color: Colors.grey[700],
                                      size: 19,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '추가하기',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: cityNames
                                  .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  if (value != null && !selectedItems.contains(value)) {
                                    selectedItems.add(value);
                                    SearchParameters[0].cityNames = selectedItems.join(',');
                                  }
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 38,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 0.8,
                                  ),
                                  color: Colors.white,
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.expand_more,
                                ),
                                iconSize: 0,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                elevation: 1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.white,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),

                          SizedBox(height: 50), // 위쪽 여백 추가

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 2),
                              Text(
                                '사용 일수',
                                style: TextStyle(
                                  letterSpacing: -0.5,
                                  fontSize: 18, // 텍스트 크기 조정
                                  fontWeight: FontWeight.w800, // 굵은 글꼴로 설정
                                  color: Color.fromRGBO(0, 51, 102, 1.0), // 텍스트 색상 설정
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (SearchParameters[0].period == 1)
                                    SearchParameters[0].period = 0;
                                  else SearchParameters[0].period = 1;
                                  setState(() {
                                    date[0] = date[0] * -1;
                                    if (date[0] == 1) {
                                      date[1] = -1;
                                      date[2] = -1;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
                                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (date[0] == 1) ? Colors.grey.shade100 : Colors.transparent;
                                  }),
                                  side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                                    return BorderSide(
                                      color: (date[0] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade500,
                                      width: 0.8, // 테두리 두께
                                    );
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (date[0] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade700;
                                  }),
                                ),
                                child: Text(
                                  '하루 (1일)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  if (SearchParameters[0].period == 2)
                                    SearchParameters[0].period = 0;
                                  else SearchParameters[0].period = 2;
                                  setState(() {
                                    date[1] = date[1] * -1;
                                    if (date[1] == 1) {
                                      date[0] = -1;
                                      date[2] = -1;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
                                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (date[1] == 1) ? Colors.grey.shade100 : Colors.transparent;
                                  }),
                                  side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                                    return BorderSide(
                                      color: (date[1] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade500,
                                      width: 0.8, // 테두리 두께
                                    );
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (date[1] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade700;
                                  }),
                                ),
                                child: Text(
                                  '2 ~ 3일',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  if (SearchParameters[0].period == 3)
                                    SearchParameters[0].period = 0;
                                  else SearchParameters[0].period = 3;
                                  setState(() {
                                    date[2] = date[2] * -1;
                                    if (date[2] == 1) {
                                      date[0] = -1;
                                      date[1] = -1;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 5, 15, 5)),
                                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (date[2] == 1) ? Colors.grey.shade100 : Colors.transparent;
                                  }),
                                  side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                                    return BorderSide(
                                      color: (date[2] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade500,
                                      width: 0.8, // 테두리 두께
                                    );
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    return (date[2] == 1) ? Colors.blueGrey.shade800 : Colors.grey.shade700;
                                  }),
                                ),
                                child: Text(
                                  '3일 이상',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 50), // 위쪽 여백 추가

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '가격',
                                style: TextStyle(
                                  letterSpacing: -0.5,
                                  fontSize: 18, // 텍스트 크기 조정
                                  fontWeight: FontWeight.w800, // 굵은 글꼴로 설정
                                  color: Color.fromRGBO(0, 51, 102, 1.0), // 텍스트 색상 설정
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: minpriceController,
                                      onChanged: (text) {
                                        setState(() {
                                          if(double.parse(text) >= double.parse(maxpriceController.text)) {
                                            minpriceController.text = maxpriceController.text;
                                            text = maxpriceController.text; }
                                          _lowerValue = double.parse(text);
                                          SearchParameters[0].minPrice = _lowerValue.toInt();
                                        });
                                      },
                                      onSubmitted: (text) {
                                        setState(() {
                                          if(double.parse(text) >= double.parse(maxpriceController.text)) {
                                            minpriceController.text = maxpriceController.text;
                                            text = maxpriceController.text; }
                                          _lowerValue = double.parse(text);
                                          SearchParameters[0].minPrice = _lowerValue.toInt();
                                        });
                                      },
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        suffixIcon: Container(
                                          child: Text('엔', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade800),),
                                        ),
                                        suffixIconConstraints: BoxConstraints(minWidth: 22),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.remove, size: 12,),
                              SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: maxpriceController,
                                      onChanged: (text) {
                                        setState(() {
                                          if(double.parse(text) <= double.parse(minpriceController.text)) {
                                            maxpriceController.text = minpriceController.text;
                                            text = minpriceController.text; }
                                          _upperValue = double.parse(text);
                                          SearchParameters[0].maxPrice = _upperValue.toInt();
                                        });
                                      },
                                      onSubmitted: (text) {
                                        setState(() {
                                          if(double.parse(text) <= double.parse(minpriceController.text)) {
                                            maxpriceController.text = minpriceController.text;
                                            text = minpriceController.text; }
                                          _upperValue = double.parse(text);
                                          SearchParameters[0].maxPrice = _upperValue.toInt();
                                        });
                                      },
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        suffixIcon: Container(
                                          child: Text('엔', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade800),),
                                        ),
                                        suffixIconConstraints: BoxConstraints(minWidth: 22),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                              margin: EdgeInsets.only(left: 2.5, right: 1.2),
                              child: FlutterSlider(
                                values: [_lowerValue, _upperValue],
                                min: 0,
                                max: 50000,
                                touchSize: 5,
                                step: FlutterSliderStep(step: 10),
                                rangeSlider: true,
                                tooltip: FlutterSliderTooltip(
                                  disabled: true,
                                ),
                                trackBar: FlutterSliderTrackBar(
                                  //activeTrackBarHeight: 5,
                                  activeTrackBar: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.5)),
                                ),
                                handlerWidth: 25,
                                handler: FlutterSliderHandler(
                                  /*decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 1),
                      ),*/
                                  child: Icon(Icons.circle, color: Colors.transparent),
                                ),
                                rightHandler: FlutterSliderHandler(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.blue, width: 1),
                                  ),
                                  child: Icon(Icons.circle, color: Colors.transparent),
                                ),
                                handlerAnimation: FlutterSliderHandlerAnimation(
                                    duration: Duration(milliseconds: 700),
                                    scale: 1.1),
                                onDragging: (handlerIndex, lowerValue, upperValue) {
                                  setState(() {
                                    _lowerValue = lowerValue;
                                    _upperValue = upperValue;
                                    minpriceController.text = lowerValue.toInt().toString();
                                    maxpriceController.text = upperValue.toInt().toString();
                                  });
                                },
                              )
                          ),

                          SizedBox(height: 80), // 위쪽 여백 추가

                        ],
                      ),
                    ),
                  )
              )
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade50,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -3)
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width - 30,
            height: 55.0, // 버튼의 높이
            child: FloatingActionButton(
              onPressed: () {
                SearchParameters[0].minPrice = _lowerValue.toInt();
                SearchParameters[0].maxPrice = _upperValue.toInt();
                if(SearchParameters[0] == []) {
                  Navigator.pop(context);
                } else {
                  print('query: ${SearchParameters[0].query}');
                  print('departureCity: ${SearchParameters[0].departureCity}');
                  print('arrivalCity: ${SearchParameters[0].arrivalCity}');
                  print('transportType: ${SearchParameters[0].transportType}');
                  print('cityNames: ${SearchParameters[0].cityNames}');
                  print('period: ${SearchParameters[0].period}');
                  print('minPrice: ${SearchParameters[0].minPrice}');
                  print('maxPrice: ${SearchParameters[0].maxPrice}');
                  print('quantityAdults: ${SearchParameters[0].quantityAdults}');
                  print('quantityChildren: ${SearchParameters[0].quantityChildren}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        searchscreen(searchparameter: SearchParameters[0], screennumber: 2,)),
                  );
                }
              },
              child: Text(
                '조회하기',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color.fromRGBO(0, 51, 102, 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // 원하는 테두리 모양을 적용할 수 있습니다.
                // 더 각진 테두리를 원하면 BorderRadius.circular()의 값 조절
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        )
    );
  }
}
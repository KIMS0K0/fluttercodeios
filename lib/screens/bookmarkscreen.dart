import 'package:flutter/material.dart';
import 'package:jtpi/screens/passinfoscreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jtpi/models/bookmark.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class bookmarkscreen extends StatefulWidget {
  @override
  _bookmarkscreenState createState() => _bookmarkscreenState();
}

class _bookmarkscreenState extends State<bookmarkscreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> bookmarked = [];

  List<Bookmark> _filteredPassDetailInfo = [];
  String _sortBy = '기본순';
  String? selectedValue;
  int _imageType = 0;

  @override
  void initState() {
    super.initState();
    //_filteredPassDetailInfo = _filterBookmarkPassDetailInfo();
    _getbookmark();
  }

  /*List<PassDetailInfo> _filterBookmarkPassDetailInfo() {
    // 북마크된 항목만 필터링
    return passdetailinfo.where((pass) => pass.bookmark == 1).toList();
  }*/

  Future<void> _getbookmark() async {
    final SharedPreferences prefs = await _prefs;
    bookmarked = prefs.getStringList('bookmarked') ?? [];
    prefs.setStringList('bookmarked', bookmarked);
    List<Bookmark> results = await bookmarking(bookmarked);
    setState(() {
      _filteredPassDetailInfo = results;
    });
    _handleSort(_sortBy);
  }
  Future<void> _addbookmark(String _passid) async {
    final SharedPreferences prefs = await _prefs;
    bookmarked = prefs.getStringList('bookmarked') ?? [];
    bookmarked.add(_passid);
    prefs.setStringList('bookmarked', bookmarked);
    print(bookmarked);
    _getbookmark();
  }
  Future<void> _removebookmark(String _passid) async {
    final SharedPreferences prefs = await _prefs;
    bookmarked = prefs.getStringList('bookmarked') ?? [];
    bookmarked.removeWhere((item) => item == _passid);
    prefs.setStringList('bookmarked', bookmarked);
    print(bookmarked);
    _getbookmark();
  }

  Future<List<Bookmark>> bookmarking(List<String> _bookmarked) async {
    List<Bookmark> allResults = [];
    try {
      for (String _passId in _bookmarked) {
        print('passId : ' + _passId);
        final response = await http.post(
          Uri.parse('http://54.180.69.13:8080/passes/bookmark'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode([_passId]),
        );

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
          List<Bookmark> results = body.map((dynamic item) => Bookmark.fromJson(item)).toList();
          allResults.addAll(results);
        } else {
          throw Exception('Failed to load hello message: ${response.statusCode}');
        }
      }
      print(allResults.length);
      if (allResults.isNotEmpty) {
        print(allResults[0].imageURL);
      }
    } catch (e) {
      print('실패: $e');
    }
    return allResults;
  }


  void _handleSort(String sortType) {
    setState(() {
      if (sortType == '기본순') {
        _filteredPassDetailInfo.sort((a, b) {
          final int indexA = bookmarked.indexOf(a.passid.toString());
          final int indexB = bookmarked.indexOf(b.passid.toString());
          return indexA.compareTo(indexB);
        });
      } else if (sortType == '저가순') {
        // 저가순 정렬
        _filteredPassDetailInfo.sort((a, b) => (double.parse((a.price).split(',')[0])).compareTo(double.parse((b.price).split(',')[0])));
      } else if (_sortBy == '고가순') {
        // 고가순 정렬
        _filteredPassDetailInfo.sort((a, b) => (double.parse((b.price).split(',')[0])).compareTo(double.parse((a.price).split(',')[0])));}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(254, 254, 254, 1.0),
            foregroundColor: Color.fromRGBO(254, 254, 254, 1.0),
            surfaceTintColor: Color.fromRGBO(254, 254, 254, 1.0),
            elevation: 0,
            toolbarHeight: 55.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:10),
                Container(
                  height: 45,
                  child: Center(
                    child: Text(
                      '즐겨찾기',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
        // 북마크된 항목만 보여주는 GridView.builder
        body: _filteredPassDetailInfo.isEmpty
            ? Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 수직 방향 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 수평 방향 중앙 정렬
            children: [
              Icon(
                Icons.star_rounded,
                size: 48,
                color: Colors.amber,
              ),
              SizedBox(height: 16), // 아이콘과 텍스트 사이의 간격 조절
              Text(
                '즐겨찾기한 상품이 없어요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Container(
              color: Color.fromRGBO(254, 254, 254, 1.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '기본순',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: <String>['기본순', '저가순', '고가순']
                            .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 13.5,
                              //fontWeight: FontWeight.bold,
                              color: selectedValue == item ? Colors.black : Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                            _sortBy = value.toString();
                          });
                          if (value != null) {
                            _handleSort(value); // 선택된 정렬 기준으로 정렬
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 38,
                          width: 90,
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Color.fromRGBO(200,200,200,1.0),
                            ),
                            color: Colors.white,
                          ),
                          elevation: 0,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.expand_more,
                          ),
                          iconSize: 20,
                          iconEnabledColor: Color.fromRGBO(100,100,100,1.0),
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          //maxHeight: 100,
                          width: 80,
                          elevation: 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                          ),
                          offset: const Offset(3, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 30,
                          padding: EdgeInsets.only(left: 10, right: 10),
                        ),
                      ),
                    ),
                    SizedBox(width: 18,),
                  ]
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.white60,
                  child:GridView.builder(
                    itemCount: _filteredPassDetailInfo.length,
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: (MediaQuery.of(context).size.width - 48)/2 + 95,
                    ),
                    itemBuilder: (context, index) {

                      int id = _filteredPassDetailInfo[index].passid;
                      String title = _filteredPassDetailInfo[index].title;
                      String price = _filteredPassDetailInfo[index].price;
                      String cityNames = _filteredPassDetailInfo[index].cityNames;
                      //int bookmark = _filteredPassDetailInfo[index].bookmark;
                      String imageURL = _filteredPassDetailInfo[index].imageURL;

                      if (imageURL.contains("!@#")) {
                        imageURL = imageURL.split('!@#')[0];
                        _imageType = 5;
                      };

                      return GestureDetector(
                          onTap: () {
                            // 해당 항목을 눌렀을 때 passinfoscreen으로 이동
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      passinfoscreen(passID: _filteredPassDetailInfo[index].passid),
                                )
                            ).then((value) {
                              _getbookmark();
                              _handleSort(_sortBy);
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: (MediaQuery.of(context).size.width - 48)/2,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08), // 그림자 색상
                                              spreadRadius: 2, // 그림자 퍼짐 반경
                                              blurRadius: 3, // 그림자 흐림 정도
                                              offset: Offset(0, 0), // 그림자 위치 (x, y)
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: NetworkImage(imageURL),
                                            fit: _imageType == 5 ? BoxFit.cover : BoxFit.fitWidth, ///////// 사진 풍경일 때랑 로고 사진일 때랑
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                /*bookmarked.contains(id.toString()) ? Icons.star : Icons.star_border,
                                                color: bookmarked.contains(id.toString()) ? Colors.amber : Colors.white,*/
                                                Icons.star_rounded,
                                                color: Colors.amber,
                                              ),
                                              iconSize: 40,
                                              onPressed: () {
                                                setState(() {
                                                  if (bookmarked.contains(id.toString())) {
                                                    _removebookmark(id.toString());
                                                  } else {
                                                    _addbookmark(id.toString());
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 6, 12, 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.grey.shade900,
                                                    offset: Offset(0, 0), // 그림자 위치 (수평, 수직)
                                                    blurRadius: 0.1, // 그림자 흐림 정도
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Row( ///////////////////////////////// 지역
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.location_on,
                                                  color: Colors.blue.shade500, size: 14,),
                                                const SizedBox(width: 3,),
                                                Expanded(
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(0),
                                                        child: Text(cityNames,
                                                          softWrap: true,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            letterSpacing: -0.8,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )
                                                    )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${price.split(',')[0]} 엔',
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                letterSpacing: 0,
                                                color: Color.fromRGBO(0, 51, 120, 1.0),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.grey.shade900,
                                                    offset: Offset(0, 0), // 그림자 위치 (수평, 수직)
                                                    blurRadius: 0.1, // 그림자 흐림 정도
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                              )
                          )
                      );
                    },
                  )
              ),
            ),
          ],
        )
    );
  }
}
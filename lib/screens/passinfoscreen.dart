import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jtpi/models/passdetailinfo.dart';
import 'package:intl/intl.dart'; // intl 패키지 임포트
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';

class passinfoscreen extends StatefulWidget {
  final int passID;

  passinfoscreen({required this.passID});

  @override
  _passinfoscreenState createState() => _passinfoscreenState();
}

class _passinfoscreenState extends State<passinfoscreen> with SingleTickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> bookmarked = [];

  List<PassDetailInfo> passDetailInfo = [
    PassDetailInfo(
      passid: 0,
      transportType: '이동수단',
      imageURL: '',
      title: '패스 TITLE',
      routeInformation: '도쿄',
      price: '2000,1000',
      Map_Url: "0",
      break_even_usage: '0회 이상 이용시 본전 !',
      stationNames: '이동하는 모든 역 목록',
      description_information: '상품 설명 칸',
      period: 0,
      benefit_information: '혜택 정보 칸',
      reservation_information: '예매 정보 칸',
      refund_information: '환불 정보 칸',
    ),
  ];
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTabBar = false;
  Color _titleColor = Colors.white;
  Color _shadowColor = Colors.grey.shade700;
  double screenHeight = 0.0;
  double screenWidth = 150.0;
  String siteUrl = "";

  final GlobalKey _rootKey = GlobalKey();
  final GlobalKey _descriptionKey = GlobalKey();
  final GlobalKey _benefitKey = GlobalKey();
  final GlobalKey _reservationKey = GlobalKey();
  final GlobalKey _refundKey = GlobalKey();

  var _descriptionPosition = 0.0;
  var _benefitPosition = 0.0;
  var _reservationPosition = 0.0;
  var _refundPosition = 0.0;

  ////
  Future<List<PassDetailInfo>> passdetailinfo(String id) async {

    final response = await http.get(Uri.parse('http://54.180.69.13:8080/passes/'+'${id}'));

    try {
      if (response.statusCode == 200) {
        print('Hello Message: ${response.body}'); // 로그 출력
        Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        PassDetailInfo passDetail = PassDetailInfo.fromJson(jsonResponse);
        return [passDetail];
      } else {
        print('Failed to load hello message: ${response.statusCode}');
        return passDetailInfo;
      }
    } catch (e) {
      print('Error fetching hello message: $e');
      return passDetailInfo;
    }

  }

  void tabc() {
    final renderBox = _descriptionKey.currentContext
        ?.findRenderObject() as RenderBox;
    _descriptionPosition = renderBox
        .localToGlobal(Offset.zero)
        .dy - 80.0;

    final renderBox2 = _benefitKey.currentContext
        ?.findRenderObject() as RenderBox;
    _benefitPosition = renderBox2
        .localToGlobal(Offset.zero)
        .dy - 80.0;

    final renderBox3 = _reservationKey.currentContext
        ?.findRenderObject() as RenderBox;
    _reservationPosition = renderBox3
        .localToGlobal(Offset.zero)
        .dy - 80.0;

    final renderBox4 = _refundKey.currentContext
        ?.findRenderObject() as RenderBox;
    _refundPosition = renderBox4
        .localToGlobal(Offset.zero)
        .dy - 80.0;

    _refundPosition = (_reservationPosition + _refundPosition) / 2.0;
    _reservationPosition = (_benefitPosition + _reservationPosition) / 2.0;
    _benefitPosition = (_descriptionPosition + _benefitPosition) / 2.0;
  }

  void _passdetailinfo() async {
    String _passid = widget.passID.toString();
    //String _passid = '1';

    try {
      List<PassDetailInfo> results = await passdetailinfo(_passid);

      setState(() {
        print('A');
        passDetailInfo = results;
        _scrollToIndex(6);
        if (passDetailInfo[0].benefit_information.contains("!@#")) {
          siteUrl = passDetailInfo[0].benefit_information.split('!@#')[1];
          passDetailInfo[0].benefit_information = passDetailInfo[0].benefit_information.split('!@#')[0];
          print('출력출력' + siteUrl);
        }
      });
    } catch (e) {
      print('Error: $e');
      _scrollToIndex(6);
    }
  }
////

  Future<void> _getbookmark() async {
    final SharedPreferences prefs = await _prefs;
    bookmarked = prefs.getStringList('bookmarked') ?? [];
    prefs.setStringList('bookmarked', bookmarked);
  }
  Future<void> _addbookmark(String _passid) async {
    final SharedPreferences prefs = await _prefs;
    bookmarked = prefs.getStringList('bookmarked') ?? [];
    bookmarked.add(_passid);
    prefs.setStringList('bookmarked', bookmarked);
    _getbookmark();
  }
  Future<void> _removebookmark(String _passid) async {
    final SharedPreferences prefs = await _prefs;
    bookmarked = prefs.getStringList('bookmarked') ?? [];
    bookmarked.removeWhere((item) => item == _passid);
    prefs.setStringList('bookmarked', bookmarked);
    _getbookmark();
  }
  ///

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = (MediaQuery.of(context).size.width - 40) * 0.4;
      print("Screen height: $screenHeight");

      tabc();
    });


    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position.pixels;

      if (scrollPosition > 190 && !_showTabBar) {
        setState(() {
          _showTabBar = true;
        });
      } else if (scrollPosition <= 190 && _showTabBar) {
        setState(() {
          _showTabBar = false;
        });
      }

      if (scrollPosition < _benefitPosition) {
        setState(() {
          _tabController.index = 0;
        });
      } else if (scrollPosition >= _benefitPosition && scrollPosition < _reservationPosition) {
        setState(() {
          _tabController.index = 1;
        });
      } else if (scrollPosition >= _reservationPosition && scrollPosition < _refundPosition) {
        setState(() {
          _tabController.index = 2;
        });
      } else setState(() {
        _tabController.index = 3;
      });

      final newColorValue = (scrollPosition / 200).clamp(0.0, 1.0);
      setState(() {
        _titleColor = Color.lerp(Colors.white, Color.fromRGBO(100, 100, 100, 1.0), newColorValue)!;
        _shadowColor = Color.lerp(Colors.grey.shade700, Colors.white, newColorValue)!;
      });

    });

    _passdetailinfo();
    _getbookmark();
  }

  void _scrollToIndex(int index) {
    RenderBox renderBox;
    Offset position;
    switch (index) {
      case 0:
        renderBox = _descriptionKey.currentContext!.findRenderObject() as RenderBox;
        position = renderBox.localToGlobal(
            Offset.zero, ancestor: _rootKey.currentContext!.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset + position.dy -
              AppBar().preferredSize.height -
              (_showTabBar ? kTextTabBarHeight : 0) - 20,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 1:
        renderBox = _benefitKey.currentContext!.findRenderObject() as RenderBox;
        position = renderBox.localToGlobal(
            Offset.zero, ancestor: _rootKey.currentContext!.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset + position.dy -
              AppBar().preferredSize.height -
              (_showTabBar ? kTextTabBarHeight : 0) - 20,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 2:
        renderBox = _reservationKey.currentContext!.findRenderObject() as RenderBox;
        position = renderBox.localToGlobal(
            Offset.zero, ancestor: _rootKey.currentContext!.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset + position.dy -
              AppBar().preferredSize.height -
              (_showTabBar ? kTextTabBarHeight : 0) - 20,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 3:
        renderBox = _refundKey.currentContext!.findRenderObject() as RenderBox;
        position = renderBox.localToGlobal(
            Offset.zero, ancestor: _rootKey.currentContext!.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset + position.dy -
              AppBar().preferredSize.height -
              (_showTabBar ? kTextTabBarHeight : 0) - 20,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 4:
        _scrollController.animateTo(
          MediaQuery.of(context).size.height,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 5:
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      default:
        print('Q');
        print(passDetailInfo[0].Map_Url);
        _scrollController.animateTo(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
    }
  }

  int _imageExist = 1;
  imageExpanded() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Image.network(
        passDetailInfo[0].Map_Url,
        fit: BoxFit.cover,
        width: double.infinity, // 가로 너비를 컨테이너에 맞게 설정
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          _imageExist = 0;
          return Container(height: screenWidth,
              child:Center(child:Text('No Image', style: TextStyle(fontSize: 20),))
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //String price = NumberFormat('#,###').format(passDetailInfo[0].price);
    String priceAdult = NumberFormat('#,###').format(double.parse((passDetailInfo[0].price).split(',')[0]));
    String priceChild = NumberFormat('#,###').format(double.parse((passDetailInfo[0].price).split(',')[1]));

    return Scaffold(
      body: Container(
        key: _rootKey,
        color: Color.fromRGBO(254, 254, 254, 1.0), // 배경색 설정
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Color.fromRGBO(254, 254, 254, 1.0),
              foregroundColor: Color.fromRGBO(254, 254, 254, 1.0),
              surfaceTintColor: Color.fromRGBO(254, 254, 254, 1.0),
              leading: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      height: 45,
                      child: IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정
                        constraints: BoxConstraints(),
                        iconSize: 28,
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: _titleColor,
                          shadows: <Shadow>[Shadow(color: _shadowColor, blurRadius: 2.0)],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]
              ),
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                      children: [
                        Center(
                            child: Image.network(
                              passDetailInfo[0].imageURL,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset(
                                      'assets/logo3.png',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                );
                              },
                            )
                        ),
                        Container(
                          color: Colors.grey.withOpacity(0.1), // 회색 반투명 레이어
                        ),
                      ]
                  )
              ),
              bottom: _showTabBar
                  ? TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 글자색
                labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // 선택된 탭의 스타일
                unselectedLabelStyle: TextStyle(fontSize: 16.0), // 선택되지 않은 탭의 스타일
                indicatorSize: TabBarIndicatorSize.label, // 탭바 인디케이터 크기
                tabs: [
                  Tab(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 20, // 탭 높이 설정
                      child: Text('상품 설명'),
                    ),
                  ),
                  Tab(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 20, // 탭 높이 설정
                      child: Text('혜택'),
                    ),
                  ),
                  Tab(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 20, // 탭 높이 설정
                      child: Text('예매'),
                    ),
                  ),
                  Tab(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 20, // 탭 높이 설정
                      child: Text('환불'),
                    ),
                  ),
                ],
                onTap: _scrollToIndex,
              )
                  : null,
              actions: [
                Column(
                    children: [
                      SizedBox(height: 5,),
                      Container(
                        //height: 22,
                        child: IconButton(
                          icon: Icon(
                            bookmarked.contains(widget.passID.toString()) ? Icons.star : Icons.star_border_sharp,
                            color: bookmarked.contains(widget.passID.toString()) ? Colors.amber : _titleColor,
                            shadows: <Shadow>[Shadow(color: _shadowColor, blurRadius: 2.0)],
                          ),
                          iconSize: 32,
                          onPressed: () {
                            setState(() {
                              if (bookmarked.contains(widget.passID.toString())) {
                                _removebookmark(widget.passID.toString());
                              } else {
                                _addbookmark(widget.passID.toString());
                              }
                            });
                          },
                        ),
                      )
                    ]
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 4),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color.fromRGBO(243, 243, 243, 0.95),
                              ),
                              width: 120,
                              height: 30,
                              child: Center(
                                child: Text(
                                  ' ' + passDetailInfo[0].transportType,
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 3),
                            Text(
                              passDetailInfo[0].title,
                              style: TextStyle(
                                letterSpacing: -1,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(0, 0), // 그림자 위치 (수평, 수직)
                                    blurRadius: 0.05, // 그림자 흐림 정도
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue.shade500,
                              size: 22,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  passDetailInfo[0].routeInformation,
                                  style: TextStyle(
                                    letterSpacing: -0.8,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(width: 2),
                            Text(
                              priceAdult + ' 엔',
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 18, // 텍스트 크기 조정
                                fontWeight: FontWeight.bold, // 굵은 글꼴로 설정
                                color: Color.fromRGBO(0, 51, 120, 1.0), // 텍스트 색상 설정
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Divider(height: 2, color: Colors.grey.shade300),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8.5, 0, 0),
                                    child: Icon(Icons.circle, size: 5,)),
                                SizedBox(width: 8,),
                                Text('어른 $priceAdult 엔 / 어린이 : $priceChild 엔',
                                  style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8.5, 0, 0),
                                    child: Icon(Icons.circle, size: 5,)),
                                SizedBox(width: 8,),
                                Text('유효기간 ' + passDetailInfo[0].period.toString()+'일',
                                  style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8.5, 0, 0),
                                    child: Icon(Icons.circle,
                                      size: passDetailInfo[0].break_even_usage.toString() == "" ? 0: 5,)),
                                SizedBox(width: 8,),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text(passDetailInfo[0].break_even_usage.toString(),
                                          style: TextStyle(fontWeight: FontWeight.w500),)
                                    )
                                ),
                              ],
                            )
                          ]
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10, key: _descriptionKey,),
                        SizedBox(height: 20),
                        Container(
                          child: Text('상품 설명',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 18, // 텍스트 크기 조정
                              fontWeight: FontWeight.bold, // 굵은 글꼴로 설정
                              color: Color.fromRGBO(0, 51, 120, 1.0), // 텍스트 색상 설정
                            ),),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                          child: Text('${passDetailInfo[0].description_information}'),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 35, 0, 15),
                          child: Column(
                            children: [
                              ExpandableNotifier(
                                child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: false,
                                    child: Builder(
                                      builder: (context) {
                                        var controller = ExpandableController.of(context, required: true)!;
                                        return Stack(
                                          children: [
                                            InkWell(
                                              onTap: () { controller.toggle(); },
                                              child: controller.expanded ? imageExpanded() :
                                              Container( height: screenWidth, child: imageExpanded(), ),
                                            ),
                                            _imageExist == 1 ?
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                height: 30, width: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  //shape: BoxShape.circle,
                                                  color: Color.fromRGBO(255,255,255,0.5),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(100,100,100,0.8),
                                                    width: 1.5, // 두께 5
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () { controller.toggle(); tabc();},
                                                  splashColor: Colors.grey,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () { controller.toggle(); },
                                                    icon: Icon(controller.expanded ? Icons.zoom_in_map_rounded : Icons.zoom_out_map_rounded),
                                                    color: Color.fromRGBO(50, 50, 50, 1.0),
                                                    iconSize: 25,
                                                  ), // 터치 효과 색상 설정
                                                ),

                                              ),
                                            ) : Container(),
                                          ],
                                        );
                                      },
                                    )
                                ),
                              ),
                              ExpandableNotifier(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ScrollOnExpand(
                                      scrollOnExpand: true,
                                      scrollOnCollapse: false,
                                      child: Expandable(
                                          collapsed: Container(color: Colors.transparent,),
                                          expanded: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  passDetailInfo[0].stationNames,
                                                  softWrap: true,
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Center(
                                      child: Builder(
                                        builder: (context) {
                                          var controller = ExpandableController.of(context, required: true)!;
                                          return InkWell(
                                            onTap: () {
                                              controller.toggle();
                                              tabc();
                                            },
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(0),
                                                border: Border.all(
                                                  //color: Color.fromRGBO(11, 136, 177, 0.5), // 연한 하늘색
                                                  color: Color.fromRGBO(0, 51, 102, 0.5),
                                                  width: 1, // 두께 5
                                                ),
                                              ),
                                              padding: EdgeInsets.all(0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    controller.expanded ? "모든 역 목록" : "모든 역 목록",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(0, 51, 102, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    controller.expanded ? Icons.expand_less : Icons.expand_more,
                                                    color: Color.fromRGBO(0, 51, 102, 0.9),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 40),
                        SizedBox(height: 10, key: _benefitKey,),
                        SizedBox(height: 20),
                        Container(
                          child: const Text('혜택',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 18, // 텍스트 크기 조정
                              fontWeight: FontWeight.bold, // 굵은 글꼴로 설정
                              color: Color.fromRGBO(0, 51, 120, 1.0), // 텍스트 색상 설정
                            ),),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                          child: Text(passDetailInfo[0].benefit_information == "" ? "별도의 혜택이 없습니다." : passDetailInfo[0].benefit_information),
                        ),
                        siteUrl == "" ? Container() :
                        TextButton(
                            onPressed: () {
                              Future<void> _launchUrl() async {
                                try {
                                  final Uri url = Uri.parse(siteUrl);
                                  if (!await launchUrl(url)) {
                                    print('실패..');
                                    throw Exception('Could not launch $url');
                                  }
                                } catch (e) {
                                  print('실패.. $e');
                                }
                              }
                              _launchUrl();
                            }, child: Text('공식 페이지 방문하기', style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromRGBO(50, 50, 50, 1.0)),)),

                        SizedBox(height: 40),
                        SizedBox(height: 10, key: _reservationKey,),
                        SizedBox(height: 20),
                        Container(
                          child: const Text('예매',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 18, // 텍스트 크기 조정
                              fontWeight: FontWeight.bold, // 굵은 글꼴로 설정
                              color: Color.fromRGBO(0, 51, 120, 1.0), // 텍스트 색상 설정
                            ),),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                          child: Text('${passDetailInfo[0].reservation_information}'),
                        ),

                        SizedBox(height: 40),
                        SizedBox(height: 10, key: _refundKey,),
                        SizedBox(height: 20),
                        Container(
                          child: const Text('환불',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 18, // 텍스트 크기 조정
                              fontWeight: FontWeight.bold, // 굵은 글꼴로 설정
                              color: Color.fromRGBO(0, 51, 120, 1.0), // 텍스트 색상 설정
                            ),),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 40),
                          child: Text('${passDetailInfo[0].refund_information}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: null,
            elevation: 2,
            backgroundColor: const Color.fromRGBO(255,255,255,1.0),
            shape: CircleBorder(side: BorderSide(color: Color.fromRGBO(0,0,0,0.1), width: 1.0)),
            onPressed: (){ _scrollToIndex(5); },
            child: const Icon(Icons.arrow_upward_rounded, color: Color.fromRGBO(0, 51, 102, 1.0), size: 26),
          ),
          SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: null,
            elevation: 2,
            backgroundColor: const Color.fromRGBO(255,255,255,1.0),
            shape: CircleBorder(side: BorderSide(color: Color.fromRGBO(0,0,0,0.1), width: 1.0)),
            onPressed: (){ _scrollToIndex(4); },
            child: const Icon(Icons.arrow_downward_rounded, color: Color.fromRGBO(0, 51, 102, 1.0), size: 26),
          ),
          SizedBox(height: 25),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
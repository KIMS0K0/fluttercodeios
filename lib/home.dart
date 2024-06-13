import 'dart:math';
import 'package:jtpi/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jtpi/models/passdetailinfo.dart';
import 'package:jtpi/screens/mainscreen.dart';
import 'package:jtpi/screens/filterscreen.dart';
import 'package:jtpi/screens/passinfoscreen.dart';
import 'package:jtpi/screens/searchscreen.dart';
import 'package:jtpi/screens/bookmarkscreen.dart';
import 'package:jtpi/util/my_tab.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  final int initialTabIndex; // 초기 탭 인덱스

  const HomeScreen({Key? key, required this.initialTabIndex}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int initialTabindex = 0;

  List<Widget> myTabs = [
    MyTab(iconData: Icons.search, text: '검색'),
    MyTab(iconData: Icons.star_border, text: '즐겨찾기'),
  ];

  void initState() {
    super.initState();
    initialTabindex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      initialIndex: initialTabindex,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(254, 254, 254, 1.0),
        body: Column(
          children: [
            // tab bar view
            Expanded(
              child:
              TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // donut page
                  mainscreen(),
                  bookmarkscreen(),
                ],
              ),
            ),
            Consumer<CountProvider>(
                builder: (context, counter, child) {
                  return counter.count == 0 ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경색을 흰색으로 설정
                      borderRadius: BorderRadius.circular(0), // 컨테이너의 모서리를 둥글게 만듦
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // 그림자 색상과 투명도 설정
                          spreadRadius: 3, // 그림자 퍼짐 정도
                          blurRadius: 3, // 그림자 흐림 정도
                          offset: Offset(0, 3), // 그림자 위치 조정 (수평, 수직)
                        ),
                      ],
                    ),
                    child: TabBar(tabs: myTabs),
                  ) : Container();})
          ],
        ),
      ),
    );
  }
}
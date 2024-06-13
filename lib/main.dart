import 'package:flutter/material.dart';
import 'package:jtpi/home.dart';
import 'package:provider/provider.dart';

class CountProvider with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void one() {
    _count = 1;
    notifyListeners(); // 값 증가 후 상태 변경 알림
  }

  void zero() {
    _count = 0;
    notifyListeners(); // 값 감소 후 상태 변경 알림
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CountProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(initialTabIndex: 0,),
    );
  }
}
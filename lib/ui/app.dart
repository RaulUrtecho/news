import 'package:flutter/material.dart';
import 'package:news/ui/news/news_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NewsPage());
  }
}

import 'package:flutter/material.dart';
import 'package:news/data/models/article.dart';

class ArticlePage extends StatelessWidget {
  final Article _article;

  const ArticlePage(this._article, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(_article.title)), body: Text(_article.content));
  }
}

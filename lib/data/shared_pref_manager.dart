import 'dart:convert';

import 'package:news/data/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static const articlesKey = 'articles';

  Future<List<Article>> getArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final articlesList = prefs.getStringList(articlesKey);
    return articlesList != null
        ? articlesList.map((articleStr) => Article.fromJson(jsonDecode(articleStr))).toList()
        : [];
  }

  Future<void> saveFavoriteArticle(Article newArticle) async {
    final prefs = await SharedPreferences.getInstance();
    final articlesList = prefs.getStringList(articlesKey) ?? [];
    articlesList.add(json.encode(newArticle.toJson()));
    await prefs.setStringList(articlesKey, articlesList);
  }

  Future<void> removeFavoriteArticle(Article articleToRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final articlesList = prefs.getStringList(articlesKey) ?? [];
    final index = articlesList.indexWhere((articleJson) {
      final article = Article.fromJson(json.decode(articleJson));
      return article.title == articleToRemove.title && article.url == articleToRemove.url;
    });
    if (!index.isNegative) {
      articlesList.removeAt(index);
      await prefs.setStringList(articlesKey, articlesList);
    }
  }
}

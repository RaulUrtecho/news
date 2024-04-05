import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:news/data/models/article.dart';
import 'package:news/data/models/network_error.dart';
import 'package:news/data/models/news_api_response.dart';
import 'package:news/data/models/result.dart';

class NewsRepository {
  static const _apiKey = '1ce11208adf34da080dbaa42a15a8e5e';

  Future<Result<List<Article>, NetworkError>> getNews(String query) async {
    try {
      final uri = Uri.https('newsapi.org', 'v2/everything', {
        'q': query,
        'sortBy': 'popularity',
        'apiKey': _apiKey,
      });
      final response = await get(uri);
      if (response.statusCode == HttpStatus.ok) {
        return Result.value(NewsApiResponse.fromJson(json.decode(response.body)).articles);
      }
      throw response.statusCode;
    } catch (e) {
      return Result.error(NetworkError(message: e.toString()));
    }
  }
}

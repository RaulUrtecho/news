import 'package:news/data/models/article.dart';

class NewsApiResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  const NewsApiResponse({required this.status, required this.totalResults, required this.articles});

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    return NewsApiResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: List.from(json['articles']).map((i) => Article.fromJson(i)).toList(),
    );
  }
}

// ignore: depend_on_referenced_packages
import 'package:faker/faker.dart';

class Article {
  final Source source;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String content;
  final bool isFavorite;

  const Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.isFavorite,
  });

  Article copyWith({bool? isFavorite}) {
    return Article(
      source: source,
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['source'] = source.toJson();
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    data['isFavorite'] = isFavorite;
    return data;
  }

  /// Used for testing
  factory Article.fake({String? title}) {
    return Article(
      source: Source(id: faker.randomGenerator.string(4), name: faker.company.name()),
      author: faker.person.name(),
      title: title ?? faker.lorem.sentence(),
      description: faker.lorem.sentences(4).join(),
      url: faker.internet.httpUrl(),
      urlToImage: faker.internet.httpUrl(),
      publishedAt: faker.date.time(),
      content: faker.lorem.sentences(4).join(),
      isFavorite: faker.randomGenerator.boolean(),
    );
  }
}

class Source {
  final String? id;
  final String name;

  const Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

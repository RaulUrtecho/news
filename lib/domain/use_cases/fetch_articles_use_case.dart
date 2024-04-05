import 'package:news/data/models/network_error.dart';
import 'package:news/data/models/article.dart';
import 'package:news/data/models/result.dart';
import 'package:news/data/news_repository.dart';

class FetchArticlesUseCase {
  final NewsRepository _newsRepository;

  const FetchArticlesUseCase(this._newsRepository);

  Future<Result<List<Article>, NetworkError>> run(String input) async {
    return _newsRepository.getNews(input);
  }
}

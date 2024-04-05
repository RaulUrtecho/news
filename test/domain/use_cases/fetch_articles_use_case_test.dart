import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/data/models/article.dart';
import 'package:news/data/models/network_error.dart';
import 'package:news/data/models/result.dart';
import 'package:news/data/news_repository.dart';
import 'package:news/domain/use_cases/fetch_articles_use_case.dart';
import 'fetch_articles_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NewsRepository>()])
void main() {
  group('FetchArticlesUseCase', () {
    late MockNewsRepository newsRepository;
    late FetchArticlesUseCase fetchArticlesUseCase;
    const searchQuery = 'Flutter';
    final articles = [Article.fake(title: 'Flutter is awesome')];
    const error = NetworkError(message: 'Some HTTP error or exception');

    setUp(() async {
      newsRepository = MockNewsRepository();
      fetchArticlesUseCase = FetchArticlesUseCase(newsRepository);
    });

    test('Search articles success returns a List<Articles>', () async {
      final result = ValueResult<List<Article>, NetworkError>(articles);
      // Arrange
      when(newsRepository.getNews(searchQuery)).thenAnswer((_) async => result);
      // Act
      final actualResult = await fetchArticlesUseCase.run(searchQuery);
      // Assert
      verify(newsRepository.getNews(searchQuery));
      verifyNoMoreInteractions(newsRepository);
      expect(actualResult, equals(result));
    });

    test('Search articles fails returns a NetworkError', () async {
      const result = ErrorResult<List<Article>, NetworkError>(error);
      // Arrange
      when(newsRepository.getNews(searchQuery)).thenAnswer((_) async => result);
      // Act
      final actualResult = await fetchArticlesUseCase.run(searchQuery);
      // Assert
      verify(newsRepository.getNews(searchQuery));
      verifyNoMoreInteractions(newsRepository);
      expect(actualResult, equals(result));
    });
  });
}

/// Last run logs
///
/// ✓ News Repository Search articles success returns a List<Articles>
/// ✓ News Repository Search articles fails returns a NetworkError
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news/data/models/article.dart';
import 'package:news/data/models/network_error.dart';
import 'package:news/data/models/result.dart';
import 'package:news/data/shared_pref_manager.dart';
import 'package:news/domain/use_cases/fetch_articles_use_case.dart';
import 'package:news/ui/app.dart';
import 'package:news/ui/news/bloc/news_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/domain/use_cases/fetch_articles_use_case_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockNewsRepository newsRepository;
  const searchQuery = 'Flutter';
  final articles = [Article.fake(title: 'Flutter is awesome')];

  setUpAll(() {
    newsRepository = MockNewsRepository();
    SharedPreferences.setMockInitialValues({SharedPrefManager.articlesKey: []});
    GetIt.I.registerFactory(() => NewsBloc(FetchArticlesUseCase(newsRepository), SharedPrefManager()));
  });

  tearDownAll(() async => GetIt.instance.reset());

  testWidgets('Search an article', (tester) async {
    // Ensure that Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    final result = ValueResult<List<Article>, NetworkError>(articles);

    /// Stub calls
    when(newsRepository.getNews(searchQuery)).thenAnswer((_) async {
      return Future<Result<List<Article>, NetworkError>>.delayed(const Duration(seconds: 2), () => result);
    });

    /// Build and deploy the app
    await tester.pumpWidget(const App());

    /// UI Test 1 find the search input title
    final searchInput = find.byType(TextField);
    expect(searchInput, findsOneWidget);

    /// Redraw
    await tester.pump();

    /// Enter the query into the TextField.
    await tester.enterText(searchInput, searchQuery);

    /// Redraw
    await tester.pump(const Duration(milliseconds: 500));

    /// UI test 2 fin an loading indicator
    expect(find.byWidgetPredicate((widget) => widget is CircularProgressIndicator), findsOneWidget);

    /// Press done to hide keyboard
    await tester.testTextInput.receiveAction(TextInputAction.done);

    /// Redraw
    await tester.pump(const Duration(seconds: 3));

    /// UI test 3 fin an article search result
    expect(find.byWidgetPredicate((widget) => widget is ListTile), findsOneWidget);

    /// End test after 2 secs
    await tester.pump(const Duration(seconds: 2));
  });
}

/// 00:03 +0: loading /Users/RAULURTECHO/Desktop/news/integration_test/app_test.dart                                                Ru00:17 +0: loading /Users/RAULURTECHO/Desktop/news/integration_test/app_test.dart                                                 
/// 00:19 +0: loading /Users/RAULURTECHO/Desktop/news/integration_test/app_test.dart                                          2,020ms
/// Xcode build done.                                           
/// 16.0s00:30 +1: All tests passed!  

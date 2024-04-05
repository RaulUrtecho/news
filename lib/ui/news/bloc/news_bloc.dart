import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/shared_pref_manager.dart';
import 'package:news/data/models/article.dart';
import 'package:news/domain/use_cases/fetch_articles_use_case.dart';
import 'package:rxdart/rxdart.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchArticlesUseCase _fetchArticlesUseCase;
  final SharedPrefManager _sharedPrefManager;
  late final Timer _pollingTimer;

  NewsBloc(this._fetchArticlesUseCase, this._sharedPrefManager) : super(NewsState.initial()) {
    on<Initial>((_, emit) => _fetchFavorites(emit));
    on<OnSearchArticles>(_onSearchArticles, transformer: _debounceTransformer);
    on<RefreshArticles>((_, emit) => _fetchArticles(state.currentQuery, emit));
    on<ClearError>((_, emit) => emit(state.copyWith(showError: '')));
    on<OnFavoritePressed>(_onFavoritePressed);

    // Refresh current news every 30 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (state.currentQuery.isNotEmpty) {
        add(const RefreshArticles());
      }
    });
  }

  @override
  Future<void> close() {
    _pollingTimer.cancel();
    return super.close();
  }

  Future<void> _fetchFavorites(Emitter<NewsState> emit) async {
    final favorites = await _sharedPrefManager.getArticles();
    emit(state.copyWith(favorites: favorites));
  }

  /// Debounce to avoid making search network calls each time the user types
  Stream<OnSearchArticles> _debounceTransformer(
      Stream<OnSearchArticles> events, Stream<OnSearchArticles> Function(OnSearchArticles) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 300)).switchMap(transitionFn);
  }

  Future<void> _onSearchArticles(OnSearchArticles event, Emitter<NewsState> emit) async {
    emit(state.copyWith(currentQuery: event.query));
    // fire searching when there are at least 2 characters typed
    if (state.currentQuery.length > 2) {
      await _fetchArticles(event.query, emit);
    } else if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: []));
    }
  }

  Future<void> _fetchArticles(String query, Emitter<NewsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _fetchArticlesUseCase.run(query);
    if (result.isSuccess) {
      emit(state.copyWith(isLoading: false, searchResults: updateRemoteArticlesWithFavorites(result.asValue.data)));
    } else {
      emit(state.copyWith(isLoading: false, showError: result.asError.error.message));
    }
  }

  List<Article> updateRemoteArticlesWithFavorites(List<Article> remoteArticles) {
    return remoteArticles.map((remote) {
      final isFavoriteLocally = state.favorites.any((local) => local.title == remote.title && local.url == remote.url);
      return isFavoriteLocally ? remote.copyWith(isFavorite: true) : remote;
    }).toList();
  }

  Future<void> _onFavoritePressed(OnFavoritePressed event, Emitter<NewsState> emit) async {
    if (event.article.isFavorite) {
      await _sharedPrefManager.removeFavoriteArticle(event.article);
    } else {
      await _sharedPrefManager.saveFavoriteArticle(event.article.copyWith(isFavorite: true));
    }
    final updated = event.article.copyWith(isFavorite: !event.article.isFavorite);
    final index = state.searchResults.indexWhere((article) {
      return article.title == updated.title && article.url == updated.url;
    });
    if (!index.isNegative) {
      emit(state.copyWith(
        searchResults: [...state.searchResults]
          ..removeAt(index)
          ..insert(index, updated),
      ));
    }
    await _fetchFavorites(emit);
  }
}

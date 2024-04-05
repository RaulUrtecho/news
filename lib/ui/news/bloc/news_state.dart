part of 'news_bloc.dart';

class NewsState extends Equatable {
  final bool isLoading;
  final List<Article> searchResults;
  final List<Article> favorites;
  final String currentQuery;
  final String showError;

  const NewsState({
    required this.isLoading,
    required this.searchResults,
    required this.favorites,
    required this.currentQuery,
    required this.showError,
  });

  @override
  List<Object> get props => [
        isLoading,
        favorites,
        searchResults,
        currentQuery,
        showError,
        articles,
      ];

  List<Article> get articles => searchResults.isNotEmpty ? searchResults : favorites;

  factory NewsState.initial() => const NewsState(
        isLoading: false,
        searchResults: [],
        favorites: [],
        currentQuery: '',
        showError: '',
      );

  NewsState copyWith({
    bool? isLoading,
    List<Article>? searchResults,
    List<Article>? favorites,
    String? currentQuery,
    String? showError,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      searchResults: searchResults ?? this.searchResults,
      favorites: favorites ?? this.favorites,
      currentQuery: currentQuery ?? this.currentQuery,
      showError: showError ?? this.showError,
    );
  }
}

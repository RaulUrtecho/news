part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class Initial extends NewsEvent {
  const Initial();
}

class OnSearchArticles extends NewsEvent {
  final String query;
  const OnSearchArticles(this.query);
}

class RefreshArticles extends NewsEvent {
  const RefreshArticles();
}

class OnFavoritePressed extends NewsEvent {
  final Article article;

  const OnFavoritePressed(this.article);
}

class ClearError extends NewsEvent {
  const ClearError();
}

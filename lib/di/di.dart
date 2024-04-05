import 'package:get_it/get_it.dart';
import 'package:news/data/news_repository.dart';
import 'package:news/data/shared_pref_manager.dart';
import 'package:news/domain/use_cases/fetch_articles_use_case.dart';
import 'package:news/ui/news/bloc/news_bloc.dart';

void registerDependencies() {
  // Register Bloc in DI system
  GetIt.I.registerFactory(() => NewsBloc(FetchArticlesUseCase(NewsRepository()), SharedPrefManager()));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news/ui/article/article_page.dart';
import 'package:news/ui/news/bloc/news_bloc.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I.get<NewsBloc>()..add(const Initial()),
      child: Scaffold(
        appBar: AppBar(title: Builder(
          builder: (context) {
            return TextField(onChanged: (value) => context.read<NewsBloc>().add(OnSearchArticles(value)));
          },
        )),
        body: SafeArea(
          child: BlocConsumer<NewsBloc, NewsState>(
            listenWhen: (_, current) => current.showError.isNotEmpty,
            listener: (context, _) {
              context.read<NewsBloc>().add(const ClearError());
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Something went wrong, try again.'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ));
            },
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading || previous.articles != current.articles,
            builder: (context, state) {
              return state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      key: const PageStorageKey<String>('1'),
                      itemCount: state.articles.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return ListTile(
                          key: Key('${article.title} ${article.url}'),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticlePage(article))),
                          title: Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            article.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () => context.read<NewsBloc>().add(OnFavoritePressed(article)),
                            icon: Icon(
                              article.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: article.isFavorite ? Colors.red : null,
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}

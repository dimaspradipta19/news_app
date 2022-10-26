import 'package:dicoding_news/data/api/service.dart';
import 'package:dicoding_news/data/models/article.dart';
import 'package:dicoding_news/provider/news_provider.dart';
import 'package:dicoding_news/widgets/card_article.dart';
import 'package:dicoding_news/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  late Future<ArticlesResult> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiService().topHeadlines();
  }

  Widget _buildList(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, NewsProvider data, _) {
        if (data.resultState == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.resultState == ResultState.hasData) {
          return ListView.builder(
            itemCount: data.articleResult.articles.length,
            itemBuilder: (context, index) {
              final article = data.articleResult.articles[index];
              return CardArticle(article: article);
            },
          );
        } else if (data.resultState == ResultState.noData) {
          return Center(
            child: Material(child: Text(data.message)),
          );
        } else if (data.resultState == ResultState.error) {
          return Center(
            child: Material(
              child: Text(data.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(""),
            ),
          );
        }
      },
    );
    // return FutureBuilder(
    //   future: _article,
    //   builder: (context, AsyncSnapshot<ArticlesResult> snapshot) {
    //     var state = snapshot.connectionState;
    //     if (state != ConnectionState.done) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else {
    //       if (snapshot.hasData) {
    //         return ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: snapshot.data?.articles.length,
    //           itemBuilder: (context, index) {
    //             var article = snapshot.data?.articles[index];
    //             return CardArticle(article: article!);
    //           },
    //         );
    //       } else if (snapshot.hasError) {
    //         return Center(
    //           child: Material(
    //             child: Text(snapshot.error.toString()),
    //           ),
    //         );
    //       } else {
    //         return const Material(child: Text(''));
    //       }
    //     }
    //   },
    // );
  }

  // Widget _buildArticleItem(BuildContext context, Article article) {
  //   return ListTile(
  //     contentPadding:
  //         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     leading: Hero(
  //       tag: article.urlToImage,
  //       child: Image.network(
  //         article.urlToImage,
  //         width: 100,
  //       ),
  //     ),
  //     title: Text(
  //       article.title,
  //     ),
  //     subtitle: Text(article.author),
  //     onTap: () {
  //       Navigator.pushNamed(context, ArticleDetailPage.routeName,
  //           arguments: article);
  //     },
  //   );
  // }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('News App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}

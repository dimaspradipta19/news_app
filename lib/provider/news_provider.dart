import 'package:dicoding_news/data/api/service.dart';
import 'package:dicoding_news/data/models/article.dart';
import 'package:flutter/cupertino.dart';

enum ResultState {
  loading,
  noData,
  hasData,
  error,
}

class NewsProvider extends ChangeNotifier {
  final ApiService apiService;

  NewsProvider({required this.apiService}) {
    _fetchAllArticle();
  }

  late ArticlesResult _articlesResult;
  late ResultState _state;
  String _message = "";

  String get message => _message;
  ArticlesResult get  articleResult => _articlesResult;
  ResultState get resultState => _state;

  Future<dynamic> _fetchAllArticle() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final article = await ApiService().topHeadlines();
      if (article.articles.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _articlesResult = article;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "Error --> $e";
    }
  }
}

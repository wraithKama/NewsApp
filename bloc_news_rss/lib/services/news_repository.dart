
import 'package:bloc_news_rss/services/news_api.dart';
import 'package:dart_rss/dart_rss.dart';

class NewsRepository {
  Future<RssFeed?> getNews({String? lang}) => NewsApi.getDataRss(lang: lang);
}

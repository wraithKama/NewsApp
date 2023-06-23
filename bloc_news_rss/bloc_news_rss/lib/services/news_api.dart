import 'package:bloc_news_rss/bloc/model/news.dart';

import 'package:dart_rss/domain/rss_feed.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  //https://uzreport.news/feed/rss/ru
  static List<News> newsModel = [];
  // static NewsLoadedState? newsLoadedState;
  static RssFeed? rssData;
  static Future<RssFeed?> getDataRss({String? lang}) async {
    final url = Uri.parse('https://uzreport.news/feed/rss/$lang');
    final response = await http.get(url);

    rssData = RssFeed.parse(response.body);

    if (response.statusCode == 200) {
      for (var e in rssData!.items) {
        newsModel.add(
          News(
              title: e.title,
              link: e.link,
              description: e.description,
              date: e.pubDate,
              imageUrl: e.enclosure?.url),
        );
      }
    } else {
      throw Exception('Error users');
    }

    return rssData;
  }

  static String? title;
  static String getRssTitle() {
    try {
      title = rssData?.title;
      return title ?? 'UzReport';
    } catch (e) {
      throw e;
    }
  }
}

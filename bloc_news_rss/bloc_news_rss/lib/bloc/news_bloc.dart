import 'package:bloc/bloc.dart';
import 'package:bloc_news_rss/services/news_repository.dart';
import 'package:dart_rss/domain/rss_feed.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  NewsBloc({required this.newsRepository}) : super(NewsInitial()) {
    on<NewsLoadEvent>((event, emit) async {
      emit(NewsLoadingState());

      try {
        final RssFeed? loadedNews = await newsRepository.getNews(lang: 'ru');

        emit(NewsLoadedState(newsFeed: loadedNews));
      } catch (_) {
        emit(NewsLoadingState());
      }
    });

    on<NewChangeLangRuEvent>((event, emit) async {
      emit(NewsLoadingState());

      try {
        final RssFeed? langloadedNews =
            await newsRepository.getNews(lang: 'ru');
        emit(NewsLoadedState(newsFeed: langloadedNews));
      } catch (e) {
        emit(NewsLoadingState());
      }
    });
    on<NewChangeLangEnEvent>((event, emit) async {
      emit(NewsLoadingState());

      try {
        final RssFeed? langloadedNews =
            await newsRepository.getNews(lang: 'en');
        emit(NewsLoadedState(newsFeed: langloadedNews));
      } catch (e) {
        emit(NewsLoadingState());
      }
    });
    on<NewChangeLangUzEvent>((event, emit) async {
      emit(NewsLoadingState());

      try {
        final RssFeed? langloadedNews =
            await newsRepository.getNews(lang: 'uz');
        emit(NewsLoadedState(newsFeed: langloadedNews));
      } catch (e) {
        emit(NewsLoadingState());
      }
    });
  }
}

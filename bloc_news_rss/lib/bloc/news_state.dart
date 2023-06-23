part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final RssFeed? newsFeed;
  NewsLoadedState({required this.newsFeed});
}

// class NewsLanguageState extends NewsState{
//   final RssFeed? newsFeed;
//   NewsLanguageState({required this.newsFeed});
// }

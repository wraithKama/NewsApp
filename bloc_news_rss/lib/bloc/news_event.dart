part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class NewsLoadEvent extends NewsEvent {
  NewsLoadEvent();
}

// class NewsThemeEvent extends NewsEvent {
//   NewsThemeEvent();
// }

class NewChangeLangRuEvent extends NewsEvent {
  NewChangeLangRuEvent();
}
class NewChangeLangEnEvent extends NewsEvent {
  NewChangeLangEnEvent();
}
class NewChangeLangUzEvent extends NewsEvent {
  NewChangeLangUzEvent();
}

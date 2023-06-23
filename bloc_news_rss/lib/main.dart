import 'package:bloc_news_rss/bloc/news_bloc.dart';
import 'package:bloc_news_rss/provider/theme_provider.dart';
import 'package:bloc_news_rss/services/news_api.dart';
import 'package:bloc_news_rss/services/news_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final newsRepository = NewsRepository();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MaterialAppWidget(newsRepository: newsRepository),
    );
  }
}

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({
    super.key,
    required this.newsRepository,
  });

  final NewsRepository newsRepository;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: !model.isDarkTheme
          ? ThemeData.dark(
              useMaterial3: true,
            )
          : ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) =>
            NewsBloc(newsRepository: newsRepository)..add(NewsLoadEvent()),
        child: const ScaffoldWidget(),
      ),
    );
  }
}

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final title = NewsApi.getRssTitle();
    final model = context.watch<ThemeProvider>();
    return Scaffold(
      drawer: Drawer(
        width: 80,
        backgroundColor: Colors.deepPurple,
        child: SafeArea(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  context.read<NewsBloc>().add(NewChangeLangRuEvent());
                  Navigator.pop(context);
                },
                child: const Text(
                  'ru',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<NewsBloc>().add(NewChangeLangEnEvent());
                  Navigator.pop(context);
                },
                child: const Text(
                  'en',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<NewsBloc>().add(NewChangeLangUzEvent());
                  Navigator.pop(context);
                },
                child: const Text(
                  'uz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          CupertinoSwitch(
            thumbColor: Colors.deepPurple,
            activeColor: Colors.deepPurpleAccent,
            value: model.isDarkTheme,
            onChanged: (bool value) {
              model.chnageTheme();
            },
          ),
        ],
        title: Text(title),
        centerTitle: true,
      ),
      body: const BlocBody(),
    );
  }
}

class BlocBody extends StatelessWidget {
  const BlocBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: const [
        AppBody(),
      ],
    );
  }
}

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadingState) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        }
        if (state is NewsLoadedState) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.newsFeed?.items.length,
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: Image.network(
                      '${state.newsFeed?.items[i].enclosure?.url}',
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      children: [
                        Text(
                          '${state.newsFeed?.items[i].title}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 244, 235, 54)),
                        ),
                        Text('${state.newsFeed?.items[i].description}'),
                      ],
                    ),
                    subtitle: TextButton(
                      onPressed: () async {
                        final Uri url =
                            Uri.parse('${state.newsFeed?.items[i].link}');

                        try {
                          await launchUrl(url);
                        } catch (e) {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        '${state.newsFeed?.items[i].link}',
                        style: TextStyle(
                          color: Colors.red[200],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Error'));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:news_app/bloc/get_source_news_bloc.dart';
import 'package:news_app/elements/error_element.dart';
import 'package:news_app/elements/loader_element.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

import 'news_detail.dart';

class SourceDetail extends StatefulWidget {
  final SourceModel source;

  SourceDetail({Key key, @required this.source}) : super(key: key);

  @override
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final SourceModel source;

  _SourceDetailState(this.source);

  @override
  void initState() {
    super.initState();
    getSourceNewsBloc..getSourceNews(source.id);
  }

  @override
  void dispose() {
    super.dispose();
    getSourceNewsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((40)),
        child: AppBar(
          title: Text(""),
          backgroundColor: Style.Colors.mainColor,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            color: Style.Colors.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                    tag: source.id,
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 20, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("assets/img/placeholder.jpg"),
                                fit: BoxFit.cover)),
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                Text(
                  source.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  source.description,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<ArticleResponse>(
            stream: getSourceNewsBloc.subject.stream,
            builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return buildErrorWidget(snapshot.data.error);
                }
                return _buildSourceNews(snapshot.data);
              } else if (snapshot.hasError) {
                return buildErrorWidget(snapshot.error);
              } else {
                return buildLoadingWidget();
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSourceNews(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;
    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("No Articles")],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsDetail(
                            article: articles[index],
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200], width: 1)),
                  color: Colors.white),
              height: 150,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      children: [
                        Text(
                          articles[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      timeAgo(
                                        DateTime.parse(articles[index].date),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/img/placeholder.jpg',
                      image: articles[index].img == null
                          ? "https://www.cowgirlcontractcleaning.com/wp-content/uploads/sites/360/2018/05/placeholder-img-4.jpg"
                          : articles[index].img,
                      fit: BoxFit.fitHeight,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 1 / 3,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}

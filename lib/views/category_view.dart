import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_portal/helper/news.dart';
import 'package:news_portal/model/article_model.dart';
import 'package:news_portal/model/blog_tile.dart';
import 'package:translator/translator.dart';

class CategoryNews extends StatefulWidget {
  final String category, country, lang;
  CategoryNews({this.category, this.country, this.lang});
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = new List<ArticleModel>();
  GoogleTranslator translator = GoogleTranslator();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.country, widget.category);
    articles = newsClass.news;
    message("Loading one moment please...");
    if (widget.lang != 'en') {
      await translate(widget.lang);
    }
    setState(() {
      _loading = false;
    });
  }

  translate(String lang) async {
    for (int i = 0; i < articles.length; i++) {
      try {
        articles[i].title =
            await translator.translate(articles[i].title, to: lang);
        articles[i].description =
            await translator.translate(articles[i].description, to: lang);
      } catch (e) {
        message("Error while changing lanuage");
      }
    }
  }

  message(String msg) {
    Fluttertoast.showToast(
      msg: msg, toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              " Portal",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: Container(
              child: CircularProgressIndicator(),
            ))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    //Blogs
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                            imgUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            datetime: articles[index].publishedAt,
                            url: articles[index].url,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

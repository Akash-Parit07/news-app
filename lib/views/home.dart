import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/ad_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import '../model/blog_tile.dart';
import '../model/country.dart';
import '../views/category_view.dart';
import 'package:translator/translator.dart';
import '../helper/news.dart';
import '../model/article_model.dart';
import '../helper/data.dart';
import '../model/category_model.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        builder: Builder(builder: (context) => HomeBody()),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeBody> {
  GlobalKey _countryKey = GlobalKey();
  GlobalKey _categoryKey = GlobalKey();
  GlobalKey _articleKey = GlobalKey();
  GlobalKey _languageKey = GlobalKey();

  DateTime currentBackPressTime;
  GoogleTranslator translator = GoogleTranslator();
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  List<CategoryModel> trans = new List<CategoryModel>(); // E.g
  //FlutterTts tts = FlutterTts();

  bool _loading = true;
  String countName = "in";
  String language = 'en';

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  Ad _ad = Ad();

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-1244654157371716~7215250318");
    _bannerAd = _ad.createBannerAd()
      ..load()
      ..show();
    categories = getCategories();
    getNews();
  }

  //^0.5.2

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews(countName);
    articles = newsClass.news;
    //translate();
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

  void _changeCountry(Country country) {
    setState(() {
      countName = country.countryCode;
      _loading = true;
      getNews();
    });
  }

  Future<void> handleClick(String value) async {
    if (language == 'en' && value == 'English') {
      return;
    }
    if (language == 'hi' && value == 'Hindi') {
      return;
    }
    if (language == 'mr' && value == 'Marathi') {
      return;
    }

    if (value == 'English') {
      setState(() {
        _loading = true;
        language = 'en';
        message("Loading one moment please...");
      });
      await translate("en");
      setState(() {
        _loading = false;
      });
    }

    if (value == 'Marathi') {
      setState(() {
        _loading = true;
        language = 'mr';
        message("Loading one moment please...");
      });
      await translate("mr");
      setState(() {
        _loading = false;
      });
    }

    if (value == 'Hindi') {
      setState(() {
        _loading = true;
        language = 'hi';
        message("Loading one moment please...");
      });
      await translate("hi");
      setState(() {
        _loading = false;
      });
    }
  }

  displayShowCase() async {
    SharedPreferences preferences;
    preferences = await SharedPreferences.getInstance();
    bool showCaseVisibilityStatus = preferences.getBool("displayShowcase");
    if (showCaseVisibilityStatus == null) {
      preferences.setBool("displayShowcase", false);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    displayShowCase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase(
            [_countryKey, _languageKey, _categoryKey, _articleKey]);
      }
    });

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "News",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                  //fontSize: 20
                ),
              ),
              Text(
                " Portal",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  //fontSize: 20
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              //padding: EdgeInsets.symmetric(horizontal: 16),
              //margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(2.0),
              //width: MediaQuery.of(context).size.width * 0.30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  onChanged: (Country country) {
                    _changeCountry(country);
                  },
                  icon: Showcase(
                    key: _countryKey,
                    description: "To see the news of particular country",
                    descTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    showcaseBackgroundColor: Colors.blue,
                    shapeBorder: CircleBorder(),
                    //showArrow: true,
                    overlayColor: Colors.black45,
                    child: Icon(
                      Icons.language,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  items: Country.countryList()
                      .map<DropdownMenuItem<Country>>((country) =>
                          DropdownMenuItem(
                            value: country,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(country.flag),
                                Text(
                                  country.countryName,
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Showcase(
              key: _languageKey,
              description: "Change language here",
              showArrow: true,
              descTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              showcaseBackgroundColor: Colors.blue,
              shapeBorder: RoundedRectangleBorder(),
              overlayColor: Colors.black45,
              child: PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'English', 'Marathi', 'Hindi'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ],
          elevation: 0.0,
        ),
        body: _loading
            ? Center(
                child: Container(
                child: CircularProgressIndicator(),
              ))
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    //Categories
                    Showcase(
                      key: _categoryKey,
                      description: "Slide to see more categories",
                      showArrow: true,
                      descTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      showcaseBackgroundColor: Colors.blue,
                      shapeBorder: RoundedRectangleBorder(),
                      overlayColor: Colors.black45,
                      child: Container(
                        padding: EdgeInsets.only(top: 6),
                        height: 93,
                        child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              imgUrl: categories[index].imgUrl,
                              categoryName: categories[index].categoryName,
                              countryName: countName,
                              lang: language,
                            );
                          },
                        ),
                      ),
                    ),

                    //Blogs
                    Showcase(
                      key: _articleKey,
                      description: "Click on article to see it in detail",
                      descTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      showcaseBackgroundColor: Colors.blue,
                      shapeBorder: RoundedRectangleBorder(),
                      showArrow: true,
                      overlayColor: Colors.black45,
                      child: Container(
                        padding: EdgeInsets.only(top: 14),
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
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      message('Press again to exit app');
      return Future.value(false);
    }

    return Future.value(true);
  }
}

class CategoryTile extends StatelessWidget {
  final imgUrl, categoryName, countryName, lang;
  CategoryTile({this.imgUrl, this.categoryName, this.countryName, this.lang});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      category: categoryName.toLowerCase(),
                      country: countryName.toLowerCase(),
                      lang: lang,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.0),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                width: 135,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 135,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/model/ad_model.dart';
import 'package:news_portal/views/article_view.dart';

class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc, url, datetime;
  BlogTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.desc,
      @required this.datetime,
      @required this.url});

  Ad ad = Ad();
  InterstitialAd _interstitialAd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseAdMob.instance
            .initialize(appId: "ca-app-pub-1244654157371716~7215250318");
        _interstitialAd = ad.createInterstitialAd()
          ..load()
          ..show();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imgUrl),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 6),
            Text(
              datetime,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

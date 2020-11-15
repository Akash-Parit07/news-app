class ArticleModel {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  String publishedAt;

  ArticleModel(
      {this.author,
      this.title,
      this.url,
      this.description,
      this.content,
      this.urlToImage,
      this.publishedAt});
}

class ArticleModels{
  String link;
  String title;
  String content;
  String image;

  ArticleModels.fromJson(Map<String, dynamic> json){
    link = json['link'];
    title = json['title'];
    content = json['content'];
    image = json['jetpack_featured_media_url'];
  }
}
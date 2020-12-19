class SourceModel {
  final String author;
  final String title;
  final String name;
  final String description;
  final String url;
  final String img;
  final String date;
  final String content;

  SourceModel(
    this.author,
    this.title,
    this.name,
    this.description,
    this.url,
    this.img,
    this.date,
    this.content,
  );

  SourceModel.fromJson(Map<String, dynamic> json)
      : author = json["author"],
        title = json["title"],
        name = json["name"],
        description = json["description"],
        url = json["url"],
        img = json["urlToImage"],
        date = json["publishedAt"],
        content = json["content"];
}

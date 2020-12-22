class SourceModel {
  final String id;
  final String author;
  final String title;
  final String name;
  final String category;
  final String url;
  final String img;
  final String date;
  final String description;

  SourceModel(
    this.id,
    this.author,
    this.title,
    this.name,
    this.category,
    this.url,
    this.img,
    this.date,
    this.description,
  );

  SourceModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        author = json["author"],
        title = json["title"],
        name = json["name"],
        category = json["category"],
        url = json["url"],
        img = json["urlToImage"],
        date = json["publishedAt"],
        description = json["description"];
}

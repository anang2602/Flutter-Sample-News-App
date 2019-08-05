

class News {
  final String status;
  final int totalResult;
  final List<Articles> articles;

  News({this.status, this.totalResult, this.articles});

  factory News.fromJson(Map<String, dynamic> json) {
    var articles = json['articles'] as List;
    List<Articles> listArticles = articles.map((i) => Articles.fromJson(i)).toList();
    return News(
      status: json['status'],
      totalResult: json['totalResults'],
      articles: listArticles
    );
  }
}

class Articles {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  Articles({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['title'],
      url: json['url'],
      urlToImage: json['urlToImage']
    );
  }

}

class Source {
  final name;

  Source({this.name});
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(name: json['name']);
  }
}
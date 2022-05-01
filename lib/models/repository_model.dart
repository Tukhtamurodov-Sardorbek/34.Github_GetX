class Repository {
  String repoName;
  String repoURL;
  String color;
  String language;

  Repository({
    required this.repoName,
    required this.repoURL,
    required this.color,
    required this.language,
  });

  Repository.fromJson(Map<String, dynamic> json)
      : repoName = json['name'],
        repoURL = json['html_url'],
        color = json['color'],
        language = json['language'];

  Map<String, dynamic> toJson() => {
    'name': repoName,
    'html_url': repoURL,
    'color': color,
    'language': language
  };
}

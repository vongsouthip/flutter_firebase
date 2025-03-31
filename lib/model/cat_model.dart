class Cat {
  final String url;

  Cat({required this.url});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(url: json['url']);
  }
}

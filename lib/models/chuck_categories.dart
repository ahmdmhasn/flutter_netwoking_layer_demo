class ChuckCategories {
  final List<String> categories;

  ChuckCategories({required this.categories});

  factory ChuckCategories.fromJson(List<dynamic> json) {
    return ChuckCategories(
      categories: List<String>.from(json),
    );
  }
}

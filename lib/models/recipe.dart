class Recipe {
  final int id;
  final String name;
  final String image;
  final String cuisine;
  final String difficulty;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final int caloriesPerServing;
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.caloriesPerServing,
    required this.rating,
    required this.ingredients,
    required this.instructions,
    required this.mealType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic v) =>
        (v as List? ?? []).map((e) => e.toString()).toList();

    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? '-',
      image: json['image'] ?? '',
      cuisine: json['cuisine'] ?? '-',
      difficulty: json['difficulty'] ?? '-',
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      servings: json['servings'] ?? 1,
      caloriesPerServing: json['caloriesPerServing'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      ingredients: toList(json['ingredients']),
      instructions: toList(json['instructions']),
      mealType: toList(json['mealType']),
    );
  }
}

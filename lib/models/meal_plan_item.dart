import 'package:hive/hive.dart';

/// Item Meal Plan yang disimpan di Hive.
/// Disimpan: resep (id, nama, gambar, kalori), user, dan jumlah porsi.
class MealPlanItem {
  final String username;
  final int recipeId;
  final String name;
  final String image;
  final int caloriesPerServing;
  final int servings;

  MealPlanItem({
    required this.username,
    required this.recipeId,
    required this.name,
    required this.image,
    required this.caloriesPerServing,
    required this.servings,
  });

  /// Key unik per user + resep, sehingga resep yang sama tidak duplikat.
  String get key => '${username}_$recipeId';

  int get totalCalories => caloriesPerServing * servings;
}

/// TypeAdapter manual (tanpa build_runner).
class MealPlanItemAdapter extends TypeAdapter<MealPlanItem> {
  @override
  final int typeId = 0;

  @override
  MealPlanItem read(BinaryReader reader) {
    return MealPlanItem(
      username: reader.readString(),
      recipeId: reader.readInt(),
      name: reader.readString(),
      image: reader.readString(),
      caloriesPerServing: reader.readInt(),
      servings: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanItem obj) {
    writer
      ..writeString(obj.username)
      ..writeInt(obj.recipeId)
      ..writeString(obj.name)
      ..writeString(obj.image)
      ..writeInt(obj.caloriesPerServing)
      ..writeInt(obj.servings);
  }
}

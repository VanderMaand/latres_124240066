import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_plan_item.dart';

class HiveService {
  static const _boxName = 'meal_plan';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MealPlanItemAdapter());
    await Hive.openBox<MealPlanItem>(_boxName);
  }

  static Box<MealPlanItem> get box => Hive.box<MealPlanItem>(_boxName);

  /// Tambah / perbarui item (key sama => porsi diperbarui, bukan duplikat).
  static Future<void> add(MealPlanItem item) => box.put(item.key, item);

  static Future<void> remove(MealPlanItem item) => box.delete(item.key);

  /// Hanya item milik [username].
  static List<MealPlanItem> itemsOf(String username) =>
      box.values.where((e) => e.username == username).toList();
}

import 'package:flutter/material.dart';
import '../models/meal_plan_item.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';

class DetailPage extends StatefulWidget {
  final Recipe recipe;
  final String username;
  const DetailPage({super.key, required this.recipe, required this.username});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static const int _minServing = 1;
  static const int _maxServing = 10;
  int _servings = 1;

  Future<void> _addToMealPlan() async {
    final r = widget.recipe;
    await HiveService.add(MealPlanItem(
      username: widget.username,
      recipeId: r.id,
      name: r.name,
      image: r.image,
      caloriesPerServing: r.caloriesPerServing,
      servings: _servings,
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.name} ($_servings porsi) masuk Meal Plan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resep')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(r.image,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.restaurant, size: 100)),
              ),
            ),
            const SizedBox(height: 16),
            Text(r.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${r.cuisine} • ${r.difficulty} • ${r.mealType.join(", ")}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                _info(Icons.star, r.rating.toStringAsFixed(1)),
                _info(Icons.timer, 'Persiapan ${r.prepTimeMinutes} mnt'),
                _info(Icons.local_fire_department,
                    'Masak ${r.cookTimeMinutes} mnt'),
                _info(Icons.bolt, '${r.caloriesPerServing} kkal/porsi'),
              ],
            ),
            const Divider(height: 32),
            const Text('Bahan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...r.ingredients.map((e) => Text('• $e')),
            const SizedBox(height: 16),
            const Text('Langkah Memasak',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...r.instructions.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${e.key + 1}. ${e.value}'),
                  ),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              IconButton(
                onPressed: _servings > _minServing
                    ? () => setState(() => _servings--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_servings porsi',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: _servings < _maxServing
                    ? () => setState(() => _servings++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _addToMealPlan,
                icon: const Icon(Icons.playlist_add),
                label: const Text('Tambah ke Meal Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(text),
        ],
      );
}

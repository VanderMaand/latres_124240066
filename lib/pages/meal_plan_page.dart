import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_plan_item.dart';
import '../services/hive_service.dart';

class MealPlanPage extends StatelessWidget {
  final String username;
  const MealPlanPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Plan')),
      // Otomatis rebuild saat isi box Hive berubah.
      body: ValueListenableBuilder<Box<MealPlanItem>>(
        valueListenable: HiveService.box.listenable(),
        builder: (context, _, __) {
          final items = HiveService.itemsOf(username);
          final total = items.fold<int>(0, (s, e) => s + e.totalCalories);

          if (items.isEmpty) {
            return const Center(child: Text('Meal Plan masih kosong'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.image,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.restaurant)),
                        ),
                        title: Text(item.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                            '${item.servings} porsi • ${item.totalCalories} kkal'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => HiveService.remove(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Kalori',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('$total kkal',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

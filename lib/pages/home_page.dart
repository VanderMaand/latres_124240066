import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/recipe_card.dart';
import 'detail_page.dart';
import 'meal_plan_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  final _searchC = TextEditingController();
  late Future<List<Recipe>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchRecipes();
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  void _search(String q) {
    setState(() => _future = _api.fetchRecipes(query: q));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.username}'),
        actions: [
          IconButton(
            tooltip: 'Meal Plan',
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MealPlanPage(username: widget.username)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchC,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Cari resep...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchC.clear();
                    _search('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Terjadi kesalahan:\n${snap.error}',
                            textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () => _search(_searchC.text),
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  );
                }
                final recipes = snap.data ?? [];
                if (recipes.isEmpty) {
                  return const Center(child: Text('Resep tidak ditemukan'));
                }
                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (_, i) => RecipeCard(
                    recipe: recipes[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                            recipe: recipes[i], username: widget.username),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

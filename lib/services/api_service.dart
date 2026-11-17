import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/recipe.dart';

class ApiService {
  Future<List<Recipe>> fetchRecipes({String query = ''}) async {
    final url = query.trim().isEmpty
        ? Uri.parse('$kApiBase/recipes?limit=30')
        : Uri.parse('$kApiBase/recipes/search?q=${Uri.encodeQueryComponent(query)}');

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat resep (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['recipes'] as List)
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

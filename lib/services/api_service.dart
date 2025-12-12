import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class ApiService {
  // URL API Publik TheMealDB (Search endpoint)
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/search.php?s=';

  Future<List<Recipe>> fetchRecipes(String query) async {
    // Jika query kosong, cari default (misal 'chicken') agar tidak error
    final String searchUrl = query.isEmpty ? '${baseUrl}chicken' : '$baseUrl$query';

    try {
      final response = await http.get(Uri.parse(searchUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Cek apakah data['meals'] ada isinya
        if (data['meals'] != null) {
          List<dynamic> jsonList = data['meals'];
          // Konversi List JSON ke List Recipe
          return jsonList.map((json) => Recipe.fromJson(json)).toList();
        } else {
          return []; // Data tidak ditemukan
        }
      } else {
        throw Exception('Gagal mengambil data dari server');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
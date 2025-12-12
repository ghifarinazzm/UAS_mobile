import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/api_service.dart';

class RecipeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // List gabungan (API + Lokal)
  List<Recipe> _recipes = [];
  
  // Status Loading untuk UI (Loading State) [cite: 20]
  bool _isLoading = false;
  String _errorMessage = '';

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch Data dari API
  Future<void> getRecipesFromApi(String query) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI untuk muter loading

    try {
      // Ambil data dari API
      final apiRecipes = await _apiService.fetchRecipes(query);
      
      // Ambil data lokal yang sudah ada (filter yang isLocal == true)
      final localRecipes = _recipes.where((r) => r.isLocal).toList();
      
      // Gabungkan: Data Lokal di atas, Data API di bawah
      _recipes = [...localRecipes, ...apiRecipes];
      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI loading selesai
    }
  }

  // --- CRUD LOKAL (Fitur User/Admin) ---

  // 1. Add Recipe
  void addRecipe(Recipe newRecipe) {
    _recipes.insert(0, newRecipe); // Masukkan ke paling atas
    notifyListeners();
  }

  // 2. Edit Recipe
  void editRecipe(String id, Recipe updatedRecipe) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index >= 0) {
      _recipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  // 3. Delete Recipe
  void deleteRecipe(String id) {
    _recipes.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
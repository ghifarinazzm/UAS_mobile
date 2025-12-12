class Recipe {
  final String id;
  final String name;
  final String category; // API TheMealDB punya kategori
  final String area;     // Asal negara masakan
  final String instructions;
  final String photoUrl;
  final bool isLocal; // Penanda: Apakah ini dari API atau buatan User?

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.photoUrl,
    this.isLocal = false, // Default false (berarti dari API)
  });

  // Factory method untuk mengubah JSON dari API menjadi Object Dart
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] ?? DateTime.now().toString(), // idMeal dari API
      name: json['strMeal'] ?? 'No Name',
      category: json['strCategory'] ?? 'Unknown',
      area: json['strArea'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? 'No instructions',
      photoUrl: json['strMealThumb'] ?? 'https://via.placeholder.com/150',
      isLocal: false,
    );
  }
}
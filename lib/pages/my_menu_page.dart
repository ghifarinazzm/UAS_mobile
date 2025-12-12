import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/auth_provider.dart';
import 'recipe_form_page.dart';
import 'detail_page.dart';

class MyMenuPage extends StatelessWidget {
  const MyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          // Filter: Hanya tampilkan resep Lokal (Buatan User)
          final myRecipes = provider.recipes.where((r) => r.isLocal).toList();

          if (myRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("Belum ada menu buatanmu."),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipeFormPage()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Menu Baru"),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: myRecipes.length,
            itemBuilder: (context, index) {
              final recipe = myRecipes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.orange.shade50, // Pembeda warna untuk resep lokal
                child: ListTile(
                  title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Menu Buatan Sendiri"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeFormPage(recipe: recipe)));
                        },
                      ),
                      // Tombol Hapus hanya untuk Admin (sesuai request awal) atau User pemilik resep
                      // Disini saya buka untuk semua agar fitur CRUD Tambah Menu terasa
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (auth.userRole == 'admin' || recipe.isLocal) {
                             provider.deleteRecipe(recipe.id);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(recipe: recipe)));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipeFormPage()));
        },
      ),
    );
  }
}
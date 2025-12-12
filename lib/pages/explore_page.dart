import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import 'detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // PERBAIKAN: Menggunakan addPostFrameCallback agar dijalankan SETELAH halaman selesai dibangun.
    // Ini solusi ampuh untuk menghilangkan error merah "setState during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      
      // Hanya ambil data jika list masih kosong (supaya tidak loading ulang saat pindah tab)
      if (provider.recipes.isEmpty) {
        provider.getRecipesFromApi('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // --- Bagian Kolom Pencarian ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Cari Resep (API Public)",
                hintText: "Contoh: Chicken, Pie, Beef...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Trigger pencarian ke API saat tombol panah ditekan
                    Provider.of<RecipeProvider>(context, listen: false)
                        .getRecipesFromApi(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: (value) {
                // Trigger pencarian saat tombol Enter/Done di keyboard ditekan
                Provider.of<RecipeProvider>(context, listen: false)
                    .getRecipesFromApi(value);
              },
            ),
          ),

          // --- Bagian List Resep (Consumer Provider) ---
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, provider, child) {
                // 1. Loading State (Sedang memuat)
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State (Ada masalah koneksi/API)
                if (provider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(provider.errorMessage, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                }

                // 3. Empty State (Data Kosong)
                if (provider.recipes.isEmpty) {
                  return const Center(child: Text("Belum ada data resep."));
                }

                // 4. Success State (Tampilkan Data)
                return ListView.builder(
                  itemCount: provider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = provider.recipes[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        // Gambar Kecil (Thumbnail)
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recipe.photoUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => 
                              Container(width: 60, height: 60, color: Colors.grey, child: const Icon(Icons.broken_image)),
                          ),
                        ),
                        // Judul & Info Singkat
                        title: Text(
                          recipe.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${recipe.category} • ${recipe.area}"),
                        trailing: const Icon(Icons.chevron_right),
                        
                        // Aksi saat diklik: Buka Detail
                        onTap: () {
                           Navigator.push(
                             context, 
                             MaterialPageRoute(builder: (_) => DetailPage(recipe: recipe))
                           );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
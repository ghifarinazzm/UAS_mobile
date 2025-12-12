import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';

class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe; // Jika null = Mode Tambah, Jika ada isi = Mode Edit

  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk input text
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _areaController;
  late TextEditingController _instructionsController;
  late TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    // Isi data awal jika sedang mode Edit
    _nameController = TextEditingController(text: widget.recipe?.name ?? '');
    _categoryController = TextEditingController(text: widget.recipe?.category ?? '');
    _areaController = TextEditingController(text: widget.recipe?.area ?? '');
    _instructionsController = TextEditingController(text: widget.recipe?.instructions ?? '');
    // Default gambar placeholder jika kosong
    _photoUrlController = TextEditingController(text: widget.recipe?.photoUrl ?? 'https://via.placeholder.com/150');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _areaController.dispose();
    _instructionsController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<RecipeProvider>(context, listen: false);

      if (widget.recipe == null) {
        // --- LOGIKA TAMBAH BARU (CREATE) ---
        final newRecipe = Recipe(
          id: DateTime.now().toString(), // Generate ID unik pakai waktu sekarang
          name: _nameController.text,
          category: _categoryController.text,
          area: _areaController.text,
          instructions: _instructionsController.text,
          photoUrl: _photoUrlController.text,
          isLocal: true, // PENTING: Tandai ini data lokal agar bisa diedit/hapus nanti
        );
        provider.addRecipe(newRecipe);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resep berhasil ditambahkan!')));
      } else {
        // --- LOGIKA EDIT (UPDATE) ---
        final updatedRecipe = Recipe(
          id: widget.recipe!.id, // Pakai ID lama
          name: _nameController.text,
          category: _categoryController.text,
          area: _areaController.text,
          instructions: _instructionsController.text,
          photoUrl: _photoUrlController.text,
          isLocal: true,
        );
        provider.editRecipe(widget.recipe!.id, updatedRecipe);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resep berhasil diperbarui!')));
      }

      Navigator.pop(context); // Kembali ke Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipe != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Resep" : "Tambah Resep Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Masakan', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori (cth: Seafood)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Kategori wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Asal Daerah (cth: Indonesia)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Asal daerah wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(labelText: 'URL Foto (Boleh link Google)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Cara Membuat / Instruksi', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Instruksi wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: Text(isEditing ? "SIMPAN PERUBAHAN" : "TAMBAH RESEP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
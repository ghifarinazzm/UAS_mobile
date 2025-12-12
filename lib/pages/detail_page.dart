import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class DetailPage extends StatelessWidget {
  final Recipe recipe;

  const DetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.photoUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => const SizedBox(height: 250, child: Icon(Icons.error)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(label: Text(recipe.category), backgroundColor: Colors.orange[100]),
                      const SizedBox(width: 8),
                      Chip(label: Text(recipe.area), backgroundColor: Colors.blue[100]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Instruksi / Cara Membuat:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    recipe.instructions,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
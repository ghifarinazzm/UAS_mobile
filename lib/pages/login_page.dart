import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'main_page.dart';     // PENTING: Import MainPage agar bisa navigasi ke sana
import 'register_page.dart'; // Pastikan file ini ada (sesuai yang kita buat sebelumnya)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil teks dari inputan
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk menangani tombol Login ditekan
  void _handleLogin() {
    // Ambil instance AuthProvider
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Panggil fungsi login dari Provider (Simulasi Cek Password)
    bool success = auth.login(username, password);

    if (success) {
      // JIKA SUKSES: Pindah ke MainPage (Halaman Utama dengan Tab Navigasi)
      // pushReplacement agar user tidak bisa kembali ke halaman login dengan tombol Back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      // JIKA GAGAL: Tampilkan pesan error di bawah layar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Gagal! Cek Username/Password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Bersihkan controller saat halaman ditutup agar hemat memori
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange.shade50, // Opsional: Beri warna background tipis
      body: Center(
        child: SingleChildScrollView( // Agar tidak error overflow saat keyboard muncul
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo Aplikasi
              const Icon(Icons.soup_kitchen, size: 80, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                "Resep APP",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 8),
              const Text("Masak jadi lebih mudah", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              // 2. Form Input
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true, // Sembunyikan password
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Tombol Login
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 16),
              
              // 4. Link ke Register
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                },
                child: const Text("Belum punya akun? Daftar disini"),
              ),

              const SizedBox(height: 30),
              
              // 5. Hint / Contekan untuk Login (Bisa dihapus nanti)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Info Login (Simulasi):\nAdmin: admin / admin\nUser: user / user",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
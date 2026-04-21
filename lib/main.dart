import 'package:catalog/core/routes/app_routes.dart';
import 'package:catalog/core/themes/app_theme.dart';
import 'package:catalog/features/auth/presentation/providers/auth_provider.dart';
import 'package:catalog/features/dashboard/presentation/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'core/services/secure_storage.dart';

void main() async {
  // 1. Pastikan binding Flutter sudah siap [cite: 173, 1451]
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase sebelum aplikasi dijalankan [cite: 174-177, 1452]
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // 3. Daftarkan semua Provider di level paling atas [cite: 179-185, 1454-1461, 1694-1698]
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasar Malam App', // [cite: 1700]
      debugShowCheckedModeBanner: false, // [cite: 1701]
      // 4. Gunakan tema yang sudah dibuat di core [cite: 1702]
      theme: AppTheme.light,

      // Tampilkan splash sebagai halaman awal untuk pengecekan token.
      home: const SplashPage(),

      // 6. Daftarkan semua rute dari AppRouter [cite: 1704]
      routes: AppRouter.routes,
    );
  }
}

// 7. SplashPage: Halaman awal untuk mengecek token tersimpan [cite: 1709-1731]
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Beri sedikit jeda untuk animasi splash [cite: 1721]
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Cek apakah ada token di penyimpanan aman [cite: 1723]
    final token = await SecureStorageService.getToken();

    // Jika token ada, langsung ke Dashboard. Jika tidak, ke Login [cite: 1724]
    final route = token != null ? AppRouter.dashboard : AppRouter.login;

    if (mounted) {
      Navigator.pushReplacementNamed(context, route); // [cite: 1725]
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // [cite: 1729]
      ),
    );
  }
}

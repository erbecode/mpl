import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/mahasiswa.dart';
import 'screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MahasiswaAdapter());
  await Hive.openBox<Mahasiswa>('mahasiswaBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahasiswa Hive App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const WelcomePage(),
    );
  }
}

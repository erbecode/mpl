import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/mahasiswa.dart';
import 'tampil_data_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final nimController = TextEditingController();
  final namaController = TextEditingController();
  final ttlController = TextEditingController();
  final fakultasController = TextEditingController();
  final jurusanController = TextEditingController();

  final Box<Mahasiswa> mahasiswaBox = Hive.box<Mahasiswa>('mahasiswaBox');

  void simpanData() {
    if (nimController.text.isEmpty ||
        namaController.text.isEmpty ||
        ttlController.text.isEmpty ||
        fakultasController.text.isEmpty ||
        jurusanController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
      return;
    }

    final data = Mahasiswa(
      nim: nimController.text,
      nama: namaController.text,
      ttl: ttlController.text,
      fakultas: fakultasController.text,
      jurusan: jurusanController.text,
    );

    mahasiswaBox.add(data);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));

    nimController.clear();
    namaController.clear();
    ttlController.clear();
    fakultasController.clear();
    jurusanController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nimController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: ttlController,
              decoration: const InputDecoration(
                labelText: 'Tempat, Tanggal Lahir',
              ),
            ),
            TextField(
              controller: fakultasController,
              decoration: const InputDecoration(labelText: 'Fakultas'),
            ),
            TextField(
              controller: jurusanController,
              decoration: const InputDecoration(labelText: 'Jurusan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: simpanData, child: const Text('Simpan')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TampilDataPage()),
                );
              },
              child: const Text('Tampil Data'),
            ),
          ],
        ),
      ),
    );
  }
}

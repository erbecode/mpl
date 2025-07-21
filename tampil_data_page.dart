import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/mahasiswa.dart';

class TampilDataPage extends StatefulWidget {
  const TampilDataPage({super.key});

  @override
  State<TampilDataPage> createState() => _TampilDataPageState();
}

class _TampilDataPageState extends State<TampilDataPage> {
  final Box<Mahasiswa> mahasiswaBox = Hive.box<Mahasiswa>('mahasiswaBox');
  String? selectedJurusan;

  List<String> getListJurusan() {
    final allData = mahasiswaBox.values.toList();
    return allData.map((m) => m.jurusan).toSet().toList(); // unik
  }

  void showEditDialog(Mahasiswa data, int index) {
    final nimController = TextEditingController(text: data.nim);
    final namaController = TextEditingController(text: data.nama);
    final ttlController = TextEditingController(text: data.ttl);
    final fakultasController = TextEditingController(text: data.fakultas);
    final jurusanController = TextEditingController(text: data.jurusan);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Data'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nimController,
                    decoration: const InputDecoration(labelText: 'NIM'),
                  ),
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: ttlController,
                    decoration: const InputDecoration(labelText: 'TTL'),
                  ),
                  TextField(
                    controller: fakultasController,
                    decoration: const InputDecoration(labelText: 'Fakultas'),
                  ),
                  TextField(
                    controller: jurusanController,
                    decoration: const InputDecoration(labelText: 'Jurusan'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  data.nim = nimController.text;
                  data.nama = namaController.text;
                  data.ttl = ttlController.text;
                  data.fakultas = fakultasController.text;
                  data.jurusan = jurusanController.text;
                  data.save();
                  Navigator.pop(context);
                  setState(() {}); // Refresh
                },
                child: const Text('Simpan'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
    );
  }

  void hapusData(int index) {
    mahasiswaBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allData = mahasiswaBox.values.toList();
    final filteredData =
        selectedJurusan == null
            ? allData
            : allData.where((m) => m.jurusan == selectedJurusan).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Data Mahasiswa')),
      body: Column(
        children: [
          // Dropdown Filter Jurusan
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              hint: const Text('Filter berdasarkan Jurusan'),
              value: selectedJurusan,
              isExpanded: true,
              items:
                  getListJurusan().map((jurusan) {
                      return DropdownMenuItem(
                        value: jurusan,
                        child: Text(jurusan),
                      );
                    }).toList()
                    ..insert(
                      0,
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Semua Jurusan'),
                      ),
                    ),
              onChanged: (value) {
                setState(() {
                  selectedJurusan = value;
                });
              },
            ),
          ),

          Expanded(
            child:
                filteredData.isEmpty
                    ? const Center(child: Text('Tidak ada data'))
                    : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final data = filteredData[index];
                        final originalIndex = allData.indexOf(
                          data,
                        ); // index asli untuk Hive

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            title: Text(
                              data.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NIM     : ${data.nim}'),
                                Text('TTL     : ${data.ttl}'),
                                Text('Fakultas: ${data.fakultas}'),
                                Text('Jurusan : ${data.jurusan}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed:
                                      () => showEditDialog(data, originalIndex),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => hapusData(originalIndex),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

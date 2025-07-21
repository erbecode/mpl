import 'package:hive/hive.dart';

part 'mahasiswa.g.dart';

@HiveType(typeId: 0)
class Mahasiswa extends HiveObject {
  @HiveField(0)
  String nim;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String ttl;

  @HiveField(3)
  String fakultas;

  @HiveField(4)
  String jurusan;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.ttl,
    required this.fakultas,
    required this.jurusan,
  });
}

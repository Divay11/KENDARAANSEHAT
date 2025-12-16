import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  final List<Map<String, String>> tipsData = const [
    {
      "title": "Ganti Oli Mesin",
      "desc": "Ganti oli Motor setiap 1.000 - 2.000 KM Dan Ganti oli Mobil setiap 5.000 - 10.000 KM. Oli yang kotor dapat merusak mesin dan mengurangi performa kendaraan anda."
    },
    {
      "title": "Cek Tekanan Ban",
      "desc": "Periksa tekanan angin ban setidaknya seminggu sekali. Ban yang kurang angin sangat berbahaya saat menikung di tikungan."
    },
    {
      "title": "Periksa Rem",
      "desc": "Cek ketebalan kampas rem. Jika terdengar bunyi berdecit saat mengerem, segera ganti kampas rem Anda demi keselamatan."
    },
    {
      "title": "Cek Air Radiator",
      "desc": "Pastikan cairan pendingin (coolant) selalu berada di batas aman. Jangan isi air radiator saat mesin masih panas!"
    },
    {
      "title": "Servis Rutin / Tune Up",
      "desc": "Lakukan servis rutin di bengkel resmi setiap 2-3 bulan sekali untuk membersihkan karburator/injeksi dan mengecek kondisi umum."
    },
    {
      "title": "Cek Lampu & Kelistrikan",
      "desc": "Pastikan lampu depan, lampu rem, dan lampu sein berfungsi. Ini sangat penting untuk berkendara di malam hari."
    },
    {
      "title": "Rantai & Gear (Motor)",
      "desc": "Berikan pelumas rantai secara berkala. Jika rantai sudah kendur, segera kencangkan atau ganti jika gear sudah tajam."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tips Perawatan"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tipsData.length,
        itemBuilder: (context, index) {
          final item = tipsData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E7), // Pink muda
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.build_circle, color: Color(0xFFFF4B5C)),
              ),
              title: Text(
                item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    item['desc']!,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
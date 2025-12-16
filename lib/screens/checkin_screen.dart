import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_button.dart';
import '../services/schedule_service.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final _kmCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_kmCtrl.text.isEmpty) return;
    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User belum login");

      await FirebaseFirestore.instance.collection('checkins').add({
        'user_id': user.uid,
        'kilometer': int.parse(_kmCtrl.text),
        'created_at': Timestamp.now(),
      });

      final currentKm = int.tryParse(_kmCtrl.text) ?? 0;
      if (currentKm > 0) {
        await ScheduleService.addKmReminder(currentKm: currentKm);
      }

      if (!mounted) return;

      setState(() => _loading = false);

      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 50),
              const SizedBox(height: 10),
              const Text("Check-in Berhasil!"),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      );

      _kmCtrl.clear();
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In KM"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Masukkan Kilometer Saat Ini",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _kmCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Contoh: 5000"),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : CustomButton(text: "Kirim Data", onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

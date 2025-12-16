import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Future<List<QueryDocumentSnapshot>> _getSchedules() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('user_id', isEqualTo: uid)
        .orderBy('due_km')
        .get();

    return snapshot.docs;
  }

  Future<void> _deleteSchedule(String id) async {
    await FirebaseFirestore.instance.collection('schedules').doc(id).delete();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal & Pengingat")),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getSchedules(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // error
          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi error: ${snapshot.error}"),
            );
          }

          // kosong
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text("Belum ada jadwal"));
          }

          // tampil data
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final item = data[i];

              return ListTile(
                title: Text(item['activity']),
                subtitle: Text(
                  "Jatuh tempo di ${item['due_km']} KM",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSchedule(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

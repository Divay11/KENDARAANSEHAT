import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleService {
  /// Tambah reminder berbasis KM. default interval = 2000 km (ganti oli).
  static Future<void> addKmReminder({
    required int currentKm,
    int intervalKm = 2000,
    String activity = 'Ganti oli',
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final dueKm = currentKm + intervalKm;

    await FirebaseFirestore.instance.collection('schedules').add({
      'user_id': uid,
      'activity': activity,
      'created_km': currentKm,
      'due_km': dueKm,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}

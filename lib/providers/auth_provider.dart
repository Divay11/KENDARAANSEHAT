import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= LOGIN =================
  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message ?? "Login gagal");
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================= REGISTER =================
  Future<bool> register(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    _setLoading(true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // simpan ke firestore
      await _firestore.collection('profiles').doc(uid).set({
        'username': username,
        'vehicle_name': '',
        'plate_number': '',
        'created_at': FieldValue.serverTimestamp(),
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message ?? "Register gagal");
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================= LOGOUT =================
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  // ================= HELPER =================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showError(BuildContext context, String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

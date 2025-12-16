import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Hide Firebase's AuthProvider to avoid name collision with our AuthProvider class
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Ambil username dari Firestore
  Future<String> _getUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User";

      final doc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .get();

      return doc.data()?['username'] ?? "User";
    } catch (_) {
      return "User";
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitur Utama"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: "Keluar",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Yakin ingin keluar aplikasi?"),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () async {
                        context.pop();
                        // Logout via AuthProvider + FirebaseAuth
                        await authProvider.logout(context);
                      },
                      child: const Text("Ya, Keluar",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            final username = snapshot.data ?? "User";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Halo,",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: "Check in KM",
                  onPressed: () => context.push('/checkin'),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Profil Kendaraan",
                  onPressed: () => context.push('/profile'),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Jadwal & Pengingat",
                  onPressed: () => context.push('/schedule'),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Peringatan & Tips Perawatan",
                  onPressed: () => context.push('/tips'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

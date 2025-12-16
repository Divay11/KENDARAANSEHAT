import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _vehicleNameCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _ownerCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _fuelCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _crashHistoryCtrl = TextEditingController();

  // loading state used during async profile/image operations
  bool _loading = false;

  File? _imageFile;
  Uint8List? _imageBytes;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .get();

      if (doc.exists && mounted) {
        final data = doc.data()!;
        setState(() {
          _vehicleNameCtrl.text = data['vehicle_name'] ?? '';
          _nicknameCtrl.text = data['username'] ?? '';
          _plateCtrl.text = data['plate_number'] ?? '';
          _ownerCtrl.text = data['owner'] ?? '';
          _locationCtrl.text = data['location'] ?? '';
          _fuelCtrl.text = data['fuel'] ?? '';
          _countryCtrl.text = data['country'] ?? '';
          _crashHistoryCtrl.text = data['crash_history'] ?? '';
          _avatarUrl = data['avatar_url'];
        });
      }
    } catch (e) {
      debugPrint("Load profile error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    if (kIsWeb) {
      _imageBytes = await image.readAsBytes();
      _imageFile = null;
    } else {
      _imageFile = File(image.path);
      _imageBytes = null;
    }

    await _uploadImage(image);
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      setState(() => _loading = true);
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref('avatars/$uid.jpg');

      if (kIsWeb) {
        await ref.putData(await image.readAsBytes());
      } else {
        await ref.putFile(File(image.path));
      }

      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .set({'avatar_url': url}, SetOptions(merge: true));

      setState(() => _avatarUrl = url);
    } catch (e) {
      debugPrint("Upload error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('profiles').doc(uid).set({
        'vehicle_name': _vehicleNameCtrl.text,
        'username': _nicknameCtrl.text,
        'plate_number': _plateCtrl.text,
        'owner': _ownerCtrl.text,
        'location': _locationCtrl.text,
        'fuel': _fuelCtrl.text,
        'country': _countryCtrl.text,
        'crash_history': _crashHistoryCtrl.text,
        'avatar_url': _avatarUrl,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil disimpan")),
        );
        context.go('/home');
      }
    } catch (e) {
      debugPrint("Save profile error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  ImageProvider? _getImage() {
    if (kIsWeb && _imageBytes != null) {
      return MemoryImage(_imageBytes!);
    } else if (!kIsWeb && _imageFile != null) {
      return FileImage(_imageFile!);
    } else if (_avatarUrl != null) {
      return NetworkImage(_avatarUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Kendaraan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: _getImage(),
                child: _getImage() == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
                label: "Nama Kendaraan", controller: _vehicleNameCtrl),
            const SizedBox(height: 15),
            CustomTextField(label: "Username", controller: _nicknameCtrl),
            const SizedBox(height: 20),
            // Use `_loading` to control button behavior (prevents repeated saves and fixes analyzer warning).
            CustomButton(
              text: "Simpan Profil",
              onPressed: () {
                if (_loading) return;
                _saveProfile();
              },
            ),
          ],
        ),
      ),
    );
  }
}

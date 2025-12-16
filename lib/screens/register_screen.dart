import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; 
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(), 
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Buat akun\ndulu",
                    textAlign: TextAlign.right,
                    style: AppTheme.titleStyle,
                  ),
                ),
                
                const SizedBox(height: 40),

                CustomTextField(
                  label: "Username",
                  controller: _usernameController,
                ),
                const SizedBox(height: 20),
                
                CustomTextField(
                  label: "Email", 
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                
                CustomTextField(
                  label: "Password",
                  controller: _passController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                
                CustomTextField(
                  label: "Konfirmasi password",
                  controller: _confirmPassController,
                  isPassword: true,
                ),
                
                const SizedBox(height: 40),
                
                authProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                    : CustomButton(
                        text: "buat akun",
                        onPressed: () async {
                          if (_usernameController.text.isEmpty || 
                              _emailController.text.isEmpty || 
                              _passController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Semua kolom harus diisi!"), backgroundColor: Colors.red),
                            );
                            return;
                          }

                          if (_passController.text != _confirmPassController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Password tidak sama!"), backgroundColor: Colors.red),
                            );
                            return;
                          }

                          final success = await authProvider.register(
                            _emailController.text,
                            _passController.text,
                            _usernameController.text,
                            context,
                          );
                          if (!context.mounted) return;
                          if (success) {
                            context.go('/home');
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
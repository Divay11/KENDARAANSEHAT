import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Kuy\nLogin",
                    textAlign: TextAlign.right,
                    style: AppTheme.titleStyle,
                  ),
                ),
                const SizedBox(height: 50),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text("Lupa Password?",
                          style: TextStyle(color: Colors.red))),
                ),
                const SizedBox(height: 20),
                authProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryColor))
                    : CustomButton(
                        text: "login",
                        onPressed: () async {
                          final success = await authProvider.login(
                            _emailController.text,
                            _passController.text,
                            context,
                          );
                          if (!context.mounted) return;
                          if (success) {
                            context.go('/home');
                          }
                        },
                      ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text("Buat Akun Daftar",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

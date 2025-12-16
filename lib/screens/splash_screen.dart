import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/logo.jpg', 
                width: 180, 
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              "Kendaraan Sehat",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF4B5C), 
                fontFamily: 'Montserrat', 
              ),
            ),
            
            const SizedBox(height: 10),
            
            const CircularProgressIndicator(
              color: Color(0xFFFF4B5C),
            ),
          ],
        ),
      ),
    );
  }
}
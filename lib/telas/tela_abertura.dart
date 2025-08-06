import 'package:flutter/material.dart';
import 'dart:async';

class TelaAbertura extends StatefulWidget {
  const TelaAbertura({super.key});
  
  @override
  State<TelaAbertura> createState() => _TelaAberturaState();
}

class _TelaAberturaState extends State<TelaAbertura> {
  @override
  void initState() {
    super.initState();
    // Aumentando o tempo e garantindo que o widget está montado
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.forest,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Amazônia Experience',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
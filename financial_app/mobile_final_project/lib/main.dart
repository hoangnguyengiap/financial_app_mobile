import 'package:flutter/material.dart';
import 'screens_Giap/auth_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo App 2',
      home: const AuthScreen(),
    ),
  );
}

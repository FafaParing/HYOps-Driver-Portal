import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const HYOpsDriverApp());
}

class HYOpsDriverApp extends StatelessWidget {
  const HYOpsDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HYOps Driver Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
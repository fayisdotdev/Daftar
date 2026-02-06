import 'package:daftar/features/auth/screens/login_screen.dart';
import 'package:daftar/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return session == null ? const LoginScreen() : const HomeScreen();
  }
}

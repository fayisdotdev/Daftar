import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signInWithGoogle() async {
    final supabase = Supabase.instance.client;

    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "http://localhost:3000/auth/v1/callback",
      queryParams: {
        'access_type': 'offline',
        'prompt': 'consent',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithGoogle,
          child: const Text("Login with Google"),
        ),
      ),
    );
  }
}

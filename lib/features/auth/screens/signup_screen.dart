import 'dart:async';

import 'package:daftar/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Timer? _debounce;
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  String? _usernameMessage;

  @override
  void dispose() {
    _debounce?.cancel();
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _isUsernameAvailable = null;
      _usernameMessage = null;
    });

    final text = value.trim();
    if (text.isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isCheckingUsername = true);
      final available =
          await ref.read(authRepositoryProvider).isUsernameAvailable(text);
      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = available;
        _usernameMessage = available ? 'Username available' : 'Username already exists';
      });
    });
  }

  void _handleSignUp() {
    // ensure username was checked and is available
    if (_isUsernameAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username already exists'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      ref.read(authStateProvider.notifier).signUpWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim(),
            userName: _userNameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
          );
    }
  }

  void _navigateToLogin() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      if (next.isAuthenticated && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign up successful!"), backgroundColor: Colors.green),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    });

    final bool disableSignUp =
        authState.isLoading || _isCheckingUsername || (_isUsernameAvailable == false);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                const SizedBox(height: 20),
                const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _fullNameController,
                      enabled: !authState.isLoading,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "Full name is required" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _userNameController,
                      enabled: !authState.isLoading,
                      onChanged: _onUsernameChanged,
                      decoration: InputDecoration(
                        labelText: "User Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: _isCheckingUsername
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                            : (_isUsernameAvailable == true
                                ? const Icon(Icons.check, color: Colors.green)
                                : (_isUsernameAvailable == false ? const Icon(Icons.close, color: Colors.red) : null)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "User name is required";
                        if (_isUsernameAvailable == false) return "Username already exists";
                        return null;
                      },
                    ),
                    if (_usernameMessage != null) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _usernameMessage!,
                          style: TextStyle(color: _isUsernameAvailable == true ? Colors.green : Colors.red),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: !authState.isLoading,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Email is required";
                        if (!value.contains("@")) return "Enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      enabled: !authState.isLoading,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => (value == null || value.isEmpty) ? "Phone number is required" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !authState.isLoading,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Password is required";
                        if (value.length < 6) return "Password must be at least 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      enabled: !authState.isLoading,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please confirm your password";
                        if (value != _passwordController.text) return "Passwords do not match";
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: disableSignUp ? null : _handleSignUp,
                      icon: authState.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.app_registration),
                      label: Text(authState.isLoading ? "Creating Account..." : "Sign Up"),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Already have an account? "),
                      TextButton(onPressed: authState.isLoading ? null : _navigateToLogin, child: const Text("Login")),
                    ]),
                    const SizedBox(height: 20),
                  ]),
                ),
              ]),
            ),
          ),
          if (authState.isLoading)
            Container(color: Colors.black.withOpacity(0.3), child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
import 'package:daftar/features/auth/controllers/auth_state.dart';
import 'package:daftar/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(Supabase.instance.client);
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authRepository.getCurrentUser();
      state = AuthState(
        user: user,
        isAuthenticated: user != null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

    Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String userName,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Check username availability before creating an auth user
      final available = await _authRepository.isUsernameAvailable(userName);
      if (!available) {
        state = state.copyWith(
          isLoading: false,
          error: 'Username already exists',
        );
        return;
      }

      final user = await _authRepository.signUpWithEmailPassword(
        email: email,
        password: password,
        fullName: fullName,
        userName: userName,
        phoneNumber: phoneNumber,
      );

      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.signInWithGoogle();
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
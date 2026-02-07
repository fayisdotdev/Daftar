import 'package:daftar/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository(this._supabaseClient);

  // Email & Password Sign Up
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String userName,
    required String phoneNumber,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Sign up failed: User is null');
      }

      // Insert user profile data - try, but if unique constraint fails rollback auth session
      try {
        await _supabaseClient.from('profiles').insert({
          'id': user.id,
          'email': email,
          'full_name': fullName,
          'user_name': userName,
          'phone_number': phoneNumber,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (profileError) {
        final isDuplicate =
            profileError is PostgrestException &&
            (profileError.message?.contains('duplicate key') ?? false);
        // If username already exists, sign out the newly created auth session to avoid leaving user logged in
        try {
          await _supabaseClient.auth.signOut();
        } catch (_) {}
        if (isDuplicate) {
          throw Exception('Username already exists');
        }
        // Other profile creation errors: log and continue (or rethrow if you prefer)
        print('Profile creation error: $profileError');
      }

      return UserModel(
        id: user.id,
        email: email,
        fullName: fullName,
        userName: userName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw Exception('Sign up error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during sign up: $e');
    }
  }

  // Check username availability (returns true if available)
  Future<bool> isUsernameAvailable(String userName) async {
    try {
      final resp = await _supabaseClient
          .from('profiles')
          .select('id')
          .eq('user_name', userName)
          .maybeSingle();
      // when no row exists maybeSingle returns null -> available
      return resp == null;
    } catch (e) {
      // On error conservatively return false so signup doesn't proceed
      return false;
    }
  }

  // Email & Password Sign In
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Sign in failed: User is null');
      }

      final userData = await _getUserProfile(user.id);
      return userData;
    } on AuthException catch (e) {
      throw Exception('Sign in error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during sign in: $e');
    }
  }

  // Google Sign In
  Future<UserModel> signInWithGoogle() async {
    try {
      // signInWithOAuth returns bool, not AuthResponse
      final success = await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
        queryParams: {'access_type': 'offline', 'prompt': 'consent'},
      );

      if (!success) {
        throw Exception('Google sign in failed');
      }

      // Get current authenticated user
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser == null) {
        throw Exception('Google sign in failed: User is null');
      }

      // Get or create user profile
      final userData = await _getUserProfile(authUser.id);
      return userData;
    } on AuthException catch (e) {
      throw Exception('Google sign in error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during Google sign in: $e');
    }
  }

  // Get User Profile
  Future<UserModel> _getUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromMap(response);
    } catch (e) {
      // Profile doesn't exist, return basic user
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser != null) {
        return UserModel(
          id: userId,
          email: authUser.email ?? '',
          fullName: authUser.userMetadata?['full_name'] as String?,
          userName: authUser.userMetadata?['user_name'] as String?,
          createdAt: DateTime.now(),
        );
      }
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Sign out error: $e');
    }
  }

  // Get Current User
  Future<UserModel?> getCurrentUser() async {
    try {
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser == null) return null;

      return await _getUserProfile(authUser.id);
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _supabaseClient.auth.currentUser != null;
  }
}

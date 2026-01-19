import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      // Create profile in profiles table
      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'display_name': displayName,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'bloomspace://reset-password',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? bio,
    bool? hideActivity,
    bool? showOnlineStatus,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (displayName != null) updates['display_name'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (hideActivity != null) updates['hide_activity'] = hideActivity;
      if (showOnlineStatus != null) {
        updates['show_online_status'] = showOnlineStatus;
      }

      await _supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // Save a post
  Future<void> savePost({
    required String userId,
    required String postId,
    required String postTitle,
    required String postContent,
  }) async {
    try {
      await _supabase.from('saved_posts').insert({
        'user_id': userId,
        'post_id': postId,
        'post_title': postTitle,
        'post_content': postContent,
        'saved_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get saved posts
  Future<List<Map<String, dynamic>>> getSavedPosts(String userId) async {
    try {
      final response = await _supabase
          .from('saved_posts')
          .select()
          .eq('user_id', userId)
          .order('saved_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Remove saved post
  Future<void> removeSavedPost(String savedPostId) async {
    try {
      await _supabase.from('saved_posts').delete().eq('id', savedPostId);
    } catch (e) {
      rethrow;
    }
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('email', email);
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

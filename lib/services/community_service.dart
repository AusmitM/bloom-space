import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // ==================== POSTS ====================

  // Create a new post
  Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    required String channel,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('community_posts')
          .insert({
            'user_id': userId,
            'title': title,
            'content': content,
            'channel': channel,
            'upvotes': 0,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get posts by channel with user info and comment count
  Future<List<Map<String, dynamic>>> getPostsByChannel({
    required String channel,
    String sortBy = 'hot', // 'hot', 'new', 'top'
  }) async {
    try {
      String orderColumn = 'created_at';
      bool ascending = false;

      switch (sortBy) {
        case 'new':
          orderColumn = 'created_at';
          ascending = false;
          break;
        case 'top':
          orderColumn = 'upvotes';
          ascending = false;
          break;
        case 'hot':
        default:
          orderColumn = 'created_at';
          ascending = false;
      }

      // Fetch posts without joining profiles
      final postsResponse = await _supabase
          .from('community_posts')
          .select('*')
          .eq('channel', channel)
          .order(orderColumn, ascending: ascending);

      final posts = List<Map<String, dynamic>>.from(postsResponse);

      // Fetch user profiles for all posts
      final userIds = posts.map((post) => post['user_id']).toSet().toList();

      if (userIds.isNotEmpty) {
        final profilesResponse = await _supabase
            .from('profiles')
            .select('id, display_name')
            .inFilter('id', userIds);

        final profiles = Map.fromIterable(
          profilesResponse,
          key: (profile) => profile['id'],
          value: (profile) => profile,
        );

        // Add profile data to posts
        for (var post in posts) {
          final profile = profiles[post['user_id']];
          post['profiles'] = profile ?? {'display_name': 'Anonymous'};
        }
      }

      return posts;
    } catch (e) {
      rethrow;
    }
  }

  // Get all posts (for homepage feed)
  Future<List<Map<String, dynamic>>> getAllPosts({
    String sortBy = 'hot',
    int limit = 50,
  }) async {
    try {
      String orderColumn = 'created_at';
      bool ascending = false;

      switch (sortBy) {
        case 'new':
          orderColumn = 'created_at';
          ascending = false;
          break;
        case 'top':
          orderColumn = 'upvotes';
          ascending = false;
          break;
        case 'hot':
        default:
          orderColumn = 'created_at';
          ascending = false;
      }

      final response = await _supabase
          .from('community_posts')
          .select('*, profiles(display_name)')
          .order(orderColumn, ascending: ascending)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get single post with details
  Future<Map<String, dynamic>?> getPost(String postId) async {
    try {
      final post = await _supabase
          .from('community_posts')
          .select('*')
          .eq('id', postId)
          .maybeSingle();

      if (post != null && post['user_id'] != null) {
        final profile = await _supabase
            .from('profiles')
            .select('display_name')
            .eq('id', post['user_id'])
            .maybeSingle();

        post['profiles'] = profile ?? {'display_name': 'Anonymous'};
      }

      return post;
    } catch (e) {
      rethrow;
    }
  }

  // Update post
  Future<void> updatePost({
    required String postId,
    String? title,
    String? content,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updates['title'] = title;
      if (content != null) updates['content'] = content;

      await _supabase.from('community_posts').update(updates).eq('id', postId);
    } catch (e) {
      rethrow;
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      await _supabase.from('community_posts').delete().eq('id', postId);
    } catch (e) {
      rethrow;
    }
  }

  // Upvote post (toggle - click again to remove vote)
  Future<void> upvotePost(String postId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Check if user already voted
      final existingVote = await _supabase
          .from('post_votes')
          .select()
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingVote != null) {
        // User already voted
        if (existingVote['vote_type'] == 1) {
          // Already upvoted - remove the vote (toggle off)
          await _supabase
              .from('post_votes')
              .delete()
              .eq('post_id', postId)
              .eq('user_id', userId);
        } else {
          // Was downvote - change to upvote
          await _supabase
              .from('post_votes')
              .update({'vote_type': 1})
              .eq('post_id', postId)
              .eq('user_id', userId);
        }
      } else {
        // No existing vote - create new upvote
        await _supabase.from('post_votes').insert({
          'post_id': postId,
          'user_id': userId,
          'vote_type': 1,
        });
      }

      // Trigger will auto-update community_posts.upvotes
    } catch (e) {
      print('Error upvoting post: $e');
      rethrow;
    }
  }

  // Downvote post (toggle - click again to remove vote)
  Future<void> downvotePost(String postId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Check if user already voted
      final existingVote = await _supabase
          .from('post_votes')
          .select()
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingVote != null) {
        // User already voted
        if (existingVote['vote_type'] == -1) {
          // Already downvoted - remove the vote (toggle off)
          await _supabase
              .from('post_votes')
              .delete()
              .eq('post_id', postId)
              .eq('user_id', userId);
        } else {
          // Was upvote - change to downvote
          await _supabase
              .from('post_votes')
              .update({'vote_type': -1})
              .eq('post_id', postId)
              .eq('user_id', userId);
        }
      } else {
        // No existing vote - create new downvote
        await _supabase.from('post_votes').insert({
          'post_id': postId,
          'user_id': userId,
          'vote_type': -1,
        });
      }

      // Trigger will auto-update community_posts.upvotes
    } catch (e) {
      print('Error downvoting post: $e');
      rethrow;
    }
  }

  // ==================== COMMENTS ====================

  // Create a comment
  Future<Map<String, dynamic>> createComment({
    required String postId,
    required String content,
    String? parentCommentId, // For nested replies
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('comments')
          .insert({
            'post_id': postId,
            'user_id': userId,
            'parent_comment_id': parentCommentId,
            'content': content,
            'upvotes': 0,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get comments for a post (with nested replies)
  Future<List<Map<String, dynamic>>> getCommentsByPost(String postId) async {
    try {
      final commentsResponse = await _supabase
          .from('comments')
          .select('*')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      final comments = List<Map<String, dynamic>>.from(commentsResponse);

      // Fetch user profiles for all comments
      final userIds =
          comments.map((comment) => comment['user_id']).toSet().toList();

      if (userIds.isNotEmpty) {
        final profilesResponse = await _supabase
            .from('profiles')
            .select('id, display_name')
            .inFilter('id', userIds);

        final profiles = Map.fromIterable(
          profilesResponse,
          key: (profile) => profile['id'],
          value: (profile) => profile,
        );

        // Add profile data to comments
        for (var comment in comments) {
          final profile = profiles[comment['user_id']];
          comment['profiles'] = profile ?? {'display_name': 'Anonymous'};
        }
      }

      return comments;
    } catch (e) {
      rethrow;
    }
  }

  // Get replies to a comment
  Future<List<Map<String, dynamic>>> getReplies(String commentId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, profiles(display_name)')
          .eq('parent_comment_id', commentId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update comment
  Future<void> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      await _supabase
          .from('comments')
          .update({'content': content}).eq('id', commentId);
    } catch (e) {
      rethrow;
    }
  }

  // Delete comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _supabase.from('comments').delete().eq('id', commentId);
    } catch (e) {
      rethrow;
    }
  }

  // Upvote comment (toggle - click again to remove vote)
  Future<void> upvoteComment(String commentId) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Check if user already voted
      final existingVote = await _supabase
          .from('comment_votes')
          .select()
          .eq('comment_id', commentId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingVote != null) {
        // User already voted
        if (existingVote['vote_type'] == 1) {
          // Already upvoted - remove the vote (toggle off)
          await _supabase
              .from('comment_votes')
              .delete()
              .eq('comment_id', commentId)
              .eq('user_id', userId);
        } else {
          // Was downvote - change to upvote
          await _supabase
              .from('comment_votes')
              .update({'vote_type': 1})
              .eq('comment_id', commentId)
              .eq('user_id', userId);
        }
      } else {
        // No existing vote - create new upvote
        await _supabase.from('comment_votes').insert({
          'comment_id': commentId,
          'user_id': userId,
          'vote_type': 1,
        });
      }

      // Trigger will auto-update comments.upvotes
    } catch (e) {
      print('Error upvoting comment: $e');
      rethrow;
    }
  }

  // Get user's vote on a post (returns 1 for upvote, -1 for downvote, 0 for no vote)
  Future<int> getUserVoteOnPost(String postId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return 0;

      final vote = await _supabase
          .from('post_votes')
          .select('vote_type')
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      return vote?['vote_type'] as int? ?? 0;
    } catch (e) {
      print('Error getting user vote: $e');
      return 0;
    }
  }

  // Get user's vote on a comment
  Future<int> getUserVoteOnComment(String commentId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return 0;

      final vote = await _supabase
          .from('comment_votes')
          .select('vote_type')
          .eq('comment_id', commentId)
          .eq('user_id', userId)
          .maybeSingle();

      return vote?['vote_type'] as int? ?? 0;
    } catch (e) {
      print('Error getting user vote on comment: $e');
      return 0;
    }
  }

  // ==================== CHANNELS ====================

  // Get all available channels
  List<String> getChannels() {
    return [
      'b/Anxiety',
      'b/Depression',
      'b/Stress',
      'b/Sleep',
      'b/Relationships',
      'b/Academic',
      'b/General',
    ];
  }

  // Search posts
  Future<List<Map<String, dynamic>>> searchPosts(String query) async {
    try {
      final response = await _supabase
          .from('community_posts')
          .select('*, profiles(display_name)')
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .order('created_at', ascending: false)
          .limit(50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get user's posts
  Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    try {
      final response = await _supabase
          .from('community_posts')
          .select('*, profiles(display_name)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get user's comments
  Future<List<Map<String, dynamic>>> getUserComments(String userId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, profiles(display_name), community_posts(title)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }
}

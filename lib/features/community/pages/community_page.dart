import 'package:BloomSpace/features/common/widgets/bloom_logo.dart';
import 'package:BloomSpace/routes/app_routes.dart';
import 'package:BloomSpace/services/auth_service.dart';
import 'package:BloomSpace/services/community_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _communityService = CommunityService();
  final _authService = AuthService();

  String selectedChannel = 'b/Anxiety';
  String selectedTab = 'Hot';

  List<Map<String, dynamic>> posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final loadedPosts = await _communityService.getPostsByChannel(
        channel: selectedChannel,
        sortBy: selectedTab.toLowerCase(),
      );

      if (mounted) {
        setState(() {
          posts = loadedPosts;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading posts: $e'); // Debug print
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading posts: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  void _navigateTo(BuildContext context, String routeName) async {
    if (routeName.startsWith('http://') || routeName.startsWith('https://')) {
      final Uri uri = Uri.parse(routeName);

      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
      return;
    }

    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'What\'s on your mind?',
                ),
                maxLength: 300,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content (optional)',
                  hintText: 'Share more details...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                maxLength: 10000,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a title')),
                );
                return;
              }

              try {
                await _communityService.createPost(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  channel: selectedChannel,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post created successfully!'),
                      backgroundColor: Color(0xFF4A7C7C),
                    ),
                  );
                  _loadPosts();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating post: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7C7C),
            ),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = _authService.isLoggedIn;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),
      body: Column(
        children: [
          // Top Navigation Bar
          Container(
            color: const Color(0xFFF5F3E8),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              children: [
                const Row(
                  children: [
                    BloomLogo(),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bloom Space',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A3A),
                          ),
                        ),
                        Text(
                          'for TAMU students',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1E3A3A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 80),
                _buildNavItem(context, 'Home', AppRoutes.home),
                const SizedBox(width: 40),
                _buildNavItem(context, 'Community Space', AppRoutes.community),
                const SizedBox(width: 40),
                // DISABLED: 1-on-1 Chat
                // _buildNavItem(context, '1-on-1 Chat', AppRoutes.chat1_1),
                // const SizedBox(width: 40),
                _buildNavItem(
                  context,
                  'Counseling Services',
                  AppRoutes.counseling,
                ),
                const SizedBox(width: 40),
                _buildNavItem(context, 'Resources', AppRoutes.resources),
                const Spacer(),
                InkWell(
                  onTap: () => _navigateTo(context, '/notifications'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B9B8F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => _navigateTo(context, AppRoutes.profile),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B9B8F),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Sidebar - Channels
                Container(
                  width: 240,
                  color: const Color(0xFFF5F3E8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Channels',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A3A),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children:
                              _communityService.getChannels().map((channel) {
                            final isActive = selectedChannel == channel;
                            return InkWell(
                              onTap: () {
                                setState(() => selectedChannel = channel);
                                _loadPosts();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                color: isActive
                                    ? const Color(0xFF4A7C7C).withOpacity(0.1)
                                    : null,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? const Color(0xFF4A7C7C)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      channel,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isActive
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: const Color(0xFF1E3A3A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Feed
                Expanded(
                  child: Column(
                    children: [
                      // Tabs and Create Post Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton('Hot'),
                            const SizedBox(width: 8),
                            _buildTabButton('New'),
                            const SizedBox(width: 8),
                            _buildTabButton('Top'),
                            const Spacer(),
                            if (isAuthenticated)
                              ElevatedButton.icon(
                                onPressed: _showCreatePostDialog,
                                icon: const Icon(Icons.add, size: 20),
                                label: const Text('Create Post'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A7C7C),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              )
                            else
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.login);
                                },
                                child: const Text('Log in to post'),
                              ),
                          ],
                        ),
                      ),
                      // Posts List
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4A7C7C),
                                  ),
                                ),
                              )
                            : posts.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.forum_outlined,
                                          size: 64,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No posts yet in $selectedChannel',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        if (isAuthenticated) ...[
                                          const SizedBox(height: 8),
                                          TextButton(
                                            onPressed: _showCreatePostDialog,
                                            child: const Text(
                                              'Be the first to post!',
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(20),
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {
                                      return _buildPostCard(posts[index]);
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => _navigateTo(context, route),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1E3A3A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isActive = selectedTab == label;
    return InkWell(
      onTap: () {
        setState(() => selectedTab = label);
        _loadPosts();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4A7C7C) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final String postId = post['id'];
    final String title = post['title'] ?? 'Untitled';
    final String content = post['content'] ?? '';
    final int upvotes = post['upvotes'] ?? 0;
    final String authorName = post['profiles']?['display_name'] ?? 'Anonymous';

    // Parse the timestamp safely
    final String createdAtStr = post['created_at'];
    DateTime createdAt;
    try {
      // Handle different timestamp formats from Supabase
      if (createdAtStr.contains('+')) {
        // Format: "2025-11-24T14:45:01.489173+00:00"
        // Replace +00:00 with Z
        final normalizedStr =
            createdAtStr.replaceAll('+00:00', 'Z').replaceAll('+00', 'Z');
        print('Original: $createdAtStr');
        print('Normalized: $normalizedStr');
        createdAt = DateTime.parse(normalizedStr);
        print('Parsed DateTime: $createdAt');
        print('Is UTC: ${createdAt.isUtc}');
      } else if (createdAtStr.endsWith('Z')) {
        // Format: "2025-11-24T14:45:01.489173Z"
        createdAt = DateTime.parse(createdAtStr);
      } else {
        // Format: "2025-11-24 14:45:01.489173" (no timezone indicator)
        // Add Z to treat as UTC
        createdAt = DateTime.parse(createdAtStr + 'Z');
      }
    } catch (e) {
      print('Error parsing timestamp: $createdAtStr - $e');
      // Fallback to current time if parse fails
      createdAt = DateTime.now().toUtc();
    }

    final String timeAgo = _getTimeAgo(createdAt);

    // Note: comment count requires separate query, showing as 0 for now
    final int commentCount = 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(postId: postId),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upvote Section
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (!_authService.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please log in to vote'),
                          ),
                        );
                        return;
                      }
                      try {
                        await _communityService.upvotePost(postId);
                        await _loadPosts(); // Reload to show updated count
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_upward),
                    color: const Color(0xFF4A7C7C),
                    iconSize: 20,
                    padding: const EdgeInsets.all(8),
                  ),
                  Text(
                    upvotes.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (!_authService.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please log in to vote'),
                          ),
                        );
                        return;
                      }
                      try {
                        await _communityService.downvotePost(postId);
                        await _loadPosts(); // Reload to show updated count
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_downward),
                    color: Colors.grey,
                    iconSize: 20,
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Post Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A3A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (content.isNotEmpty) ...[
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Text(
                          'Posted by $authorName',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          ' • $timeAgo',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.comment_outlined,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '$commentCount ${commentCount == 1 ? 'comment' : 'comments'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    // Calculate difference between now and post time (both in UTC)
    final now = DateTime.now();
    final postTime = dateTime;
    final difference = now.difference(postTime);

    print('=== TIME CALCULATION ===');
    print('Input dateTime: $dateTime (isUtc: ${dateTime.isUtc})');
    print('Post time UTC: $postTime');
    print('Now UTC: $now');
    print('Difference hours: ${difference.inHours}');
    print('Difference minutes: ${difference.inMinutes}');
    print('========================');

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Post Detail Page (separate file recommended)
class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _communityService = CommunityService();
  final _authService = AuthService();
  final _commentController = TextEditingController();

  Map<String, dynamic>? post;
  List<Map<String, dynamic>> comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPostAndComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadPostAndComments() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final loadedPost = await _communityService.getPost(widget.postId);
      final loadedComments =
          await _communityService.getCommentsByPost(widget.postId);

      if (mounted) {
        setState(() {
          post = loadedPost;
          comments = loadedComments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading post: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    try {
      await _communityService.createComment(
        postId: widget.postId,
        content: _commentController.text.trim(),
      );

      _commentController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment posted!'),
            backgroundColor: Color(0xFF4A7C7C),
          ),
        );
      }
      _loadPostAndComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting comment: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A7C7C)),
          ),
        ),
      );
    }

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post Not Found')),
        body: const Center(child: Text('Post not found')),
      );
    }

    final String title = post!['title'] ?? 'Untitled';
    final String content = post!['content'] ?? '';
    final int upvotes = post!['upvotes'] ?? 0;
    final String authorName = post!['profiles']?['display_name'] ?? 'Anonymous';

    // Parse timestamp safely
    final String createdAtStr = post!['created_at'];
    DateTime createdAt;
    try {
      if (createdAtStr.contains('+')) {
        final normalizedStr =
            createdAtStr.replaceAll('+00:00', 'Z').replaceAll('+00', 'Z');
        createdAt = DateTime.parse(normalizedStr);
      } else if (createdAtStr.endsWith('Z')) {
        createdAt = DateTime.parse(createdAtStr);
      } else {
        createdAt = DateTime.parse(createdAtStr + 'Z');
      }
    } catch (e) {
      print('Error parsing timestamp: $createdAtStr - $e');
      createdAt = DateTime.now().toUtc();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3E8),
        foregroundColor: const Color(0xFF1E3A3A),
        elevation: 0.5,
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Content
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A3A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Posted by $authorName • ${_formatDate(createdAt)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (content.isNotEmpty)
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1E3A3A),
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (!_authService.isLoggedIn) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please log in to vote'),
                              ),
                            );
                            return;
                          }
                          await _communityService.upvotePost(widget.postId);
                          _loadPostAndComments();
                        },
                        icon: const Icon(Icons.arrow_upward),
                        color: const Color(0xFF4A7C7C),
                      ),
                      Text(
                        upvotes.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!_authService.isLoggedIn) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please log in to vote'),
                              ),
                            );
                            return;
                          }
                          await _communityService.downvotePost(widget.postId);
                          _loadPostAndComments();
                        },
                        icon: const Icon(Icons.arrow_downward),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Comment Input
            if (_authService.isLoggedIn)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add a comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'What are your thoughts?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _postComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A7C7C),
                      ),
                      child: const Text('Comment'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            // Comments Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${comments.length} ${comments.length == 1 ? 'Comment' : 'Comments'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (comments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No comments yet. Be the first to comment!',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ...comments.map((comment) => _buildCommentCard(comment)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    final String content = comment['content'] ?? '';
    final String authorName =
        comment['profiles']?['display_name'] ?? 'Anonymous';

    // Parse timestamp safely
    final String createdAtStr = comment['created_at'];
    DateTime createdAt;
    try {
      if (createdAtStr.contains('+')) {
        final normalizedStr =
            createdAtStr.replaceAll('+00:00', 'Z').replaceAll('+00', 'Z');
        createdAt = DateTime.parse(normalizedStr);
      } else if (createdAtStr.endsWith('Z')) {
        createdAt = DateTime.parse(createdAtStr);
      } else {
        createdAt = DateTime.parse(createdAtStr + 'Z');
      }
    } catch (e) {
      print('Error parsing comment timestamp: $createdAtStr - $e');
      createdAt = DateTime.now().toUtc();
    }

    final int upvotes = comment['upvotes'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                authorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                ' • ${_formatDate(createdAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  if (!_authService.isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to vote')),
                    );
                    return;
                  }
                  await _communityService.upvoteComment(comment['id']);
                  _loadPostAndComments();
                },
                icon: const Icon(Icons.arrow_upward, size: 18),
                color: const Color(0xFF4A7C7C),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Text(
                upvotes.toString(),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    // Ensure we're working with UTC time
    final now = DateTime.now().toUtc();
    final postTime = dateTime.toUtc();
    final difference = now.difference(postTime);

    if (difference.inDays > 7) {
      return '${dateTime.toLocal().month}/${dateTime.toLocal().day}/${dateTime.toLocal().year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

import 'package:BloomSpace/features/common/widgets/bloom_logo.dart';
import 'package:BloomSpace/routes/app_routes.dart';
import 'package:BloomSpace/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();

  bool hideActivity = true;
  bool showOnlineStatus = false;
  String selectedTab = 'Edit Profile';
  String selectedSidebarItem = 'Edit Profile';
  bool _isLoading = true;
  bool _isSaving = false;
  List<Map<String, dynamic>> savedPosts = [];

  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user == null) {
        // Redirect to login if not authenticated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        });
        return;
      }

      // Get user profile
      final profile = await _authService.getUserProfile(user.id);
      if (profile != null && mounted) {
        setState(() {
          userProfile = profile;
          _displayNameController.text = profile['display_name'] ?? '';
          _bioController.text = profile['bio'] ?? '';
          hideActivity = profile['hide_activity'] ?? true;
          showOnlineStatus = profile['show_online_status'] ?? false;
        });
      }

      // Get saved posts
      final posts = await _authService.getSavedPosts(user.id);
      if (mounted) {
        setState(() {
          savedPosts = posts;
        });
      }
    } catch (e) {
      // Show error after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading profile: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      final user = _authService.currentUser;
      if (user == null) return;

      await _authService.updateUserProfile(
        userId: user.id,
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
        hideActivity: hideActivity,
        showOnlineStatus: showOnlineStatus,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF4A7C7C),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: const Row(
          children: [
            BloomLogo(size: 36),
            SizedBox(width: 12),
            Text(
              'Bloom Space',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          _buildNavButton('Home', AppRoutes.home),
          _buildNavButton('Community Space', AppRoutes.community),
          // _buildNavButton('1-on-1 Chat', AppRoutes.chat1_1),
          _buildNavButton('Counseling Services', AppRoutes.counseling),
          _buildNavButton('Resources', AppRoutes.resources),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon!')),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 175,
            color: const Color(0xFFE8F0EE),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB3D4CC),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF5A9B8A),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    userProfile?['display_name'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSidebarItem('Edit Profile'),
                _buildSidebarItem('Saved Posts'),
                _buildSidebarItem('Privacy Settings'),
                _buildSidebarItem('Notification Settings'),
                _buildSidebarItem('Account'),
                _buildSidebarItem('Logout'),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile & Settings',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tabs
                    Row(
                      children: [
                        _buildTab('Edit Profile'),
                        const SizedBox(width: 48),
                        _buildTab('Privacy & Safety'),
                        const SizedBox(width: 48),
                        _buildTab('Notifications'),
                        const SizedBox(width: 48),
                        _buildTab('Saved Posts'),
                      ],
                    ),
                    const Divider(height: 1, thickness: 1, color: Colors.grey),
                    const SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Forms
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Display Name',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _displayNameController,
                                decoration: InputDecoration(
                                  hintText: 'Display Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: userProfile?['email'] ?? 'N/A',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Bio',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _bioController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'Tell us a bit about yourself...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                'Privacy',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hide my activity',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Others won\'t see your posts or comments',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF3B4C4C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: hideActivity,
                                    onChanged: (value) {
                                      setState(() => hideActivity = value);
                                    },
                                    activeColor: const Color(0xFF5A9B8A),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Show online status',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Let others see when you\'re online',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF3B4C4C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: showOnlineStatus,
                                    onChanged: (value) {
                                      setState(() => showOnlineStatus = value);
                                    },
                                    activeColor: const Color(0xFF5A9B8A),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              // Save Button
                              ElevatedButton(
                                onPressed: _isSaving ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A7C7C),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  border: Border.all(
                                    color: const Color(0xFFFFB74D),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: Color(0xFFE65100),
                                      size: 28,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'In a crisis? Call or text 988',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        // Right Column - Saved Posts
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Saved Posts',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (savedPosts.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: Text(
                                      'No saved posts yet',
                                      style: TextStyle(
                                        color: Color(0xFF3B4C4C),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...savedPosts.map((post) {
                                  return Column(
                                    children: [
                                      _buildSavedPost(post),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildSidebarItem(String label) {
    bool isActive = selectedSidebarItem == label;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedSidebarItem = label;
            });
            switch (label) {
              case 'Edit Profile':
                break;
              case 'Saved Posts':
                // Already on profile page, just highlight
                break;
              case 'Privacy Settings':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings')),
                );
                break;
              case 'Notification Settings':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings')),
                );
                break;
              case 'Account':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account settings')),
                );
                break;
              case 'Logout':
                _handleLogout();
                break;
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF5A9B8A) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    bool isActive = label == selectedTab;
    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
        switch (label) {
          case 'Privacy & Safety':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy & Safety tab')),
            );
            break;
          case 'Notifications':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications tab')),
            );
            break;
          case 'Saved Posts':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved Posts tab')),
            );
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            if (isActive)
              Container(
                height: 3,
                width: label.length * 8.0,
                color: const Color(0xFF5A9B8A),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedPost(Map<String, dynamic> post) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening: ${post['post_title']}')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    post['post_title'] ?? 'Untitled Post',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () async {
                    await _authService.removeSavedPost(post['id']);
                    await _loadUserProfile();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post removed')),
                      );
                    }
                  },
                ),
              ],
            ),
            if (post['post_content'] != null) ...[
              const SizedBox(height: 12),
              Text(
                post['post_content'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

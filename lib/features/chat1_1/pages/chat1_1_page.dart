import 'package:BloomSpace/features/common/widgets/bloom_logo.dart';
import 'package:BloomSpace/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Chat1_1Page extends StatelessWidget {
  const Chat1_1Page({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, String routeName) async {
    if (routeName.startsWith('http://') || routeName.startsWith('https://')) {
      final Uri uri = Uri.parse(routeName);

      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $routeName');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open link')),
          );
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
      return;
    }

    if (ModalRoute.of(context)?.settings.name != routeName) {
      debugPrint('Navigating to: $routeName');
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Navigation Bar (matches Home)
              Container(
                color: const Color(0xFFF5F3E8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  children: [
                    Row(
                      children: const [
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
                    _buildNavItem(
                        context, 'Community Space', AppRoutes.community),
                    const SizedBox(width: 40),
                    // _buildNavItem(context, '1-on-1 Chat', AppRoutes.chat1_1),
                    const SizedBox(width: 40),
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left sidebar
                    Container(
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigate to new chat page
                                      Navigator.pushNamed(context, '/new-chat');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6B9D7F),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Start New Chat',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Search conversations',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _buildFilterChip('All', true),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('Peer', false),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('Counselor', false),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.unfold_more, size: 20),
                                    const SizedBox(width: 4),
                                    const Text('2'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      'AN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Color(0xFF6B9D7F),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Counselor',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.unfold_more, size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8F5E9),
                              child:
                                  Icon(Icons.person, color: Color(0xFF6B9D7F)),
                            ),
                            title: const Text('TAMU Counselor'),
                            trailing: const Text(
                              'Thu 2:00',
                              style: TextStyle(fontSize: 12),
                            ),
                            onTap: () {
                              // Navigate to this conversation
                            },
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: InkWell(
                              onTap: () {
                                // Navigate back to dashboard
                                Navigator.pushNamed(context, '/dashboard');
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.arrow_back_ios, size: 16),
                                  SizedBox(width: 8),
                                  Text('Back to Dashboard'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Center chat area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Chat header
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '1-on-1 Chat',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              // Navigate to peer chat page
                                              Navigator.pushNamed(
                                                context,
                                                '/peer-chat',
                                              );
                                            },
                                            child:
                                                const Text('Start Peer Chat'),
                                          ),
                                          const SizedBox(width: 12),
                                          OutlinedButton(
                                            onPressed: () {
                                              // Navigate to counselor chat page
                                              Navigator.pushNamed(
                                                context,
                                                '/counselor-chat',
                                              );
                                            },
                                            child: const Text(
                                              'Start Counselor Chat',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Online: 3 listeners • 1 counselor',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            // Chat participant info
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color(0xFFE8F5E9),
                                        child: Icon(
                                          Icons.person,
                                          color: Color(0xFF6B9D7F),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Peer Listener',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            child: const Text(
                                              'Anonymous',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Online',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.volume_off),
                                    onPressed: () {
                                      // Mute functionality
                                    },
                                  ),
                                  const Text('Mute'),
                                  const SizedBox(width: 16),
                                  TextButton(
                                    onPressed: () {
                                      // Block functionality
                                    },
                                    child: const Text('Block'),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            // Messages
                            ListView(
                              padding: const EdgeInsets.all(24),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('Glad you reached out.'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color(0xFFE8F5E9),
                                        child: Icon(
                                          Icons.person,
                                          color: Color(0xFF6B9D7F),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Text(
                                          'Feeling overwhelmed can be really tough.\nYou don\'t have to go through this alone.',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Thank you for listening.',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        // Navigate to breathing exercise
                                        Navigator.pushNamed(
                                          context,
                                          '/breathing-exercise',
                                        );
                                      },
                                      icon: const Icon(Icons.air),
                                      label: const Text('Breathing exercise'),
                                    ),
                                    const SizedBox(width: 12),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        // Navigate to grounding steps
                                        Navigator.pushNamed(
                                          context,
                                          '/grounding-steps',
                                        );
                                      },
                                      icon: const Icon(Icons.self_improvement),
                                      label: const Text('Grounding steps'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Input area
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border(
                                  top: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Please avoid sharing personal identifiers.\nAnonymous mode is on by default',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Share Resource use',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          // Show emoji picker
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Send message
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF6B9D7F,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Send',
                                          style: TextStyle(color: Colors.white),
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
                    const SizedBox(width: 24),
                    // Right sidebar
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to booking page
                                Navigator.pushNamed(context, '/book-session');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B9D7F),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Book a Session',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Helpful resources',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              // Navigate to ANM article
                              Navigator.pushNamed(context, '/tamu-article');
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.play_circle_outline,
                                  color: Color(0xFF6B9D7F),
                                ),
                                SizedBox(width: 8),
                                Text('TAMU article'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () {
                              // Navigate to campus link
                              Navigator.pushNamed(context, '/campus-link');
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.link, color: Color(0xFF6B9D7F)),
                                SizedBox(width: 8),
                                Text('Campus link'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Private notes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Session summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              // Save transcript functionality
                            },
                            child: const Text('Save Transcript'),
                          ),
                        ],
                      ),
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

  Widget _buildFilterChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.grey[300] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: selected ? Colors.black : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String text, String route) {
    return InkWell(
      onTap: () => _navigateTo(context, route),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E3A3A),
          ),
        ),
      ),
    );
  }
}

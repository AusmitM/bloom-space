import 'package:BloomSpace/features/common/widgets/bloom_logo.dart';
import 'package:BloomSpace/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, String routeName) async {
    if (routeName.startsWith('http://') || routeName.startsWith('https://')) {
      final Uri uri = Uri.parse(routeName);

      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $routeName');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open link')));
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
      backgroundColor: const Color(0xFFD4E5D8),
      body: Column(
        children: [
          // Top Navigation Bar
          Container(
            color: const Color(0xFFF5F3E8),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              children: [
                // Logo and Brand
                Row(
                  children: const [
                    BloomLogo(),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                // Navigation Items - CLICKABLE
                // TODO: Replace '' with your route names like '/home', '/community', etc.
                _buildNavItem(context, 'Home', AppRoutes.home),
                const SizedBox(width: 40),
                _buildNavItem(context, 'Community Space', AppRoutes.community),
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
                // Icons - CLICKABLE
                // TODO: Replace '' with your route names
                InkWell(
                  onTap: () => _navigateTo(
                    context,
                    '/notifications',
                  ), // Notifications route
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
                  onTap: () =>
                      _navigateTo(context, AppRoutes.profile), // Profile route
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row with Daily Bloom and right cards
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Daily Bloom Section
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB8D4C6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      // Flower pot illustration
                                      Container(
                                        width: 140,
                                        height: 160,
                                        child: CustomPaint(
                                          painter: SimpleFlowerPotPainter(),
                                        ),
                                      ),
                                      const SizedBox(width: 50),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Daily Bloom',
                                              style: TextStyle(
                                                fontSize: 44,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E3A3A),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Take time to celebrate your progress,\nno matter how small.',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Color(0xFF1E3A3A),
                                                height: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 28),
                                            Row(
                                              children: [
                                                // 1-min Breathe button - CLICKABLE
                                                // TODO: Replace '' with your route
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      _navigateTo(context, ''),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF4A7C7C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 28,
                                                      vertical: 14,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    '1-min Breathe',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                // See Tips button - CLICKABLE
                                                // TODO: Replace '' with your route
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      _navigateTo(context, ''),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        const Color(0xFF1E3A3A),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 28,
                                                      vertical: 14,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'See Tips',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
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
                              // Right column - fills vertical space
                              Column(
                                children: [
                                  // Book counseling card
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF6B9B8F,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'Book counseling',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF1E3A3A,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Schedule an appointment',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Color(
                                                          0xFF1E3A3A,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Schedule button - CLICKABLE
                                          // TODO: Replace '' with your route
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _navigateTo(context, ''),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF4A7C7C,
                                                ),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 14,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                'Schedule',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Crisis support card - CLICKABLE
                                  // TODO: Replace '' with your route
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _navigateTo(
                                        context,
                                        AppRoutes.counseling,
                                      ),
                                      child: Container(
                                        width: 300,
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4A7C7C),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Crisis support',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 14),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Call 988',
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              '24/7 support available',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Three cards row - fills the entire horizontal space - CLICKABLE
                        // TODO: Replace '' with your routes
                        Row(
                          children: [
                            Expanded(
                              child: _buildFeatureCard(
                                context,
                                Icons.chat_bubble_outline,
                                '1-on-1\nChat',
                                'Connect with a peer\nlistener',
                                '', // Route for 1-on-1 Chat
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildFeatureCard(
                                context,
                                Icons.people_outline,
                                'Community\nSpace',
                                'Join discussions\nand share',
                                '', // Route for Community Space
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildFeatureCard(
                                context,
                                Icons.favorite_border,
                                'Counselling\nServices',
                                'Find support and resources',
                                AppRoutes
                                    .counseling, // Route for Counselling Services
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Community Highlights - with cream background
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F3E8),
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Community Highlights',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A3A),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Community post cards - CLICKABLE
                        // TODO: Replace '' with your routes
                        Row(
                          children: [
                            Expanded(
                              child: _buildPostCard(
                                context,
                                'r/academic_stress',
                                'Time Management Tips\nfor Busy Students',
                                '3 h ago',
                                '',
                                '', // Route for this post
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildPostCard(
                                context,
                                'r/selfcare',
                                'Simple Self-Care Practices to Try',
                                '1 day ago',
                                '18 comments',
                                '', // Route for this post
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildPostCard(
                                context,
                                'r/anxiety_support',
                                'Coping with Exam Anxiety',
                                '2 days ago',
                                '30 comments',
                                '', // Route for this post
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
        ],
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

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String route,
  ) {
    return InkWell(
      onTap: () => _navigateTo(context, route),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6B9B8F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
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
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E3A3A),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    String subreddit,
    String title,
    String time,
    String comments,
    String route,
  ) {
    return InkWell(
      onTap: () => _navigateTo(context, route),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E5D8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subreddit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1E3A3A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A3A),
                    height: 1.3,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  comments.isEmpty ? time : '$time - $comments',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E3A3A),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF1E3A3A),
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Simple flower pot painter matching the reference image
class SimpleFlowerPotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw pot (rounded trapezoid)
    final potPaint = Paint()
      ..color = const Color(0xFF5A8A7E)
      ..style = PaintingStyle.fill;

    final potPath = Path()
      ..moveTo(size.width * 0.28, size.height * 0.65)
      ..lineTo(size.width * 0.2, size.height * 0.95)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height,
        size.width * 0.25,
        size.height,
      )
      ..lineTo(size.width * 0.75, size.height)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height,
        size.width * 0.8,
        size.height * 0.95,
      )
      ..lineTo(size.width * 0.72, size.height * 0.65)
      ..close();
    canvas.drawPath(potPath, potPaint);

    // Draw pot rim
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.15,
          size.height * 0.6,
          size.width * 0.7,
          size.height * 0.08,
        ),
        const Radius.circular(4),
      ),
      potPaint,
    );

    // Draw stems/leaves (simple vertical lines)
    final stemPaint = Paint()
      ..color = const Color(0xFF5A8A7E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Center stem
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.25),
      stemPaint,
    );

    // Draw leaves (simple ovals)
    final leafPaint = Paint()
      ..color = const Color(0xFF5A8A7E)
      ..style = PaintingStyle.fill;

    // Left leaves
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.32, size.height * 0.5),
        width: size.width * 0.25,
        height: size.height * 0.2,
      ),
      leafPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.35, size.height * 0.38),
        width: size.width * 0.22,
        height: size.height * 0.18,
      ),
      leafPaint,
    );

    // Right leaves
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.68, size.height * 0.5),
        width: size.width * 0.25,
        height: size.height * 0.2,
      ),
      leafPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.38),
        width: size.width * 0.22,
        height: size.height * 0.18,
      ),
      leafPaint,
    );

    // Draw flowers (simple circles for petals)
    final flowerPaint = Paint()
      ..color = const Color(0xFFE89B8C)
      ..style = PaintingStyle.fill;

    // Left flower
    _drawFlower(
      canvas,
      Offset(size.width * 0.35, size.height * 0.18),
      size.width * 0.08,
      flowerPaint,
    );

    // Center flower
    _drawFlower(
      canvas,
      Offset(size.width * 0.5, size.height * 0.12),
      size.width * 0.09,
      flowerPaint,
    );

    // Right flower
    _drawFlower(
      canvas,
      Offset(size.width * 0.65, size.height * 0.18),
      size.width * 0.08,
      flowerPaint,
    );
  }

  void _drawFlower(Canvas canvas, Offset center, double radius, Paint paint) {
    // Draw 5 petals
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72 - 90) * math.pi / 180;
      final petalX = center.dx + radius * 0.6 * math.cos(angle);
      final petalY = center.dy + radius * 0.6 * math.sin(angle);

      canvas.drawCircle(Offset(petalX, petalY), radius * 0.45, paint);
    }

    // Draw center
    final centerPaint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.35, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class CounselingPage extends StatelessWidget {
  const CounselingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A3A),
        elevation: 0.5,
        title: const Text('Counseling Services'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Professional support for TAMU students',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF1E3A3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find the right counseling option, schedule an appointment, or reach crisis support.',
            style: TextStyle(
              color: Color(0xFF3B4C4C),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _ActionCard(
            title: 'Book an appointment',
            subtitle: 'Schedule with Counseling & Psychological Services.',
            buttonLabel: 'Schedule',
            onPressed: () {
              // Replace with your scheduling route or deep link
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hook up scheduling route here.'),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'Drop-in consultation',
            subtitle:
                'Quick, informal consultations for brief support or questions.',
            buttonLabel: 'Find times',
            onPressed: () {
              // Replace with your drop-in info route
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hook up drop-in info route here.'),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'After-hours crisis line',
            subtitle: 'Talk to a counselor 24/7 if you need urgent support.',
            buttonLabel: 'Call 988',
            onPressed: () {
              // Replace with your preferred dialer/launch action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Use url_launcher to call 988.'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'What to expect',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1E3A3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _BulletedList(
            items: [
              'Confidential sessions with licensed counselors.',
              'Goal-focused support tailored to student needs.',
              'Referrals to specialized care when helpful.',
              'Workshops and group sessions for common topics.',
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Emergency resources',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1E3A3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _BulletedList(
            items: [
              'Call 911 for immediate danger or medical emergencies.',
              'Dial 988 for the Suicide & Crisis Lifeline.',
              'Text HOME to 741741 to reach the Crisis Text Line.',
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3B4C4C),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C7C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletedList extends StatelessWidget {
  final List<String> items;

  const _BulletedList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      color: Color(0xFF1E3A3A),
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF3B4C4C),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

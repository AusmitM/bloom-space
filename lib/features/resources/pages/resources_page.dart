import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final resources = [
      _Resource(
        title: 'Self-guided coping tools',
        description:
            'Short breathing, grounding, and journaling exercises you can use anytime.',
        actionLabel: 'Open tools',
      ),
      _Resource(
        title: 'Workshops & groups',
        description: 'Join skill-building workshops and peer support groups.',
        actionLabel: 'View schedule',
      ),
      _Resource(
        title: 'Academic support',
        description:
            'Time management, study skills, and accommodations information.',
        actionLabel: 'See resources',
      ),
      _Resource(
        title: 'Identity-based support',
        description:
            'Affirming resources for LGBTQIA+, first-gen, veterans, and more.',
        actionLabel: 'Find support',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F0EA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A3A),
        elevation: 0.5,
        title: const Text('Resources'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Explore campus and self-serve resources',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF1E3A3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quick links to help you take the next step—on your own or with support.',
            style: TextStyle(
              color: Color(0xFF3B4C4C),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          for (final resource in resources) ...[
            _ResourceCard(resource: resource),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 8),
          Text(
            'Need something else?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1E3A3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reach out to counseling services or talk to a peer supporter for tailored suggestions.',
            style: TextStyle(
              color: Color(0xFF3B4C4C),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Resource {
  final String title;
  final String description;
  final String actionLabel;

  const _Resource({
    required this.title,
    required this.description,
    required this.actionLabel,
  });
}

class _ResourceCard extends StatelessWidget {
  final _Resource resource;

  const _ResourceCard({required this.resource});

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
                    resource.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    resource.description,
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
              onPressed: () {
                // Replace with navigation to real content or external link
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${resource.actionLabel} tapped')),
                );
              },
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
              child: Text(resource.actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

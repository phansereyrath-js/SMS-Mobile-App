part of '../workflows.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final Map<String, dynamic> post;
  const AnnouncementDetailPage({super.key, required this.post});
  String _plain(dynamic value) => '$value'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();
  @override
  Widget build(BuildContext context) {
    final title = _plain(post['Title'] ?? 'Announcement'),
        description = _plain(post['Description'] ?? ''),
        date = _plain(post['UpdatedAt'] ?? post['updated_at'] ?? '');
    final image = '${post['Image'] ?? post['Attachment'] ?? ''}'.trim();
    return Scaffold(
      backgroundColor: AppColors.colorFFFBFAF9,
      appBar: const _InnerHeader(title: 'Class Activity'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 210,
                width: double.infinity,
                child: backendDataImage(
                  image,
                  fit: BoxFit.cover,
                  fallback: const ColoredBox(
                    color: AppColors.colorFFEEF2F5,
                    child: Center(child: Text('Backend image unavailable')),
                  ),
                ),
              ),
            ),
          if (image.isNotEmpty) const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
              color: AppColors.colorFF542F1B,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Colors.black45),
              const SizedBox(width: 5),
              Text(
                date,
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),
            ],
          ),
          const Divider(height: 28),
          Text(
            description.isEmpty ? 'No additional details.' : description,
            style: const TextStyle(fontSize: 13, height: 1.65),
          ),
        ],
      ),
    );
  }
}

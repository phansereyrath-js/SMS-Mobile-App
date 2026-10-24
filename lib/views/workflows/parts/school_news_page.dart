part of '../workflows.dart';

class SchoolNewsPage extends StatelessWidget {
  const SchoolNewsPage({super.key});

  String _text(dynamic value) => '$value'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .trim();

  @override
  Widget build(BuildContext context) {
    final posts =
        <Map<String, dynamic>>[
          ...BackendDataScope.records(
            context,
            'setting-activities',
          ).map((row) => {...row, '_notice_kind': 'Class Activity'}),
        ]..sort((a, b) {
          final aDate =
              '${a['released_at'] ?? a['updated_at'] ?? a['UpdatedAt'] ?? a['created_at'] ?? ''}';
          final bDate =
              '${b['released_at'] ?? b['updated_at'] ?? b['UpdatedAt'] ?? b['created_at'] ?? ''}';
          return bDate.compareTo(aDate);
        });
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Class Activities'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 25),
        children: [
          Text(
            '${posts.length} ${workflowText(context, 'classroom activities')}',
            style: const TextStyle(fontSize: 9, color: Colors.white70),
          ),
          const Divider(height: 20),
          if (posts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No classroom activities available.'),
              ),
            ),
          ...posts.map((post) {
            final kind = '${post['_notice_kind'] ?? 'Notification'}';
            final isInvoice = kind == 'Invoice Released';
            final title = isInvoice
                ? _text(post['invoice_no'] ?? 'Invoice released')
                : _text(post['Title'] ?? kind);
            final description = isInvoice
                ? '${_text(post['description'] ?? 'School fee')} • ${post['currency'] ?? 'USD'} ${(num.tryParse('${post['total']}') ?? 0).toStringAsFixed(2)}'
                : _text(post['Description'] ?? '');
            final date = _text(
              post['released_at'] ??
                  post['UpdatedAt'] ??
                  post['updated_at'] ??
                  post['created_at'] ??
                  post['invoice_date'] ??
                  '',
            );
            final image = '${post['Image'] ?? post['Attachment'] ?? ''}'.trim();
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.colorFFE3DCD6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: isInvoice
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PaymentDetailPage(
                            invoice: '${post['invoice_no'] ?? ''}',
                            date: '${post['invoice_date'] ?? ''}',
                            status:
                                (num.tryParse('${post['paid']}') ?? 0) >=
                                    (num.tryParse('${post['total']}') ?? 0)
                                ? 'Paid'
                                : 'Unpaid',
                            statusColor:
                                (num.tryParse('${post['paid']}') ?? 0) >=
                                    (num.tryParse('${post['total']}') ?? 0)
                                ? AppColors.colorFF43B76F
                                : AppColors.colorFFE59A23,
                            description:
                                '${post['description'] ?? 'Pre-Invoice'}',
                            amount:
                                num.tryParse('${post['total']}')?.toDouble() ??
                                0,
                            currency: '${post['currency'] ?? 'USD'}',
                            preInvoiceId: '${post['id'] ?? ''}',
                            canPay: true,
                            releasedAt:
                                '${post['released_at'] ?? post['created_at'] ?? post['invoice_date'] ?? ''}',
                            paidAt: '${post['paid_at'] ?? ''}',
                          ),
                        ),
                      )
                    : () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => AnnouncementDetailPage(post: post),
                        ),
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        height: 165,
                        child: backendDataImage(
                          image,
                          fit: BoxFit.cover,
                          fallback: const ColoredBox(
                            color: AppColors.colorFFEEF2F5,
                            child: Center(
                              child: Text('Backend image unavailable'),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isInvoice
                                    ? Icons.receipt_long_outlined
                                    : kind == 'Class Activity'
                                    ? Icons.event_outlined
                                    : Icons.campaign_outlined,
                                size: 17,
                                color: AppColors.colorFF8A4B20,
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kind.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 8,
                              color: AppColors.colorFFB36A36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .7,
                            ),
                          ),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, height: 1.4),
                            ),
                          ],
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: AppColors.colorFF8D7666,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Read more',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.colorFF8A4B20,
                                  fontWeight: FontWeight.w800,
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
            );
          }),
        ],
      ),
    );
  }
}

part of '../../app.dart';

class BackendNotificationPage extends StatefulWidget {
  const BackendNotificationPage({super.key});

  @override
  State<BackendNotificationPage> createState() =>
      _BackendNotificationPageState();
}

class _BackendNotificationPageState extends State<BackendNotificationPage> {
  final _controller = NotificationsController(
    loadDashboard: () async =>
        backendWorkflowTestData ?? await MobileApi().dashboard(),
  );
  NotificationReadStore get _notificationStore => _controller.store;
  Set<String> get _unreadKeys => _controller.unreadKeys;
  String get _language => _controller.language.value;
  String _selected = 'Transactions';

  String _tr(String english) {
    const translations = <String, Map<String, String>>{
      'Khmer': {
        'Notifications': 'ការជូនដំណឹង',
        'New': 'ថ្មី',
        'Transactions': 'ប្រតិបត្តិការ',
        'School': 'សាលា',
        'Retry': 'ព្យាយាមម្ដងទៀត',
        'Loading notifications...': 'កំពុងផ្ទុកការជូនដំណឹង...',
        'No backend payments received.': 'មិនមានការទូទាត់ពីប្រព័ន្ធទេ។',
        'No school announcements available.': 'មិនមានសេចក្ដីជូនដំណឹងពីសាលាទេ។',
        'Invoice released': 'វិក្កយបត្របានចេញ',
        'Payment received': 'បានទទួលការទូទាត់',
        'payment received': 'បានទទួលការទូទាត់',
        'Paid': 'បានបង់',
        'Pending': 'កំពុងរង់ចាំ',
        'Payment method unavailable': 'មិនមានវិធីទូទាត់',
        'Receipt': 'បង្កាន់ដៃ',
        'School announcement': 'សេចក្ដីជូនដំណឹងពីសាលា',
      },
      'Chinese': {
        'Notifications': '通知',
        'New': '新消息',
        'Transactions': '交易',
        'School': '学校',
        'Retry': '重试',
        'Loading notifications...': '正在加载通知...',
        'No backend payments received.': '暂无后台付款记录。',
        'No school announcements available.': '暂无学校公告。',
        'Invoice released': '发票已发布',
        'Payment received': '已收到付款',
        'payment received': '已收到付款',
        'Paid': '已付款',
        'Pending': '待处理',
        'Payment method unavailable': '付款方式不可用',
        'Receipt': '收据',
        'School announcement': '学校公告',
      },
    };
    return translations[_language]?[english] ?? english;
  }

  @override
  void initState() {
    super.initState();
    _controller.onStart();
  }

  @override
  void dispose() {
    _controller.onDelete();
    super.dispose();
  }

  Future<void> _reload() => _controller.reload();

  String _plain(Object? value) => '${value ?? ''}'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();

  List<Map<String, dynamic>> _list(Map<String, dynamic> data, String key) =>
      (data[key] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

  List<Map<String, dynamic>> _records(
    Map<String, dynamic> data,
    String workflow,
  ) {
    final records = data['records'] as Map? ?? const {};
    return (records[workflow] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _transactionTitle(Map<String, dynamic> row) {
    if (row['_notification_type'] == 'invoice') {
      return _plain(row['invoice_no']).isEmpty
          ? _tr('Invoice released')
          : _plain(row['invoice_no']);
    }
    final category = _plain(row['category']);
    return category.isEmpty
        ? _tr('Payment received')
        : '$category ${_tr('payment received')}';
  }

  String _transactionSummary(Map<String, dynamic> row) {
    if (row['_notification_type'] == 'invoice') {
      final currency = _plain(row['currency']).isEmpty
          ? 'USD'
          : _plain(row['currency']);
      final total = num.tryParse('${row['total']}')?.toDouble() ?? 0;
      final paid = num.tryParse('${row['paid']}')?.toDouble() ?? 0;
      final method = _plain(row['payment_method']);
      final status = paid >= total && total > 0
          ? _tr('Paid')
          : _plain(row['payment_status']).isEmpty
          ? _tr('Pending')
          : _plain(row['payment_status']);
      return '$currency ${total.toStringAsFixed(2)} • $status${method.isEmpty ? '' : ' • $method'}';
    }
    final currency = _plain(row['currency']).isEmpty
        ? 'USD'
        : _plain(row['currency']);
    final amount = num.tryParse('${row['amount']}')?.toDouble() ?? 0;
    final method = _plain(row['method']).isEmpty
        ? _tr('Payment method unavailable')
        : _plain(row['method']);
    final receipt = _plain(row['receipt']);
    return '$currency ${amount.toStringAsFixed(2)} • $method${receipt.isEmpty ? '' : ' • ${_tr('Receipt')} $receipt'}';
  }

  List<Map<String, dynamic>> _transactions(Map<String, dynamic> data) {
    final payments = _list(
      data,
      'payments',
    ).map((row) => {...row, '_notification_type': 'payment'}).toList();
    final receipts = payments
        .map((row) => _plain(row['receipt']))
        .where((value) => value.isNotEmpty)
        .toSet();
    final invoices = _records(data, 'pre-invoices')
        .where((row) => !receipts.contains(_plain(row['payment_receipt'])))
        .map((row) => {...row, '_notification_type': 'invoice'});
    return [...payments, ...invoices]
      ..sort((a, b) => _transactionDate(b).compareTo(_transactionDate(a)));
  }

  String _transactionDate(Map<String, dynamic> row) => _plain(
    row['paid_at'] ??
        row['released_at'] ??
        row['updated_at'] ??
        row['created_at'] ??
        row['invoice_date'],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.colorFF06254D,
    body: Container(
      decoration: BoxDecoration(gradient: _activeGradient()),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: Obx(() {
              final snapshot = _controller.loading.value
                  ? const AsyncSnapshot<Map<String, dynamic>>.waiting()
                  : _controller.error.value != null
                  ? AsyncSnapshot<Map<String, dynamic>>.withError(
                      ConnectionState.done,
                      _controller.error.value!,
                    )
                  : AsyncSnapshot<Map<String, dynamic>>.withData(
                      ConnectionState.done,
                      _controller.data.value ?? {},
                    );
              _controller.unreadKeys.length;
              _controller.language.value;
              final data = snapshot.data ?? const <String, dynamic>{};
              final transactions = _transactions(data);
              final announcements = _records(data, 'setting-announcement')
                ..sort(
                  (
                    a,
                    b,
                  ) => '${b['updated_at'] ?? b['UpdatedAt'] ?? b['created_at'] ?? ''}'
                      .compareTo(
                        '${a['updated_at'] ?? a['UpdatedAt'] ?? a['created_at'] ?? ''}',
                      ),
                );
              final items = _selected == 'Transactions'
                  ? transactions
                  : announcements;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 16, 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _tr('Notifications'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            '${_unreadKeys.length} ${_tr('New')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _notificationTab(
                          'Transactions',
                          Icons.account_balance_wallet_rounded,
                          AppColors.colorFF59C8FF,
                        ),
                        const SizedBox(width: 10),
                        _notificationTab(
                          'School',
                          Icons.school_rounded,
                          AppColors.colorFF7EE7B2,
                        ),
                      ],
                    ),
                  ),
                  if (snapshot.connectionState != ConnectionState.done)
                    const LinearProgressIndicator(
                      color: AppColors.colorFF55DFF5,
                    ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: _reload,
                            child: Text(_tr('Retry')),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Text(
                              snapshot.connectionState != ConnectionState.done
                                  ? _tr('Loading notifications...')
                                  : _selected == 'Transactions'
                                  ? _tr('No backend payments received.')
                                  : _tr('No school announcements available.'),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await _reload();
                            },
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final row = items[index];
                                final transaction = _selected == 'Transactions';
                                final color = transaction
                                    ? AppColors.colorFF59C8FF
                                    : AppColors.colorFF7EE7B2;
                                final title = transaction
                                    ? _transactionTitle(row)
                                    : _plain(
                                        row['Title'] ??
                                            _tr('School announcement'),
                                      );
                                final summary = transaction
                                    ? _transactionSummary(row)
                                    : _plain(row['Description']);
                                final time = transaction
                                    ? _transactionDate(row)
                                    : _plain(
                                        row['UpdatedAt'] ??
                                            row['updated_at'] ??
                                            row['created_at'],
                                      );
                                return _backendNotificationCard(
                                  category: _selected,
                                  title: title,
                                  summary: summary,
                                  time: time,
                                  color: color,
                                  icon: transaction
                                      ? Icons.payment_rounded
                                      : Icons.campaign_outlined,
                                  image: transaction
                                      ? ''
                                      : _plain(
                                          row['Image'] ?? row['Attachment'],
                                        ),
                                  onTap: transaction
                                      ? () => _openTransaction(data, row)
                                      : () => _openAnnouncement(row),
                                  unread: _unreadKeys.contains(
                                    _notificationStore.itemKey(
                                      row,
                                      transaction
                                          ? '${row['_notification_type']}'
                                          : 'school',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    ),
  );

  Widget _notificationTab(String label, IconData icon, Color color) {
    final active = _selected == label;
    return InkWell(
      onTap: () => setState(() => _selected = label),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? Colors.white.withValues(alpha: .18)
              : Colors.black.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: active ? Colors.white38 : Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              _tr(label),
              style: TextStyle(
                color: active ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backendNotificationCard({
    required String category,
    required String title,
    required String summary,
    required String time,
    required Color color,
    required IconData icon,
    String image = '',
    VoidCallback? onTap,
    bool unread = false,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.color99111B2D,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (unread)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.colorFFF36A8D,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _tr('New'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          if (image.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 145,
                child: _notificationImage(image),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: .5)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            time,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _tr(category),
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        summary,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _notificationImage(String source) {
    if (source.startsWith('data:image') && source.contains(',')) {
      try {
        return Image.memory(
          base64Decode(source.substring(source.indexOf(',') + 1)),
          fit: BoxFit.cover,
        );
      } catch (_) {}
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            Image.asset('assets/welcome-back.png', fit: BoxFit.cover),
      );
    }
    return Image.asset('assets/welcome-back.png', fit: BoxFit.cover);
  }

  Future<void> _markItemRead(Map<String, dynamic> row, String type) =>
      _controller.markRead(row, type);

  Future<void> _openAnnouncement(Map<String, dynamic> row) async {
    await _markItemRead(row, 'school');
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _SchoolAnnouncementPage(announcement: row),
      ),
    );
  }

  Future<void> _openTransaction(
    Map<String, dynamic> data,
    Map<String, dynamic> row,
  ) async {
    final type = '${row['_notification_type']}';
    await _markItemRead(row, type);
    if (!mounted) return;
    final invoice = type == 'invoice';
    final total =
        num.tryParse('${row[invoice ? 'total' : 'amount']}')?.toDouble() ?? 0;
    final paidAmount = num.tryParse('${row['paid']}')?.toDouble() ?? 0;
    final paid = !invoice || (total > 0 && paidAmount >= total);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => workflow.BackendDataScope(
          data: data,
          child: workflow.WorkflowLanguageScope(
            language: _language,
            child: workflow.PaymentDetailPage(
              invoice: _plain(invoice ? row['invoice_no'] : row['receipt']),
              date: _plain(invoice ? row['invoice_date'] : row['paid_at']),
              status: paid
                  ? 'Paid'
                  : _plain(row['payment_status']).isEmpty
                  ? 'Pending'
                  : _plain(row['payment_status']),
              statusColor: paid
                  ? AppColors.colorFF43B76F
                  : AppColors.colorFFE59A23,
              description: _plain(
                invoice ? row['description'] : row['category'],
              ),
              amount: total,
              currency: _plain(row['currency']).isEmpty
                  ? 'USD'
                  : _plain(row['currency']),
              preInvoiceId: invoice ? _plain(row['id']) : '',
              canPay: invoice && !paid,
              releasedAt: _transactionDate(row),
              paidAt: _plain(row['paid_at']),
            ),
          ),
        ),
      ),
    );
  }
}

class _SchoolAnnouncementPage extends StatelessWidget {
  const _SchoolAnnouncementPage({required this.announcement});
  final Map<String, dynamic> announcement;

  String _plain(Object? value) => '${value ?? ''}'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();

  @override
  Widget build(BuildContext context) {
    final title = _plain(announcement['Title'] ?? 'School announcement');
    final description = _plain(announcement['Description']);
    final date = _plain(
      announcement['UpdatedAt'] ??
          announcement['updated_at'] ??
          announcement['created_at'],
    );
    final image = _plain(announcement['Image'] ?? announcement['Attachment']);
    return Scaffold(
      backgroundColor: AppColors.colorFF06254D,
      appBar: AppBar(
        title: const Text('School Announcement'),
        backgroundColor: AppColors.colorFF073B68,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: _activeGradient()),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            if (image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 220,
                  child: image.startsWith('data:image') && image.contains(',')
                      ? Image.memory(
                          base64Decode(image.substring(image.indexOf(',') + 1)),
                          fit: BoxFit.cover,
                        )
                      : image.startsWith('http')
                      ? Image.network(image, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/welcome-back.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.white54)),
            const Divider(height: 30, color: Colors.white24),
            Text(
              description.isEmpty ? 'No additional details.' : description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

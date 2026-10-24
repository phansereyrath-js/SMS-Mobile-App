part of '../workflows.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});
  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  final _attendance = AttendanceController();
  bool torchOn = false;
  bool get submitting => _attendance.submitting.value;
  String get message => _attendance.message.value;

  Future<void> _detected(BarcodeCapture capture) async {
    if (submitting) return;
    final value = capture.barcodes.isEmpty
        ? ''
        : (capture.barcodes.first.rawValue?.trim() ?? '');
    if (value.isEmpty) return;
    final result = await _attendance.record(value);
    if (!mounted || result == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Attendance recorded for ${result['date']} (${result['session']})',
        ),
        backgroundColor: AppColors.colorFF20A958,
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _attendance.onDelete();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: MobileScanner(
                  controller: controller,
                  onDetect: _detected,
                ),
              ),
              Positioned.fill(
                child: ColoredBox(color: AppColors.color44000000),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.colorFFD3A16E,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 36),
                    const _ScannerFrame(size: 250),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: const Icon(
                            Icons.add_photo_alternate_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 42),
                        IconButton(
                          onPressed: () async {
                            await controller.toggleTorch();
                            if (mounted) setState(() => torchOn = !torchOn);
                          },
                          icon: Icon(
                            torchOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: torchOn
                                ? AppColors.colorFFFFC14D
                                : Colors.white,
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
}

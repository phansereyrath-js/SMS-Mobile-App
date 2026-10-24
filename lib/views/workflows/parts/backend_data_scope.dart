part of '../workflows.dart';

class BackendDataScope extends InheritedWidget {
  final Map<String, dynamic> data;
  const BackendDataScope({super.key, required this.data, required super.child});
  static Map<String, dynamic> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BackendDataScope>()?.data ??
      const {};
  static Map<String, dynamic> student(BuildContext context) =>
      Map<String, dynamic>.from(of(context)['student'] as Map? ?? const {});
  static List<Map<String, dynamic>> list(BuildContext context, String key) =>
      (of(context)[key] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
  static List<Map<String, dynamic>> records(
    BuildContext context,
    String workflow,
  ) {
    final groups = of(context)['records'] as Map? ?? const {};
    return (groups[workflow] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  bool updateShouldNotify(BackendDataScope oldWidget) => oldWidget.data != data;
}

String backendAcademicYear(BuildContext context) {
  const workflows = [
    'setting-school',
    'academic-class-schedule',
    'academic-monthly',
    'academic-quarterly',
    'academic-semester',
  ];
  for (final workflow in workflows) {
    for (final row in BackendDataScope.records(context, workflow)) {
      final value = '${row['Academic Year'] ?? row['academic_year'] ?? ''}'
          .trim();
      if (value.isNotEmpty) return value;
    }
  }
  final now = DateTime.now();
  final start = now.month >= 6 ? now.year : now.year - 1;
  return '$start-${start + 1}';
}

Widget backendStudentPhoto(BuildContext context, {double size = 90}) {
  final photo = '${BackendDataScope.student(context)['photo'] ?? ''}'.trim();
  Widget fallback() => Image.asset(
    'assets/student-avatar.png',
    width: size,
    height: size,
    fit: BoxFit.cover,
  );
  if (photo.startsWith('data:image') && photo.contains(',')) {
    try {
      return Image.memory(
        base64Decode(photo.split(',').last),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback(),
      );
    } catch (_) {
      return fallback();
    }
  }
  if (photo.startsWith('http://') || photo.startsWith('https://')) {
    return Image.network(
      photo,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback(),
    );
  }
  return fallback();
}

Widget backendSchoolLogo({double size = 45}) {
  final url = MobileApi.baseUrl.replaceFirst(
    RegExp(r'api\.php.*$'),
    'assets/sr-logo.png',
  );
  return Image.network(
    url,
    width: size,
    height: size,
    fit: BoxFit.contain,
    errorBuilder: (_, _, _) => Image.asset(
      'assets/grandview-logo.jpg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    ),
  );
}

Widget backendDataImage(
  String value, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  Widget? fallback,
}) {
  final image = value.trim();
  Widget missing() => fallback ?? const SizedBox.shrink();
  if (image.startsWith('data:image') && image.contains(',')) {
    try {
      return Image.memory(
        base64Decode(image.split(',').last),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => missing(),
      );
    } catch (_) {
      return missing();
    }
  }
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return Image.network(
      image,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => missing(),
    );
  }
  return missing();
}

Map<String, dynamic> backendFirstRecord(BuildContext context, String workflow) {
  final rows = BackendDataScope.records(context, workflow);
  return rows.isEmpty ? const {} : rows.first;
}

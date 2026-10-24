part of '../workflows.dart';

class StudentReportPage extends StatefulWidget {
  const StudentReportPage({super.key});
  @override
  State<StudentReportPage> createState() => _StudentReportPageState();
}

class _StudentReportPageState extends State<StudentReportPage> {
  int period = 0;
  final feedback = TextEditingController();
  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brown = AppColors.primaryLight;
    final student = _StudentScope.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Report Student'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          Text(
            workflowText(context, "Track your child's study progress"),
            style: const TextStyle(fontSize: 9, color: Colors.white70),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorFFDED8D4),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: brown,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/student-avatar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        student.grade,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${workflowText(context, 'Student ID')}: ${student.studentId}',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => setState(() => period = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: period == i ? brown : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      workflowText(
                        context,
                        ['Monthly', 'Semester', 'Annually'][i],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: period == i ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _RankCard(
                  icon: Icons.menu_book_rounded,
                  color: brown,
                  title: 'Chinese English',
                  score: '96.00',
                  rank: '#2 / 40',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GradeReportsPage(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RankCard(
                  icon: Icons.auto_stories_rounded,
                  color: AppColors.colorFFD7A326,
                  title: 'Khmer',
                  score: '96.50',
                  rank: '#3 / 40',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GradeReportsPage(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorFFDED8D4),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workflowText(context, 'Student Evaluation'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const Divider(),
                _EvaluationRow(
                  'Responsibility',
                  'Excellent',
                  AppColors.colorFF279765,
                ),
                _EvaluationRow(
                  'Class participation',
                  'Very good',
                  AppColors.colorFF3A8FC3,
                ),
                _EvaluationRow(
                  'Homework quality',
                  'Good',
                  AppColors.colorFFD39820,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorFFDED8D4),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      workflowText(context, "Teacher's Evaluation"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      workflowText(context, 'July 24, 2026'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ColoredBox(
                  color: AppColors.colorFFFFF7EF,
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Text(
                      workflowText(
                        context,
                        'The student has shown excellent progress, participates actively, and demonstrates a positive attitude toward learning.',
                      ),
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorFFDED8D4),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workflowText(context, 'Parent Feedback'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: feedback,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    hintText: workflowText(context, 'Write your comment here…'),
                    hintStyle: const TextStyle(fontSize: 9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          workflowText(context, 'Feedback submitted'),
                        ),
                      ),
                    ),
                    style: FilledButton.styleFrom(backgroundColor: brown),
                    child: Text(
                      workflowText(context, 'Submit Feedback'),
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

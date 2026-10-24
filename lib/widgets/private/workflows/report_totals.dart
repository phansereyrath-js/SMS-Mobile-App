part of '../../../views/workflows/workflows.dart';

class _ReportTotals extends StatelessWidget {
  const _ReportTotals();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    color: AppColors.colorFFFFF7EF,
    child: const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Score', style: TextStyle(fontSize: 9)),
            Text('1000', style: TextStyle(fontSize: 9)),
            Text('Grade: A+', style: TextStyle(fontSize: 9)),
          ],
        ),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Average', style: TextStyle(fontSize: 9)),
            Text('100.0', style: TextStyle(fontSize: 9)),
            Text('GPA: 4.00', style: TextStyle(fontSize: 9)),
          ],
        ),
      ],
    ),
  );
}

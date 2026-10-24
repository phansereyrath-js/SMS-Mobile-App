part of '../../../views/workflows/workflows.dart';

class _ReportTile extends StatelessWidget {
  final String title, date, score;
  final VoidCallback onTap;
  const _ReportTile({
    required this.title,
    required this.date,
    required this.score,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.colorFFE8E1DC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primaryLight,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workflowText(context, title),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  workflowText(context, date),
                  style: const TextStyle(fontSize: 8, color: Colors.black45),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.colorFFF0E6DC,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score,
              style: const TextStyle(
                color: AppColors.primaryLight,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

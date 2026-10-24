part of '../../../views/workflows/workflows.dart';

class _ClassCount extends StatelessWidget {
  final IconData icon;
  final String count, label;
  const _ClassCount(this.icon, this.count, this.label);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 7),
          Column(
            children: [
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                workflowText(context, label),
                style: const TextStyle(color: Colors.white70, fontSize: 7),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

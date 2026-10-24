part of '../../../views/workflows/workflows.dart';

class _RankCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, score, rank;
  final VoidCallback onTap;
  const _RankCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.score,
    required this.rank,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colorFFFFFBF6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 13),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  workflowText(context, title),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 14),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflowText(context, 'AVG Point'),
                      style: const TextStyle(fontSize: 7),
                    ),
                    Text(
                      score,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflowText(context, 'Rank'),
                      style: const TextStyle(fontSize: 7),
                    ),
                    Text(
                      rank,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

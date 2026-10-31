part of '../../../views/workflows/workflows.dart';

class _InnerHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool filter;
  const _InnerHeader({required this.title, this.filter = false});
  @override
  Size get preferredSize => const Size.fromHeight(58);
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.chevron_left_rounded,
        color: AppColors.schoolDarkAccent,
      ),
    ),
    titleSpacing: 0,
    title: Text(
      workflowText(context, title),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    ),
    actions: filter
        ? [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded, size: 15),
                label: Text(workflowText(context, 'Filter')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.schoolDarkAccent,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ]
        : null,
  );
}

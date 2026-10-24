part of '../../../views/workflows/workflows.dart';

class _ReportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ReportButton(this.label, this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => Expanded(
    child: FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13),
      label: Text(
        workflowText(context, label),
        style: const TextStyle(fontSize: 8),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}

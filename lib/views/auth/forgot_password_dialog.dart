part of '../../app.dart';

Future<void> _forgotDialog(BuildContext context) async {
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset password'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'Enter your email'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset instructions requested.'),
              ),
            );
          },
          child: const Text('Send'),
        ),
      ],
    ),
  );
  controller.dispose();
}

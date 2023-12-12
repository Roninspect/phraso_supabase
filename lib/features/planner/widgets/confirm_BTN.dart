import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmButton extends ConsumerWidget {
  final VoidCallback onTap;
  const ConfirmButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          backgroundColor: Colors.green,
          side: const BorderSide(width: 2)),
      onPressed: onTap,
      child: const Text(
        "Confirm",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

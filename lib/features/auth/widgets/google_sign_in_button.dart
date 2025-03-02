import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/shared/loader.dart';

import '../controller/auth_controller.dart';

class GoogleButton extends ConsumerWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(authControllerProvider);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(280, 50), side: const BorderSide(width: 1.5)),
      onPressed: () async {
        ref.watch(authControllerProvider.notifier).singInWithGoogle(context);
      },
      child: isLoading
          ? loader()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 30, child: Image.asset('assets/images/google.png')),
                const Text(
                  "Continue With Google",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
    );
  }
}

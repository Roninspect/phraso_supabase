import 'package:flutter/material.dart';

showSnackbar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(text)));
}

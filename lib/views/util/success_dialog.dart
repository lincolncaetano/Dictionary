import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message;

  SuccessDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 48),
          SizedBox(height: 16),
          Text(message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

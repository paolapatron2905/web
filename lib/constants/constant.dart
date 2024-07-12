import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [client] for Supabase instance
final client = Supabase.instance.client;

/// small Gap
const smallGap = SizedBox(
  height: 15,
);

/// large Gap

const largeGap = SizedBox(
  height: 30,
);

/// Custom SnackBar
extension ShowSnackBar on BuildContext {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

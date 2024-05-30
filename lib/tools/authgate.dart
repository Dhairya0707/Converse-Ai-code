import 'package:converse_ai/screen/auth.dart';
import 'package:converse_ai/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final user = supabase.auth.currentUser;

        if (user != null) {
          return const MyHomePage(); // Replace with your desired widget
        } else {
          return const Authscreen();
        }
      },
    );
  }
}

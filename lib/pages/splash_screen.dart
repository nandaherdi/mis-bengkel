import 'dart:io';

import 'package:flutter/material.dart';

import '../auth/login/auth_state.dart';
import '../connection/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends AuthState<SplashScreen> {
  @override
  void initState() {
    _connectionCheck();
    recoverSupabaseSession();
    super.initState();
  }

  _connectionCheck() async {
    final res = await supabase.from('service').select('*').execute();
    print("error checkk connection");
    print(res.error);
    if (res.error != null) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text("oke"),
                ),
              ],
              content: Text(
                  "Maaf, anda harus terhubung ke internet untuk bisa menggunakan aplikasi ini"),
            );
          });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

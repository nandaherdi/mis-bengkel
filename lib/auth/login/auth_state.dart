import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../connection/constants.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
//ngambil hasil recover session dari splash_screen.dart atau login, jika gagal direcover, akan diarahkan ke login
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
//------------------------/\---------------------------------------------------------------------------------------

//ngambil hasil recover session dari splash_screen.dart atau login, jika berhasil direcover, akan dicek role userSessionnya, lalu diarahkan sesuai dengan rolenya
  @override
  void onAuthenticated(Session session) {
    print("current role");
    print(supabase.auth.currentUser!.userMetadata['role']);
    if (mounted) {
      if (supabase.auth.currentUser!.userMetadata['role'] == 'customer') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/navbar', (route) => false);
      } else if (supabase.auth.currentUser!.userMetadata['role'] == 'mra') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/mranavbar', (route) => false);
      }
    }
  }
//-------------------------/\--------------------------------------------------------------------------------------------------------------------------------------

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}

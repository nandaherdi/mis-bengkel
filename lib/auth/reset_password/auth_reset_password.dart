import 'package:flutter/material.dart';
import 'package:mis_bengkel/connection/constants.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResetPassword<T extends StatefulWidget> extends SupabaseAuthState<T> {
//ngambil hasil dari customer/mra klik link reset password di email. jika token gagal didapat, akan diarahkan ke splash_screen.dart dan ditampilkan pesan error
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Gagal reset Password"),
            );
          });
    }
  }
//--------------------------------------------/\-----------------------------------------------------------------------------------------------------------------

//ngambil hasil dari customer/mra klik link reset password di email. jika token berhasil didapat, akan diarahkan ke new_password_page.dart
  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/newpassword', (route) => false);
    }
  }
//----------------------------------------------/\--------------------------------------------------------------------------------------

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}

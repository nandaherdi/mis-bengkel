import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../connection/constants.dart';
import 'auth_reset_password.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends AuthResetPassword<ResetPasswordPage> {
  late final TextEditingController _emailController;

  bool _isLoading = false;

//------------------\/Function send link reset password\/-----------------------
  Future<void> _sendResetPasswordLink() async {
    setState(() {
      _isLoading = true;
    });

    final res = await supabase.auth.signIn(
        email: _emailController.text,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterquickstart://login-callback/'));
    final error = res.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "Link reset password sudah dikirim. Silahkan cek email Anda"),
            );
          });
    }

    setState(() {
      _isLoading = false;
    });
  }
//------------------/\Function send link reset password/\-----------------------

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 50,
          right: 20,
          left: 20,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              //color: Colors.red,
              child: Text(
                "Masukkan Email Anda",
                style: GoogleFonts.roboto(
                    fontSize: 20, color: Color.fromARGB(255, 17, 52, 82)),
                textAlign: TextAlign.left,
              ),
            ),
            Center(
                child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _sendResetPasswordLink();
                      },
                      child: Text(_isLoading
                          ? "Loading"
                          : "Send Change Password Request Link"))
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}

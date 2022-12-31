import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bottom_navigation_bar.dart';
import '../../connection/constants.dart';
import '../../mra_bottom_navigation_bar.dart';
import '../../pages/customer/signup_page.dart';
import '../reset_password/reset_password_page.dart';
import 'auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _passwordVisible = true;
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      if (response.data!.user!.userMetadata['role'] == 'customer') {
        print(response.data!.user!.userMetadata['role']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottNavBar()),
        );
      } else if (response.data!.user!.userMetadata['role'] == 'mra') {
        print(response.data!.user!.userMetadata['role']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MRABottNavBar()),
        );
      }

      _emailController.clear();
      _passwordController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(right: 35, left: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Login',
                style: GoogleFonts.roboto(
                  color: Color.fromARGB(255, 17, 52, 82),
                  fontSize: 40,
                ),
              ),
            ),
            Center(
              child: Text(
                'Anda belum login',
                style: GoogleFonts.roboto(
                  color: Color.fromARGB(255, 175, 175, 175),
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 50),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_passwordVisible,
              controller: _passwordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: Theme.of(context).primaryColorDark,
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                labelText: "Password",
              ),
            ),
            Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordPage()),
                    );
                  },
                  child: Text("Forgot Password?"),
                )),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isLoading ? null : _signIn,
              child: Text(_isLoading ? 'Loading' : 'Sign In'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Belum memiliki akun?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text("Sign Up"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

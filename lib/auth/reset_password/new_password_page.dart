import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../connection/constants.dart';
import '../login/login_page.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool _passwordVisible = true;
  bool _isLoading = false;
  late final TextEditingController _passwordController;
  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final res = await supabase.auth.api.updateUser(
      supabase.auth.currentSession!.accessToken,
      UserAttributes(password: _passwordController.text),
    );
    print("password");
    print(_passwordController.text);
    print("data ubah password");
    print(res.data);
    print("error change password");
    print(res.error);
    final error = res.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "Password berhasil diubah. Silahkan login ulang dengan password baru"),
              actions: [
                TextButton(
                  child: Text("oke"),
                  onPressed: () async {
                    final outres = await supabase.auth.signOut();
                    if (outres.error == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      context.showErrorSnackBar(
                          message: outres.error.toString());
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BottNavBar()),
                    // );
                  },
                )
              ],
            );
          });
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
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 10,
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
                "New",
                style: GoogleFonts.roboto(
                    fontSize: 20, color: Color.fromARGB(255, 17, 52, 82)),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Password",
                style: GoogleFonts.roboto(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 17, 52, 82),
                ),
              ),
            ),
            Center(
                child: Container(
              child: Column(
                children: [
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
                  ElevatedButton(
                      onPressed: () {
                        _resetPassword();
                      },
                      child: Text(_isLoading ? "Loading" : "Reset Password"))
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}

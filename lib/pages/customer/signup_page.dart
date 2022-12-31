import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mis_bengkel/connection/constants.dart';
import 'package:supabase/supabase.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/login/auth_state.dart';
import '../../auth/login/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends AuthState<SignUpPage> {
  bool _passwordVisible = true;
  bool _isLoading = false;
  late final TextEditingController _namaDepanController;
  late final TextEditingController _namaBelakangController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _tipeKendaraanController;
  late final TextEditingController _platNomorController;
  late final TextEditingController _nomorMesinController;
  late final TextEditingController _tahunKendaraanController;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    if (_namaDepanController.text.isEmpty ||
        _namaBelakangController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _tipeKendaraanController.text.isEmpty ||
        _platNomorController.text.isEmpty ||
        _nomorMesinController.text.isEmpty ||
        _tahunKendaraanController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return context.showErrorSnackBar(
          message: "silahkan lengkapi data signup");
    } else if (_namaDepanController.text.isNotEmpty ||
        _namaBelakangController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty ||
        _tipeKendaraanController.text.isNotEmpty ||
        _platNomorController.text.isNotEmpty ||
        _nomorMesinController.text.isNotEmpty ||
        _tahunKendaraanController.text.isNotEmpty) {
      if (int.tryParse(_tahunKendaraanController.text) != null &&
          int.tryParse(_tahunKendaraanController.text)! > 0) {
        final getEmail = await supabase.from('customer').select('email').match(
            {'email': _emailController.text}).execute(count: CountOption.exact);
        final responseGetEmail = getEmail.count;
        print("response get email");
        print(responseGetEmail);
        if (responseGetEmail == 0) {
          final responseSignupAuth = await supabase.auth.signUp(
              _emailController.text, _passwordController.text,
              userMetadata: {
                'role': 'customer',
                'fName': _namaDepanController.text.toString(),
              });
          final error = responseSignupAuth.error;
          if (error != null) {
            print("error message signup auth");
            print(error);
            setState(() {
              _isLoading = false;
            });
            return context.showErrorSnackBar(message: error.message);
          } else {
            print("success message signup auth");
            print(responseSignupAuth.data);
            print("error message signup auth");
            print(error);
            final responseSignupPublic =
                await supabase.from('customer').insert({
              'fName': _namaDepanController.text.toString(),
              'lName': _namaBelakangController.text.toString(),
              'email': _emailController.text.toString(),
              'vehicle': _tipeKendaraanController.text.toString(),
              'policeNo': _platNomorController.text.toUpperCase().toString(),
              'vehicleNo': _nomorMesinController.text.toString(),
              'vehicleYear': int.parse(_tahunKendaraanController.text),
            }).execute();
            final errorSignupPublic = responseSignupPublic.error;
            if (errorSignupPublic != null) {
              print("error message signup public");
              print(errorSignupPublic);
              setState(() {
                _isLoading = false;
              });
              return context.showErrorSnackBar(
                  message: errorSignupPublic.message);
            } else {
              print("success message signup public");
              print(responseSignupPublic.data);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        margin: EdgeInsets.only(top: 40),
                        height: 60,
                        width: 170,
                        //color: Colors.red,
                        child: Center(
                          child: Text(
                            "Email verifikasi telah terkirim, silahkan cek email",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      actions: [
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text("oke")),
                        )
                      ],
                    );
                  });
            }
            //print(response.data);

            _emailController.clear();
            _passwordController.clear();
          }
        } else if (responseGetEmail != 0) {
          setState(() {
            _isLoading = false;
          });
          return context.showErrorSnackBar(
              message: "customer with this email is already exist");
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        return context.showErrorSnackBar(
            message: "tahun kendaraan harus diisi angka lebih dari 0");
      }
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _namaDepanController = TextEditingController();
    _namaBelakangController = TextEditingController();
    _tipeKendaraanController = TextEditingController();
    _platNomorController = TextEditingController();
    _nomorMesinController = TextEditingController();
    _tahunKendaraanController = TextEditingController();
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(right: 35, left: 35),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            //padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            children: [
              Center(
                child: Text(
                  'Selamat Datang',
                  style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 17, 52, 82),
                    fontSize: 40,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Daftarkan akunmu terlebih dahulu',
                  style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 175, 175, 175),
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _namaDepanController,
                decoration: const InputDecoration(
                  labelText: 'Nama Depan',
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _namaBelakangController,
                decoration: const InputDecoration(
                  labelText: 'Nama Belakang',
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
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
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _tipeKendaraanController,
                decoration: const InputDecoration(
                  labelText: 'Tipe Kendaraan',
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _platNomorController,
                decoration: const InputDecoration(
                  labelText: 'Plat Nomor',
                ),
              ),
              TextFormField(
                controller: _nomorMesinController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Mesin',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _tahunKendaraanController,
                decoration: const InputDecoration(
                  labelText: 'Tahun Kendaraan',
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: Text(_isLoading ? 'Loading' : 'Sign Up'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah memiliki akun?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text("Login"),
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}

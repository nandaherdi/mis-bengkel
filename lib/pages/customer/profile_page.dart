import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/login/login_page.dart';
import '../../auth/reset_password/auth_reset_password.dart';
import '../../connection/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends AuthResetPassword<ProfilePage> {
  //String? fName;
  late final TextEditingController _jarakTempuhHarianController;

  bool _isLoading = false;
  Future refresh() async {
    setState(() {});
  }

  Future<void> _sendResetPasswordLink() async {
    _isLoading = true;
    //setState(() {});
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 50,
            width: 50,
            child: AlertDialog(
              content: LinearProgressIndicator(
                color: Colors.blue,
                //strokeWidth: 10,
              ),
            ),
          );
        });

    // CircularProgressIndicator(
    //   color: Colors.blue,
    //   strokeWidth: 10,
    // );

    final res = await supabase.auth.signIn(
        email: supabase.auth.currentUser!.email,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterquickstart://login-callback/'));
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
                  "Link reset password sudah dikirim. Silahkan cek email Anda"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("oke"))
              ],
            );
          });
    }
    _isLoading = false;
    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _jarakTempuhHarianController = TextEditingController();
    });
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<dynamic>>(
            future: getCustomerData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top + 10,
                      right: 20,
                      left: 20,
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Profil",
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
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.lightBlue)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Nama",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade500),
                                            ),
                                            Text(
                                              "${snapshot.data![0]['fName']} ${snapshot.data![0]['lName']}",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 17, 52, 82)),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.lightBlue)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Email:",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade500),
                                            ),
                                            Text(
                                              snapshot.data![0]['email'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 17, 52, 82)),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 30),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.lightBlue)),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Jarak Tempuh Harian:",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                Container(
                                                  width: 90,
                                                  child: TextButton(
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      _jarakTempuhHarianController
                                                          .text = snapshot.data![
                                                              0][
                                                              'jarakTempuhHarian']
                                                          .toString();
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content:
                                                                  Container(
                                                                height: 70,
                                                                child: Column(
                                                                  children: [
                                                                    TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      controller:
                                                                          _jarakTempuhHarianController,
                                                                      //initialValue: "asd",
                                                                      decoration:
                                                                          InputDecoration(
                                                                        label: Text(
                                                                            "Jarak Tempuh Harian (KM)"),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    TextButton(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await updatejarakTempuhHarian();
                                                                      },
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                              "${snapshot.data![0]['jarakTempuhHarian']} KM",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 17, 52, 82)),
                                            ),
                                          ],
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: ExpansionTile(
                                        textColor: Colors.white,
                                        collapsedTextColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        iconColor: Colors.white,
                                        title: Text("Kendaraan"),
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "Tipe Mobil",
                                              style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: Text(
                                              snapshot.data![0]['vehicle'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Plat Nomor",
                                              style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: Text(
                                              snapshot.data![0]['policeNo'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Nomor Mesin",
                                              style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: Text(
                                              snapshot.data![0]['vehicleNo'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Tahun Kendaraan",
                                              style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: Text(
                                              snapshot.data![0]['vehicleYear']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange),
                                      onPressed: () {
                                        _sendResetPasswordLink();
                                      },
                                      child: Text(_isLoading
                                          ? "Loading"
                                          : "Reset Password"),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () async {
                                          final outres =
                                              await supabase.auth.signOut();
                                          if (outres.error == null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()),
                                            );
                                          } else {
                                            context.showErrorSnackBar(
                                                message:
                                                    outres.error.toString());
                                          }
                                        },
                                        child: Text("Logout"))
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Text("Data tidak ditemukan");
              }
            }));
  }

  updatejarakTempuhHarian() async {
    if (_jarakTempuhHarianController.text.isEmpty) {
      return context.showErrorSnackBar(
          message: "pastikan semua data sudah diisi dengan lengkap");
    } else if (_jarakTempuhHarianController.text.isNotEmpty) {
      if (int.tryParse(_jarakTempuhHarianController.text) == null) {
        return context.showErrorSnackBar(
            message: "jarak tempuh harian hanya bisa diisi angka");
      } else {
        if (int.tryParse(_jarakTempuhHarianController.text)! <= 0) {
          return context.showErrorSnackBar(
              message: "jarak tempuh harian harus lebih dari 0");
        } else {
          final res = await supabase.from('customer').update({
            'jarakTempuhHarian': int.parse(_jarakTempuhHarianController.text),
          }).match({'email': supabase.auth.currentUser!.email}).execute();
          if (res.hasError) {
            return context.showErrorSnackBar(message: res.error.toString());
          } else {
            setState(() {
              Navigator.of(context).pop();
            });
          }
        }
      }
    }
  }
}

Future<List<dynamic>> getCustomerData() async {
  print("current email");
  print(supabase.auth.currentUser!.email);
  final res = await supabase
      .from('customer')
      .select('*')
      .match({'email': supabase.auth.currentUser!.email}).execute();
  List<dynamic> data = res.data;
  print("profil data");
  print(res.data);

  return data;
}

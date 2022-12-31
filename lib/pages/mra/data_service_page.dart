import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/login/login_page.dart';
import '../../connection/constants.dart';

class DataServicePage extends StatefulWidget {
  const DataServicePage({super.key});

  @override
  State<DataServicePage> createState() => _DataServicePageState();
}

class _DataServicePageState extends State<DataServicePage> {
  late final TextEditingController _serviceIdController;
  late final TextEditingController _serviceNameController;
  late final TextEditingController _jarakTempuhController;
  @override
  void initState() {
    super.initState();
    _jarakTempuhController = TextEditingController();
    _serviceIdController = TextEditingController();
    _serviceNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _jarakTempuhController.text = '';
            _serviceIdController.text = '';
            _serviceNameController.text = '';
          });
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    height: 200,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _serviceIdController,
                          decoration:
                              InputDecoration(label: Text("Service ID")),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: _serviceNameController,
                          decoration:
                              InputDecoration(label: Text("Service Name")),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _jarakTempuhController,
                          //initialValue: "asd",
                          decoration: InputDecoration(
                            label: Text("Jarak Tempuh (KM)"),
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            final insert = await insertServiceData();
                          },
                        ),
                      ],
                    )
                  ],
                );
              });
        },
        child: Text("+"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top,
            right: 20,
            left: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Text(
                    "Data",
                    style: GoogleFonts.roboto(
                        fontSize: 20, color: Color.fromARGB(255, 17, 52, 82)),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width / 2,
                      //color: Colors.red,
                      child: Text(
                        "Service",
                        style: GoogleFonts.roboto(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 52, 82),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        child: Text("Logout"),
                        onPressed: () async {
                          final outres = await supabase.auth.signOut();
                          if (outres.error == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          } else {
                            context.showErrorSnackBar(
                                message: outres.error.toString());
                          }
                        })
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 172,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<List<dynamic>>(
                    future: getServiceData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ExpansionTile(
                                collapsedBackgroundColor: Colors.grey.shade200,
                                title:
                                    Text(snapshot.data![index]['serviceName']),
                                subtitle:
                                    Text(snapshot.data![index]['serviceId']),
                                leading: Container(
                                  height: 50,
                                  width: 100,
                                  child: Center(
                                    child: Text(snapshot.data![index]
                                            ['jarakTempuh']
                                        .toString()),
                                  ),
                                ),
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              20,
                                          height: 50,
                                          color: Colors.red,
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Anda yakin ingin menghapus ${snapshot.data![index]['serviceName']}?"),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            final checkServiceDataOnAnotherTable = await supabase
                                                                .from(
                                                                    'detail_service_customer')
                                                                .select(
                                                                    'serviceId')
                                                                .match({
                                                              'serviceId':
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'serviceId']
                                                            }).execute(
                                                                    count: CountOption
                                                                        .exact);
                                                            if (checkServiceDataOnAnotherTable
                                                                    .count! >
                                                                0) {
                                                              return showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content: Text(
                                                                          "Hapus ${snapshot.data![index]['serviceName']} gagal dilakukan karena data ${snapshot.data![index]['serviceName']} dipakai di Detail Service Customer. Silahkan hapus ${snapshot.data![index]['serviceName']} dari semua Detail Service Customer, lalu coba hapus ${snapshot.data![index]['serviceName']} lagi."),
                                                                      actions: [
                                                                        TextButton(
                                                                          child:
                                                                              Text("oke"),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              Navigator.of(context).pop();
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                          },
                                                                        )
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              print(
                                                                  "selected data");
                                                              print(snapshot
                                                                          .data![
                                                                      index][
                                                                  'serviceId']);
                                                              final delete =
                                                                  await deleteServiceData(snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'serviceId']
                                                                      .toString());
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              20,
                                          height: 50,
                                          color: Colors.lightBlue,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          _jarakTempuhController.text = snapshot
                                              .data![index]['jarakTempuh']
                                              .toString();
                                          _serviceIdController.text = snapshot
                                              .data![index]['serviceId']
                                              .toString();
                                          _serviceNameController.text = snapshot
                                              .data![index]['serviceName']
                                              .toString();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Container(
                                                    height: 200,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            color: Colors.grey,
                                                          ),
                                                          enabled: false,
                                                          controller:
                                                              _serviceIdController,
                                                          decoration:
                                                              InputDecoration(
                                                                  label: Text(
                                                                      "Service ID")),
                                                        ),
                                                        TextFormField(
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .words,
                                                          controller:
                                                              _serviceNameController,
                                                          decoration:
                                                              InputDecoration(
                                                                  label: Text(
                                                                      "Service Name")),
                                                        ),
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              _jarakTempuhController,
                                                          //initialValue: "asd",
                                                          decoration:
                                                              InputDecoration(
                                                            label: Text(
                                                                "Jarak Tempuh (KM)"),
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
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                          onPressed: () async {
                                                            final update =
                                                                await updateServiceData();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Text("data tidak ditemukan");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateServiceData() async {
    if (_serviceNameController.text.isEmpty ||
        _jarakTempuhController.text.isEmpty) {
      return context.showErrorSnackBar(
          message: "pastikan semua data sudah diisi dengan lengkap");
    } else if (_serviceNameController.text.isNotEmpty &&
        _jarakTempuhController.text.isNotEmpty) {
      if (int.tryParse(_jarakTempuhController.text) != null &&
          int.tryParse(_jarakTempuhController.text)! > 0) {
        final res = await supabase.from('service').update({
          'serviceName': _serviceNameController.text,
          'jarakTempuh': int.parse(_jarakTempuhController.text),
        }).match({'serviceId': _serviceIdController.text}).execute();
        if (res.hasError) {
          return context.showErrorSnackBar(message: res.error.toString());
        } else {
          setState(() {
            Navigator.of(context).pop();
          });
        }
      } else {
        return context.showErrorSnackBar(
            message: "jarak tempuh hanya bisa diisi angka lebih dari 0");
      }
    }
  }

  insertServiceData() async {
    if (_serviceNameController.text.isEmpty ||
        _jarakTempuhController.text.isEmpty) {
      return context.showErrorSnackBar(
          message: "pastikan semua data sudah diisi dengan lengkap");
    } else if (_serviceNameController.text.isNotEmpty &&
        _jarakTempuhController.text.isNotEmpty) {
      if (int.tryParse(_jarakTempuhController.text) == null) {
        return context.showErrorSnackBar(
            message: "jarak tempuh hanya bisa diisi angka");
      } else {
        final res = await supabase.from('service').insert({
          'serviceId': _serviceIdController.text,
          'serviceName': _serviceNameController.text,
          'jarakTempuh': int.parse(_jarakTempuhController.text),
        }).execute();
        if (res.hasError) {
          print("response code");
          print(res.status);
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

Future<List<dynamic>> getServiceData() async {
  final res = await supabase.from('service').select('*').execute();
  return res.data;
}

deleteServiceData(serviceData) async {
  String ?? serviceData;
  print("sevicedata");
  print(serviceData);
  final res = await supabase
      .from('service')
      .delete()
      .match({'serviceId': serviceData}).execute();
}

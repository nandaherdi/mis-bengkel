//import 'package:customer_engagement_app/pages/test.dart';
//import 'package:customer_engagement_app/utils/constants.dart';
//import 'package:customer_engagement_app/widget/card_antrian_widget.dart';
//import 'package:customer_engagement_app/widget/checkbox_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:supabase/supabase.dart';

import '../../bottom_navigation_bar.dart';
import '../../connection/constants.dart';
import '../../widgets/queue_card_widget.dart';
import 'history_service_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static List<dynamic> dataService = [];

  final _textKMController = TextEditingController();

  DateTime? date;
  TimeOfDay? time;

//--------\/Function Mengambil Value Tanggal yang dipilih customer dari datepicker\/--------
  String getDateText() {
    if (date == null) {
      String DateText = "tanggal kedatangan";
      return DateText;
    } else {
      //String DateText = '${date!.year}-0${date!.month}-${date!.day}';
      String DateText = DateFormat('yyyy-MM-dd').format(date!).toString();
      return DateText;
    }
  }
//--------/\Function Mengambil Value Tanggal yang dipilih customer dari datepicker/\--------

  //String getCurrentUser() {}

//--------\/Function Mengambil Value waktu yang dipilih customer dari timepicker\/--------
  String getTimeText() {
    if (time == null) {
      String TimeText = "waktu kedatangan";
      return TimeText;
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');
      String TimeText = '${hours}:${minutes}:00';
      return TimeText;
    }
  }
//--------/\Function Mengambil Value waktu yang dipilih customer dari timepicker/\--------

//--------\/Function Mengambil Value KM Kendaraan yang diinput customer di text field\/--------
  String getKMText() {
    if (_textKMController.text == null) {
      String kmText = "";
      return kmText;
    } else {
      String kmText = _textKMController.text;
      return kmText;
    }
  }
//--------/\Function Mengambil Value KM Kendaraan yang diinput customer di text field/\--------

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

//---------------\/Button tambah\/----------------------------------------------
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final resultDetailServiceCustomerData =
                await insertDetailServiceCustomerData();
            print(resultDetailServiceCustomerData);
          },
          child: const Text("tambah"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//---------------/\Button tambah/\----------------------------------------------

        body: Container(
          //height: ,
          //color: Colors.red,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 10,
            right: 20,
            left: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
//-----------------\/HEADER\/-------------------------------------------------------
                Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Text(
                    "Booking",
                    style: GoogleFonts.roboto(
                        fontSize: 20, color: Color.fromARGB(255, 17, 52, 82)),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
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
//--------------------/\Header/\----------------------------------------------------------

//--------------\/CARD ANTRIAN\/----------------------------------------------------
                QueueWidget(
                  bookedColor: bookedColor,
                  onProccessColor: onProccessColor,
                  waitingColor: waitingColor,
                ),
//--------------/\CARD ANTRIAN/\-------------------------------------------------------

//----------------\/BUTTON GET DATE\/-----------------------------------------------
                GestureDetector(
                    onTap: () {
                      pickDate(context);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        width: 336,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10.0,
                              offset: Offset(0, 5),
                              spreadRadius: 0.1,
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            child: Text(
                              getDateText(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))),
//------------------------/\BUTTON GET DATE/\------------------------------------------------------

//-----------------\/BUTTON GET TIME\/----------------------------------------------
                GestureDetector(
                    onTap: () {
                      pickTime(context);
                      FutureBuilder<List<dynamic>>(
                          future: getServiceData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print("sata service dalam future builder");
                              print(dataService);
                              return Container();
                            } else {
                              return Text(snapshot.error.toString());
                            }
                          });
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 40,
                        width: 336,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10.0,
                              offset: Offset(0, 5),
                              spreadRadius: 0.1,
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            child: Text(
                              getTimeText(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))),
//------------------------/\BUTTON GET TIME/\------------------------------------------------------

//-----------------------\/Field KM Kendaraan\/---------------------------------
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _textKMController,
                    decoration: const InputDecoration(
                        labelText: 'Masukkan KM kendaraan'),
                  ),
                ),
//-----------------------/\Field KM Kendaraan/\---------------------------------

                Container(
                    //color: Colors.amber,
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 336,
                      height: 30,
                      //color: Colors.amber,
                      child: Text(
                        "Pilih Sparepart/Servis:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),

//--------------------------\/Checkbox List\/-----------------------------------
                    Container(
                        //color: Colors.amber,
                        width: 336,
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: dataService.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(dataService[index]['serviceName']),
                              value: dataService[index]['value'],
                              onChanged: (value) {
                                setState(() {
                                  dataService[index]['value'] = value!;
                                  print(dataService[index]['serviceName']);
                                  print(dataService[index]['value']);
                                });
                              },
                            );
                          },
                        )),
//--------------------------/\Checkbox List/\-----------------------------------
                  ],
                )),
              ],
            ),
          ),
        ));
  }

//----------------\/Function Show DatePicker\/----------------------------------
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 5));

    setState(() => date = newDate);
  }
//----------------\/Function Show DatePicker\/----------------------------------

//----------------\/Function Show TimePicker\/----------------------------------
  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 12, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    setState(() => time = newTime);
  }
//----------------/\Function Show TimePicker/\----------------------------------

//------------------\/Function  Select Date Service from Database\/-------------
  Future<List<dynamic>> getServiceData() async {
    print("sebeluh perubahan data");
    print(dataService);

    final res = await supabase
        .from('service')
        .select()
        .order('serviceId', ascending: true)
        .execute();
    List<dynamic> data = res.data;

    print("start giving data");
    dataService = res.data;
    for (var i = 0; i < dataService.length; i++) {
      dataService[i]["value"] = false;
    }
    print("end giving data");
    print(dataService);

    return dataService;
  }
//------------------/\Function  Select Date Service from Database/\-------------

//--------------------\/Function Insert to Table service_customer\/-------------
  // insertServiceCustomerData() async {
  //   final res = await supabase.from('service_customer').insert([
  //     {
  //       'status': 'booked',
  //       'email': supabase.auth.currentUser!.email.toString(),
  //       "bookingDate": '${getDateText()} ${getTimeText()}',
  //       'kmKendaraan': _textKMController.text,
  //     }
  //   ]).execute();
  //   print("insertservicecustomerdata error");
  //   print(res.error);
  //   print("date and time");
  //   print("date: ${getDateText()}, time: ${getTimeText()}");
  //   print("hasil insertServiceCustomerData");
  //   print(res.data);
  //   if (res.data != null) {
  //     return res.data;
  //   } else if (res.data == null) {
  //     return context.showErrorSnackBar(message: res.error.toString());
  //   }
  // }
//--------------------/\Function Insert to Table service_customer/\-------------

//--------------------\/Function Insert to Table service_customer then to detail_service_customer\/-------------
  insertDetailServiceCustomerData() async {
    for (var i = 0; i < dataService.length;) {
      if (dataService[i]["value"] == false) {
        dataService.removeAt(i);
      } else if (dataService[i]["value"] == true) {
        i++;
      }
    }
    if (date == null ||
        time == null ||
        _textKMController.text.isEmpty ||
        dataService.length == 0) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "Silahkan lengkapi data booking. Pilih minimal satu spare part/servis."),
            );
          });
    } else if ((date != null ||
        time != null ||
        _textKMController.text.isNotEmpty ||
        dataService.length > 0)) {
      if ((DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Monday" ||
                  DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Tuesday" ||
                  DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Wednesday" ||
                  DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Thursday" ||
                  DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Friday") &&
              (DateTime.parse('${getDateText()} ${getTimeText()}')
                      .isBefore(DateTime.parse('${getDateText()} 08:00:00')) ||
                  DateTime.parse('${getDateText()} ${getTimeText()}')
                      .isAfter(DateTime.parse('${getDateText()} 14:00:00'))) ||
          (DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Saturday" ||
                  DateFormat('EEEE').format(DateTime.parse(getDateText())) ==
                      "Sunday") &&
              (DateTime.parse('${getDateText()} ${getTimeText()}')
                      .isBefore(DateTime.parse('${getDateText()} 08:00:00')) ||
                  DateTime.parse('${getDateText()} ${getTimeText()}')
                      .isAfter(DateTime.parse('${getDateText()} 12:00:00')))) {
        return context.showErrorSnackBar(
            message:
                "maaf, waktu yang anda tentukan di luar jam operasional bengkel");
      } else {
        if (int.tryParse(_textKMController.text) != null &&
            int.tryParse(_textKMController.text)! > 0) {
          print("setelah dihapus yang false");
          print(dataService);

          late List<dynamic> selectedDataService = [
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {}
          ];
          print("km value");
          print(_textKMController.text);
          print("bookingDate");
          print('${getDateText()} ${getTimeText()}');
          final resultInsertServiceCustomerData =
              await supabase.from('service_customer').insert([
            {
              'status': 'booked',
              'email': supabase.auth.currentUser!.email.toString(),
              'bookingDate': '${getDateText()} ${getTimeText()}',
              'kmKendaraan': _textKMController.text,
            }
          ]).execute();
          print("selesai insert");
          if (resultInsertServiceCustomerData.data == null ||
              resultInsertServiceCustomerData.data.length == 0) {
            return context.showErrorSnackBar(
                message: resultInsertServiceCustomerData.error.toString());
          } else if (resultInsertServiceCustomerData != null ||
              resultInsertServiceCustomerData.data.length > 0) {
            for (var i = 0; i < dataService.length; i++) {
              selectedDataService[i]['serviceCustomerId'] =
                  resultInsertServiceCustomerData.data[0]['serviceCustomerId'];

              selectedDataService[i]['serviceId'] = dataService[i]['serviceId'];
              print("service id $i");
              print(dataService[i]['serviceId']);
              print("selectedDataService $i");
              print(selectedDataService);
            }
            for (var i = 0; i < selectedDataService.length;) {
              if (selectedDataService[i]['serviceId'] == null) {
                print("data kosong");
                print(selectedDataService[i]['serviceId']);
                selectedDataService.removeAt(i);
              } else {
                print("data berisi");
                print(selectedDataService[i]['serviceId']);
                i++;
              }
            }
            print("data sebelum diinput");
            print(selectedDataService);

            final res = await supabase
                .from('detail_service_customer')
                .insert(selectedDataService)
                .execute();
            print("error");
            print(res.error);
            print("data hasil");
            print(res.data);
            if (res.error == null) {
              return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                          "Pesanan service mu berhasil dilakukan. Pastikan datang tepat waktu pada tanggal ${getDateText()} pukul ${getTimeText()}. Apabila setelah 30 menit dari waktu booking anda belum sampai di bengkel, maka booking akan batal secara otomatis"),
                      actions: [
                        TextButton(
                            onPressed: (() {
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottNavBar()),
                                );
                              });
                            }),
                            child: Text("oke"))
                      ],
                    );
                  });
            } else {
              return context.showErrorSnackBar(message: res.error.toString());
            }
          }
        } else {
          return context.showErrorSnackBar(
              message:
                  "KM kendaraan harus diisi dengan angka bulat lebih dari 0");
        }
      }
    }
  }
//--------------------/\Function Insert to Table service_customer then to detail_service_customer/\-------------
}

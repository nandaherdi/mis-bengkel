import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../connection/constants.dart';

class OnGoingService extends StatefulWidget {
  const OnGoingService({super.key});

  @override
  State<OnGoingService> createState() => _OnGoingServiceState();
}

class _OnGoingServiceState extends State<OnGoingService> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getServiceCustomerData(),
        builder: (context, snapshot) {
          print("snapshot data");
          print(snapshot.hasData);
          if (snapshot.hasData) {
            if (snapshot.data!.length != 0) {
              // print("snapshot data");
              // print(snapshot.data);
              final List? dataServiceCustomer = snapshot.data;
              print('dataServiceUser');
              print(dataServiceCustomer);
              return FutureBuilder<List<dynamic>>(
                future: getDetailServiceCustomerData(
                    dataServiceCustomer![0]['serviceCustomerId'].toString()),
                builder: (_, snapshot) {
                  final List? dataDetailServiceCustomer = snapshot.data;
                  if (snapshot.hasData) {
                    //print('dataDetailServiceUser');
                    //print(dataDetailServiceUser);

//---------------------\/Card (style)\/-------------------------------------------------------------------------------------------
                    return Container(
                        clipBehavior: Clip.hardEdge,
                        // width: MediaQuery.of(context)
                        //     .size
                        //     .width,
                        // height: 100,
                        margin: EdgeInsets.only(right: 0, left: 0, bottom: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: dataServiceCustomer[0]['status'] ==
                                    'waiting'
                                ? waitingColor
                                : dataServiceCustomer[0]['status'] ==
                                        'on proccess'
                                    ? onProccessColor
                                    : dataServiceCustomer[0]['status'] ==
                                            'booked'
                                        ? bookedColor
                                        : dataServiceCustomer[0]['status'] ==
                                                'cancelled'
                                            ? cancelledColor
                                            : doneColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Stack(clipBehavior: Clip.hardEdge, children: [
                          Positioned(
                              bottom: Random().nextDouble() * 50,
                              left: Random().nextDouble() * 50,
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: dataServiceCustomer[0]
                                                  ['status'] ==
                                              'waiting'
                                          ? waitingColor
                                          : dataServiceCustomer[0]['status'] ==
                                                  'on proccess'
                                              ? onProccessColor
                                              : dataServiceCustomer[0]
                                                          ['status'] ==
                                                      'booked'
                                                  ? bookedColor
                                                  : dataServiceCustomer[0]
                                                              ['status'] ==
                                                          'cancelled'
                                                      ? cancelledColor
                                                      : doneColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(300)),
                                  ),
                                ),
                              )),
//---------------------/\Card (style)/\-------------------------------------------------------------------------------------------

//---------------------\/Card service Customer (content)\/-------------------------------------------------------------------------------------------
                          ExpansionTile(
                            //trailing: Text(dataServiceUser[0]['status']),
                            collapsedTextColor:
                                dataServiceCustomer[0]['status'] == 'done'
                                    ? Colors.black
                                    : Colors.white,
                            textColor: Colors.black,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.black,
                            //maintainState: true,
                            //initiallyExpanded: true,
                            backgroundColor: Colors.white,
                            //collapsedBackgroundColor: Colors.amber,
                            //tilePadding: EdgeInsets.all(20),

                            //collapsedBackgroundColor: Colors.amber,
                            //childrenPadding: EdgeInsets.all(20),
                            leading: Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 20,
                              //color: Colors.red,
                              child: Text(dataServiceCustomer[0]['status']),
                            ),
                            // Container(
                            //   height: 20,
                            //   width: 20,
                            //   decoration: BoxDecoration(
                            //       color: dataServiceCustomer[0]['status'] ==
                            //               'waiting'
                            //           ? Color(0xFFF3B065)
                            //           : dataServiceCustomer[0]['status'] ==
                            //                   'on proccess'
                            //               ? Color(0xFF6CEDE1)
                            //               : Color(0xFFC47AF3),
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(20))),
                            // ),
                            title: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(
                                      dataServiceCustomer[0]['bookingDate']))
                                  .toString(),
                              style: GoogleFonts.roboto(
                                  //color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${DateFormat('HH.mm').format(DateTime.parse(dataServiceCustomer[0]['bookingDate'])).toString()} WIB',
                              style: GoogleFonts.roboto(
                                  //color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            //Text(dataServiceUser[0]['status']),
                            children: <Widget>[
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: dataDetailServiceCustomer!.length,
                                  itemBuilder: (context, index) {
//---------------------/\Card service Customer (content)/\-------------------------------------------------------------------------------------------

//---------------------\/tile detail service Customer (content)\/-------------------------------------------------------------------------------------------
                                    return ListTile(
                                      title: Text(
                                          dataDetailServiceCustomer[index]
                                              ['service']['serviceName']),

                                      // Text(dataDetailServiceUser[index]
                                      //     ['serviceId']),
                                    );
//---------------------/\tile detail service Customer (content)/\-------------------------------------------------------------------------------------------
                                  }),

//---------------------\/Kondisi tampilkan button "batal" atau tidak\/-------------------------------------------------------------------------------------------
                              dataServiceCustomer[0]['status'] ==
                                          'on proccess' ||
                                      dataServiceCustomer[0]['status'] ==
                                          'waiting' ||
                                      dataServiceCustomer[0]['status'] ==
                                          'booked'
//---------------------/\Kondisi tampilkan button "batal" atau tidak/\-------------------------------------------------------------------------------------------

//----------------------\/Tombol "Batal"\/-------------------------------------------------------------------------------------------------------------------------------
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 40),
                                                  height: 60,
                                                  width: 170,
                                                  //color: Colors.red,
                                                  child: Center(
                                                    child: Text(
                                                      "Anda yakin ingin membatalkan service milik ${dataServiceCustomer[0]['customer']['fName']} ${dataServiceCustomer[0]['customer']['lName']}?",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            // print(
                                                            //     "banyaknya data sparepart");
                                                            // print(
                                                            //     dataDetailServiceUser!
                                                            //         .length);

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            final result =
                                                                await updateStatusServiceCustomer(
                                                                    dataServiceCustomer[
                                                                            0][
                                                                        'serviceCustomerId'],
                                                                    "cancelled");
                                                            setState(() {
                                                              // print(
                                                              //     "cancel berhasil");
                                                              // print(result);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.red,
                                        child: Center(
                                            child: Text(
                                          "batalkan servis",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    )
//----------------------/\Tombol "Batal"/\-------------------------------------------------------------------------------------------------------------------------------

                                  : Container(),
                            ],
                          ),
                        ]));
                  } else {
                    // print('error data');
                    // print(dataDetailServiceUser);
                    return Text(snapshot.error.toString());
                  }
                },
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }
}

List<Color> onProccessColor = [
  Color(0xFF68E1B8),
  Color(0xFF6CEDE1),
];
List<Color> waitingColor = [
  Color(0xFFEF9E5B),
  Color(0xFFF3B065),
];
List<Color> bookedColor = [
  Color(0xFF9580F4),
  Color(0xFFC47AF3),
];
List<Color> cancelledColor = [
  Color(0xFFE7546F),
  Color(0xFFEA6A91),
];
List<Color> doneColor = [
  Color.fromARGB(255, 233, 233, 233),
  Color.fromARGB(255, 255, 255, 255),
];

Future<List<dynamic>> getServiceCustomerData() async {
  //final List<dynamic> getData;
  final res = await supabase
      .from('service_customer')
      .select(
          'serviceCustomerId, status, bookingDate, customer(email, fName, lName, jarakTempuhHarian)')
      .match({'email': supabase.auth.currentUser!.email})
      .order('created_at', ascending: false)
      .limit(1)
      .execute();
  List<dynamic>? dataServiceCustomer;
  print("getserviceuserdata()");
  print(dataServiceCustomer);
  if (res.data == null) {
    return dataServiceCustomer = [];
  } else {
    return dataServiceCustomer = res.data;
  }
  //return dataServiceCustomer;
}

Future<List<dynamic>> getDetailServiceCustomerData(
    getServiceCustomerDataIndex) async {
  String ?? getServiceCustomerDataIndex;
  final res = await supabase
      .from('detail_service_customer')
      .select('service(serviceName, serviceId, jarakTempuh)')
      .eq(
        'serviceCustomerId',
        '$getServiceCustomerDataIndex',
      )
      .execute();

  List<dynamic> dataServiceCustomer = res.data;
  return dataServiceCustomer;
}

// deleteSparePart(selectedServiceId, selectedServiceCustomer) async {
//   String ?? selectedServiceId;
//   String ?? selectedServiceCustomer;
//   final res = await supabase.from('detail_service_customer').delete().match({
//     'serviceId': selectedServiceId,
//     'serviceCustomerId': selectedServiceCustomer
//   }).execute();
//   dynamic result = res.data;
// }

updateStatusServiceCustomer(selectedCustomerOrder, newStatus) async {
  String ?? selectedCustomerOrder;
  String ?? newStatus;
  final res = await supabase
      .from('service_customer')
      .update({'status': newStatus}).match(
          {'serviceCustomerId': selectedCustomerOrder}).execute();
  dynamic result = res.data;
}

// insertRemindTime(selectedEmail, selectedSparePart, newDate) async {
//   String ?? selectedEmail;
//   String ?? selectedSparePart;
//   String ?? newDate;
//   final res = await supabase.from('reminder').insert({
//     'serviceId': selectedSparePart,
//     'email': selectedEmail,
//     'remindTime': newDate,
//   }).execute();

//   return res.data;
// }

// updateRemindTime(selectedEmail, selectedSparePart, newDate) async {
//   String ?? selectedEmail;
//   String ?? selectedSparePart;
//   String ?? newDate;
//   final res = await supabase.from('reminder').update({
//     'serviceId': selectedSparePart,
//     'email': selectedEmail,
//     'remindTime': newDate,
//   }).match({'email': selectedEmail, 'serviceId': selectedSparePart}).execute();

//   return res.data;
// }

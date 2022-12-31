import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../connection/constants.dart';
import 'booking_page.dart';

class HistoryServicePage extends StatefulWidget {
  const HistoryServicePage({super.key});

  @override
  State<HistoryServicePage> createState() => _HistoryServicePageState();
}

class _HistoryServicePageState extends State<HistoryServicePage> {
  void initState() {
    super.initState();
  }

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingPage()),
          );
          // var now = DateTime.parse("2022-08-19");
          // context.showErrorSnackBar(
          //     message: DateFormat('MM').format(DateTime.now()));
        },
        label: Text("Booking"),
        heroTag: "Booking Button",
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
            //color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
//--------------------------\/HEADER\/------------------------------------------
                Container(
                  width: constraints.maxWidth,
                  //color: Colors.red,
                  child: Text(
                    "History",
                    style: GoogleFonts.roboto(
                        fontSize: 20, color: Color.fromARGB(255, 17, 52, 82)),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: constraints.maxWidth,
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
//--------------------------/\HEADER/\------------------------------------------

                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 600,
                //   color: Colors.amber,
                //   child: HistoryServicePage(),
                // )
                //HistoryServicePage(),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 600,
                  child: FutureBuilder<List<dynamic>>(
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
                            return RefreshIndicator(
                              onRefresh: refresh,
                              child: ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  itemCount: dataServiceCustomer!.length,
                                  itemBuilder: (context, index) {
                                    return FutureBuilder<List<dynamic>>(
                                      future: getDetailServiceCustomerData(
                                          dataServiceCustomer![index]
                                                  ['serviceCustomerId']
                                              .toString()),
                                      builder: (_, snapshot) {
                                        final List? dataDetailServiceCustomer =
                                            snapshot.data;
                                        if (snapshot.hasData) {
                                          //print('dataDetailServiceUser');
                                          //print(dataDetailServiceUser);

//----------------------------------------------------\/Cards widget (styling)\/-------------------------------------------------------------------------------------------------
                                          return Container(
                                              clipBehavior: Clip.hardEdge,
                                              // width: MediaQuery.of(context)
                                              //     .size
                                              //     .width,
                                              // height: 100,
                                              margin: EdgeInsets.only(
                                                  right: 0,
                                                  left: 0,
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: dataServiceCustomer[
                                                                  index]
                                                              ['status'] ==
                                                          'waiting'
                                                      ? waitingColor
                                                      : dataServiceCustomer[
                                                                      index]
                                                                  ['status'] ==
                                                              'on proccess'
                                                          ? onProccessColor
                                                          : dataServiceCustomer[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'booked'
                                                              ? bookedColor
                                                              : dataServiceCustomer[
                                                                              index]
                                                                          [
                                                                          'status'] ==
                                                                      'cancelled'
                                                                  ? cancelledColor
                                                                  : doneColor,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Stack(
                                                  clipBehavior: Clip.hardEdge,
                                                  children: [
                                                    Positioned(
                                                        bottom: Random()
                                                                .nextDouble() *
                                                            50,
                                                        left: Random()
                                                                .nextDouble() *
                                                            50,
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Container(
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  RadialGradient(
                                                                colors: dataServiceCustomer[index]
                                                                            [
                                                                            'status'] ==
                                                                        'waiting'
                                                                    ? waitingColor
                                                                    : dataServiceCustomer[index]['status'] ==
                                                                            'on proccess'
                                                                        ? onProccessColor
                                                                        : dataServiceCustomer[index]['status'] ==
                                                                                'booked'
                                                                            ? bookedColor
                                                                            : dataServiceCustomer[index]['status'] == 'cancelled'
                                                                                ? cancelledColor
                                                                                : doneColor,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          300)),
                                                            ),
                                                          ),
                                                        )),
//----------------------------------------------------/\Cards widget (styling)/\-------------------------------------------------------------------------------------------------------------

//----------------------------------------------------\/Service Customer Cards widget (content)\/-----------------------------------------------------------------------------------------------
                                                    ExpansionTile(
                                                      //trailing: Text(dataServiceUser[0]['status']),
                                                      collapsedTextColor:
                                                          dataServiceCustomer[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'done'
                                                              ? Colors.black
                                                              : Colors.white,
                                                      textColor: Colors.black,
                                                      collapsedIconColor:
                                                          Colors.white,
                                                      iconColor: Colors.black,
                                                      //maintainState: true,
                                                      //initiallyExpanded: true,
                                                      backgroundColor:
                                                          Colors.white,
                                                      //collapsedBackgroundColor: Colors.amber,
                                                      //tilePadding: EdgeInsets.all(20),

                                                      //collapsedBackgroundColor: Colors.amber,
                                                      //childrenPadding: EdgeInsets.all(20),
                                                      leading: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        height: 20,
                                                        //color: Colors.red,
                                                        child: Text(
                                                            dataServiceCustomer[
                                                                    index]
                                                                ['status']),
                                                      ),
                                                      // Container(
                                                      //   height: 20,
                                                      //   width: 20,
                                                      //   decoration: BoxDecoration(
                                                      //       color: dataServiceCustomer[
                                                      //                       index]
                                                      //                   [
                                                      //                   'status'] ==
                                                      //               'waiting'
                                                      //           ? Color(
                                                      //               0xFFF3B065)
                                                      //           : dataServiceCustomer[
                                                      //                           index]
                                                      //                       [
                                                      //                       'status'] ==
                                                      //                   'on proccess'
                                                      //               ? Color(
                                                      //                   0xFF6CEDE1)
                                                      //               : Color(
                                                      //                   0xFFC47AF3),
                                                      //       borderRadius:
                                                      //           BorderRadius.all(
                                                      //               Radius
                                                      //                   .circular(
                                                      //                       20))),
                                                      // ),
                                                      title: Text(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(DateTime.parse(
                                                                dataServiceCustomer[
                                                                        index][
                                                                    'bookingDate']))
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                                //color: Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      subtitle: Text(
                                                        '${DateFormat('HH.mm').format(DateTime.parse(dataServiceCustomer[index]['bookingDate'])).toString()} WIB',
                                                        style:
                                                            GoogleFonts.roboto(
                                                                //color: Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      //Text(dataServiceUser[0]['status']),
                                                      children: <Widget>[
                                                        ListView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                dataDetailServiceCustomer!
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
//-----------------------------------------------------------\/Detail Service Customer Tile(Content)\/------------------------------------------------------------
                                                              return ListTile(
                                                                title: Text(dataDetailServiceCustomer[
                                                                            index]
                                                                        [
                                                                        'service']
                                                                    [
                                                                    'serviceName']),

                                                                // Text(dataDetailServiceUser[index]
                                                                //     ['serviceId']),
                                                              );
//-----------------------------------------------------------/\Detail Service Customer Tile(Content)/\------------------------------------------------------------
                                                            }),
                                                      ],
                                                    ),
//----------------------------------------------------/\Service Customer Cards widget (content)/\-----------------------------------------------------------------------------------------------
                                                  ]));
                                        } else {
                                          // print('error data');
                                          // print(dataDetailServiceUser);
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                      },
                                    );
                                  }),
                            );
                          } else {
                            return Text("Anda belum memiliki riwayat servis");
                          }
                        } else {
                          return Text("Anda belum memiliki riwayat servis");
                        }
                      }),
                ),
              ]),
            ),
          ),
        );
      }),
    );
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

// updateStatusServiceCustomer(selectedCustomerOrder, newStatus) async {
//   String ?? selectedCustomerOrder;
//   String ?? newStatus;
//   final res = await supabase
//       .from('service_customer')
//       .update({'status': newStatus}).match(
//           {'serviceCustomerId': selectedCustomerOrder}).execute();
//   dynamic result = res.data;
// }

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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../connection/constants.dart';

class StatusServiceCustomerPage extends StatefulWidget {
  const StatusServiceCustomerPage({super.key});

  @override
  State<StatusServiceCustomerPage> createState() =>
      _StatusServiceCustomerPageState();
}

class _StatusServiceCustomerPageState extends State<StatusServiceCustomerPage> {
  String? statusRadioButtonVal;
  static List<dynamic> dataService = [];
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
    Color.fromARGB(255, 240, 240, 240),
  ];

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top,
            right: 20,
            left: 20,
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Text(
                    "Service",
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
                    "Customer",
                    style: GoogleFonts.roboto(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 52, 82),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 600,
                  child: FutureBuilder<List<dynamic>>(
                      future: getServiceCustomerData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List? dataServiceCustomer = snapshot.data;
                          //print('dataServiceUser');
                          // print(dataServiceUser);
                          return RefreshIndicator(
                            onRefresh: refresh,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<List<dynamic>>(
                                  future: getDetailServiceCustomerData(
                                      dataServiceCustomer![index]
                                              ['serviceCustomerId']
                                          .toString()),
                                  builder: (_, snapshot) {
                                    final dataDetailServiceCustomer =
                                        snapshot.data;
                                    if (snapshot.hasData) {
                                      //print('dataDetailServiceUser');
                                      //print(dataDetailServiceUser);
                                      return Container(
                                          clipBehavior: Clip.hardEdge,
                                          //height: 100,
                                          margin: EdgeInsets.only(
                                              right: 20, left: 20, bottom: 10),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: dataServiceCustomer[index]
                                                          ['status'] ==
                                                      'waiting'
                                                  ? waitingColor
                                                  : dataServiceCustomer[index]
                                                              ['status'] ==
                                                          'on proccess'
                                                      ? onProccessColor
                                                      : dataServiceCustomer[
                                                                      index]
                                                                  ['status'] ==
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
                                                    bottom:
                                                        Random().nextDouble() *
                                                            50,
                                                    left:
                                                        Random().nextDouble() *
                                                            50,
                                                    child: Opacity(
                                                      opacity: 0.5,
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              RadialGradient(
                                                            colors: dataServiceCustomer[
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    'waiting'
                                                                ? waitingColor
                                                                : dataServiceCustomer[index]
                                                                            [
                                                                            'status'] ==
                                                                        'on proccess'
                                                                    ? onProccessColor
                                                                    : dataServiceCustomer[index]['status'] ==
                                                                            'booked'
                                                                        ? bookedColor
                                                                        : dataServiceCustomer[index]['status'] ==
                                                                                'cancelled'
                                                                            ? cancelledColor
                                                                            : doneColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          300)),
                                                        ),
                                                      ),
                                                    )),
                                                ExpansionTile(
                                                  collapsedTextColor:
                                                      Colors.white,
                                                  textColor: Colors.black,
                                                  collapsedIconColor:
                                                      Colors.white,
                                                  iconColor: Colors.black,
                                                  //maintainState: true,
                                                  //initiallyExpanded: true,
                                                  backgroundColor: Colors.white,
                                                  //collapsedBackgroundColor: Colors.amber,
                                                  //tilePadding: EdgeInsets.all(20),

                                                  //collapsedBackgroundColor: Colors.amber,
                                                  //childrenPadding: EdgeInsets.all(20),
                                                  leading: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        color: dataServiceCustomer[
                                                                        index][
                                                                    'status'] ==
                                                                'waiting'
                                                            ? Color(0xFFF3B065)
                                                            : dataServiceCustomer[
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    'on proccess'
                                                                ? Color(
                                                                    0xFF6CEDE1)
                                                                : Color(
                                                                    0xFFC47AF3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                  ),
                                                  title: Text(
                                                    '${dataServiceCustomer[index]['customer']['fName']} ${dataServiceCustomer[index]['customer']['lName']}',
                                                    style: GoogleFonts.roboto(
                                                        //color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                      dataServiceCustomer[index]
                                                          ['status']),
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: "on proccess",
                                                          groupValue:
                                                              statusRadioButtonVal,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              statusRadioButtonVal =
                                                                  value
                                                                      as String;
                                                            });
                                                          },
                                                        ),
                                                        Text("On Proccess"),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: "waiting",
                                                          groupValue:
                                                              statusRadioButtonVal,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              statusRadioButtonVal =
                                                                  value
                                                                      as String;
                                                            });
                                                          },
                                                        ),
                                                        Text("Waiting"),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: "booked",
                                                          groupValue:
                                                              statusRadioButtonVal,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              statusRadioButtonVal =
                                                                  value
                                                                      as String;
                                                            });
                                                          },
                                                        ),
                                                        Text("Booked"),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              40),
                                                                  height: 60,
                                                                  width: 170,
                                                                  //color: Colors.red,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Anda yakin ingin mengubah status milik ${dataServiceCustomer[index]['customer']['fName']} ${dataServiceCustomer[index]['customer']['lName']} menjadi $statusRadioButtonVal?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.red,
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            final result =
                                                                                await updateStatusServiceCustomer(dataServiceCustomer[index]['serviceCustomerId'], statusRadioButtonVal);
                                                                            setState(() {
                                                                              statusRadioButtonVal = "";
                                                                              // print(
                                                                              //     "cancel berhasil");
                                                                              // print(result);
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.green,
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        color: Colors.amber,
                                                        child: Center(
                                                            child: Text(
                                                          "ubah status",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              40),
                                                                  height: 60,
                                                                  width: 170,
                                                                  //color: Colors.red,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Anda yakin servis milik ${dataServiceCustomer[index]['customer']['fName']} ${dataServiceCustomer[index]['customer']['lName']} sudah selesai?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.red,
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            final result =
                                                                                await updateStatusServiceCustomer(dataServiceCustomer[index]['serviceCustomerId'], "done");
                                                                            for (int i = 0;
                                                                                i < dataDetailServiceCustomer!.length;
                                                                                i++) {
                                                                              int _hariReminder = dataDetailServiceCustomer[i]['service']['jarakTempuh'] ~/ dataServiceCustomer[index]['customer']['jarakTempuhHarian'];
                                                                              print("hari hasil perhitungan");
                                                                              print(_hariReminder);
                                                                              DateTime bookingDate = DateTime.parse(dataServiceCustomer[index]['bookingDate']);
                                                                              print("old date");
                                                                              print(bookingDate);
                                                                              DateTime remindDate = DateTime(
                                                                                bookingDate.year,
                                                                                bookingDate.month,
                                                                                bookingDate.day + _hariReminder,
                                                                              );
                                                                              String remindDateFormatted = '${remindDate.year}-${remindDate.month}-${remindDate.day} 09:00';
                                                                              print("new date of ${dataDetailServiceCustomer[i]['service']['serviceId']}");
                                                                              print(remindDateFormatted);
                                                                              print("email");
                                                                              print(dataServiceCustomer[index]['customer']['email']);
                                                                              final res = await supabase.from('reminder').select('*').match({
                                                                                'serviceId': dataDetailServiceCustomer[i]['service']['serviceId'],
                                                                                'email': dataServiceCustomer[index]['customer']['email']
                                                                              }).execute(count: CountOption.exact);
                                                                              print("jumlah data reminder ${res.count.toString()}");
                                                                              if (res.count == 0) {
                                                                                final result = await insertRemindTime(dataServiceCustomer[index]['customer']['email'], dataDetailServiceCustomer[i]['service']['serviceId'], remindDateFormatted);
                                                                                print(result);
                                                                              } else if (res.count! == 1) {
                                                                                print("masuk ke else if");
                                                                                final result = await updateRemindTime(dataServiceCustomer[index]['customer']['email'], dataDetailServiceCustomer[i]['service']['serviceId'], remindDateFormatted);
                                                                                print(result);
                                                                              }
                                                                              // final result = await upsertRemindTime(
                                                                              //     dataServiceUser[
                                                                              //                 index]
                                                                              //             ['user']
                                                                              //         ['email'],
                                                                              //     dataDetailServiceUser[
                                                                              //                 i]
                                                                              //             ['service']
                                                                              //         ['serviceId'],
                                                                              //     remindDateFormatted);

                                                                            }
                                                                            setState(() {
                                                                              // print(
                                                                              //     "cancel berhasil");
                                                                              // print(result);
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.green,
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        color: Colors.green,
                                                        child: Center(
                                                            child: Text(
                                                          "servis selesai",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              40),
                                                                  height: 60,
                                                                  width: 170,
                                                                  //color: Colors.red,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Anda yakin ingin membatalkan service milik ${dataServiceCustomer[index]['customer']['fName']} ${dataServiceCustomer[index]['customer']['lName']}?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                          onPressed:
                                                                              () async {
                                                                            // print(
                                                                            //     "banyaknya data sparepart");
                                                                            // print(
                                                                            //     dataDetailServiceUser!
                                                                            //         .length);

                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.red,
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            final result =
                                                                                await updateStatusServiceCustomer(dataServiceCustomer[index]['serviceCustomerId'], "cancelled");
                                                                            setState(() {
                                                                              // print(
                                                                              //     "cancel berhasil");
                                                                              // print(result);
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.green,
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        color: Colors.red,
                                                        child: Center(
                                                            child: Text(
                                                          "batalkan servis",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            dataDetailServiceCustomer!
                                                                .length,
                                                        itemBuilder: (context,
                                                            indexTile) {
                                                          return ListTile(
                                                              title: Text(dataDetailServiceCustomer[
                                                                          indexTile]
                                                                      [
                                                                      'service']
                                                                  [
                                                                  'serviceName']),
                                                              trailing:
                                                                  TextButton(
                                                                onPressed: () {
                                                                  setState(
                                                                      () {});
                                                                  print(
                                                                      "data sparepart");
                                                                  print(dataDetailServiceCustomer[
                                                                      indexTile]);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 40),
                                                                            height:
                                                                                60,
                                                                            width:
                                                                                170,
                                                                            //color: Colors.red,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "Anda yakin ingin menghapus Spare Part ${dataDetailServiceCustomer[indexTile]['service']['serviceName']}?",
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      color: Colors.red,
                                                                                    )),
                                                                                TextButton(
                                                                                    onPressed: () async {
                                                                                      print("deleted sparepart");
                                                                                      print('${dataDetailServiceCustomer[indexTile]['service']['serviceId']}, ${dataServiceCustomer[index]['serviceCustomerId']}');
                                                                                      setState(() {});
                                                                                      final result = await deleteSparePart(dataDetailServiceCustomer[indexTile]['service']['serviceId'], dataServiceCustomer[index]['serviceCustomerId']);

                                                                                      setState(() {
                                                                                        // print(
                                                                                        //     result);
                                                                                        Navigator.of(context).pop();
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
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              )

                                                              // Text(dataDetailServiceUser[index]
                                                              //     ['serviceId']),
                                                              );
                                                        }),
                                                    InkWell(
                                                      onTap: () async {
                                                        await FutureBuilder<
                                                                List<dynamic>>(
                                                            future:
                                                                getServiceData(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                print(
                                                                    "sata service dalam future builder");
                                                                print(
                                                                    dataService);
                                                                return Container();
                                                              } else {
                                                                return Text(snapshot
                                                                    .error
                                                                    .toString());
                                                              }
                                                            });
                                                        setState(() {});

                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content: Text(
                                                                    "pilih minimal satu spare part/service"),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        setState(
                                                                            () {
                                                                          if (snapshot.data!.length >
                                                                              0) {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return StatefulBuilder(
                                                                                    builder: (context, setState) {
                                                                                      return AlertDialog(
                                                                                        content: Container(
                                                                                          margin: EdgeInsets.only(top: 40),
                                                                                          // height:
                                                                                          //     400,
                                                                                          width: 170,
                                                                                          //color: Colors.red,
                                                                                          child: Center(
                                                                                            child: Container(
                                                                                                //color: Colors.amber,
                                                                                                width: 336,
                                                                                                //height: 500,
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
                                                                                          ),
                                                                                        ),
                                                                                        actions: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              TextButton(
                                                                                                  onPressed: () async {
                                                                                                    // print(
                                                                                                    //     "banyaknya data sparepart");
                                                                                                    // print(
                                                                                                    //     dataDetailServiceUser!
                                                                                                    //         .length);

                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                  child: Icon(
                                                                                                    Icons.close,
                                                                                                    color: Colors.red,
                                                                                                  )),
                                                                                              TextButton(
                                                                                                  onPressed: () async {
                                                                                                    for (var i = 0; i < dataService.length;) {
                                                                                                      if (dataService[i]["value"] == false) {
                                                                                                        dataService.removeAt(i);
                                                                                                      } else if (dataService[i]["value"] == true) {
                                                                                                        i++;
                                                                                                      }
                                                                                                    }

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

                                                                                                    //final result = await insertServiceCustomerData();
                                                                                                    for (var i = 0; i < dataService.length; i++) {
                                                                                                      selectedDataService[i]['serviceCustomerId'] = dataServiceCustomer[index]['serviceCustomerId'];

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

                                                                                                    final resInsert = await insertSparePart(selectedDataService);
                                                                                                    // print("error");
                                                                                                    // print(resInsert.error);
                                                                                                    // print("data hasil");
                                                                                                    // print(resInsert.data);
                                                                                                    // if (resInsert.error == null) {
                                                                                                    //   return showDialog(
                                                                                                    //       context: context,
                                                                                                    //       barrierDismissible: false,
                                                                                                    //       builder: (context) {
                                                                                                    //         return AlertDialog(
                                                                                                    //           content: Text("Spare Part berhasil ditambahkan"),
                                                                                                    //           actions: [
                                                                                                    //             TextButton(
                                                                                                    //                 onPressed: (() {
                                                                                                    //                   Navigator.of(context).pop();

                                                                                                    //                   setState(() {
                                                                                                    //                     Navigator.of(context).pop();
                                                                                                    //                   });
                                                                                                    //                   setState(() {});
                                                                                                    //                 }),
                                                                                                    //                 child: Text("oke"))
                                                                                                    //           ],
                                                                                                    //         );
                                                                                                    //       });
                                                                                                    // } else {
                                                                                                    //   return context.showErrorSnackBar(message: resInsert.error.toString());
                                                                                                    // }
                                                                                                  },
                                                                                                  child: Icon(
                                                                                                    Icons.check,
                                                                                                    color: Colors.green,
                                                                                                  )),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                });
                                                                          } else {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    content: Text("data tidak ditemukan"),
                                                                                  );
                                                                                });
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          "oke"))
                                                                ],
                                                              );
                                                            });

                                                        // showDialog(
                                                        //     context: context,
                                                        //     builder: (context) {
                                                        //       return StatefulBuilder(
                                                        //         builder: (context,
                                                        //             setState) {
                                                        //           return AlertDialog(
                                                        //             content:
                                                        //                 Container(
                                                        //               margin: EdgeInsets
                                                        //                   .only(
                                                        //                       top: 40),
                                                        //               // height:
                                                        //               //     400,
                                                        //               width:
                                                        //                   170,
                                                        //               //color: Colors.red,
                                                        //               child:
                                                        //                   Center(
                                                        //                 child: Container(
                                                        //                     //color: Colors.amber,
                                                        //                     width: 336,
                                                        //                     //height: 500,
                                                        //                     child: ListView.builder(
                                                        //                       scrollDirection: Axis.vertical,
                                                        //                       shrinkWrap: true,
                                                        //                       itemCount: dataService.length,
                                                        //                       itemBuilder: (context, index) {
                                                        //                         return CheckboxListTile(
                                                        //                           title: Text(dataService[index]['serviceName']),
                                                        //                           value: dataService[index]['value'],
                                                        //                           onChanged: (value) {
                                                        //                             setState(() {
                                                        //                               dataService[index]['value'] = value!;
                                                        //                               print(dataService[index]['serviceName']);
                                                        //                               print(dataService[index]['value']);
                                                        //                             });
                                                        //                           },
                                                        //                         );
                                                        //                       },
                                                        //                     )),
                                                        //               ),
                                                        //             ),
                                                        //             actions: [
                                                        //               Row(
                                                        //                 mainAxisAlignment:
                                                        //                     MainAxisAlignment.spaceBetween,
                                                        //                 children: [
                                                        //                   TextButton(
                                                        //                       onPressed: () async {
                                                        //                         // print(
                                                        //                         //     "banyaknya data sparepart");
                                                        //                         // print(
                                                        //                         //     dataDetailServiceUser!
                                                        //                         //         .length);

                                                        //                         Navigator.of(context).pop();
                                                        //                       },
                                                        //                       child: Icon(
                                                        //                         Icons.close,
                                                        //                         color: Colors.red,
                                                        //                       )),
                                                        //                   TextButton(
                                                        //                       onPressed: () async {
                                                        //                         for (var i = 0; i < dataService.length;) {
                                                        //                           if (dataService[i]["value"] == false) {
                                                        //                             dataService.removeAt(i);
                                                        //                           } else if (dataService[i]["value"] == true) {
                                                        //                             i++;
                                                        //                           }
                                                        //                         }

                                                        //                         print("setelah dihapus yang false");
                                                        //                         print(dataService);

                                                        //                         late List<dynamic> selectedDataService = [
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {},
                                                        //                           {}
                                                        //                         ];

                                                        //                         //final result = await insertServiceCustomerData();
                                                        //                         for (var i = 0; i < dataService.length; i++) {
                                                        //                           selectedDataService[i]['serviceCustomerId'] = dataServiceCustomer[index]['serviceCustomerId'];

                                                        //                           selectedDataService[i]['serviceId'] = dataService[i]['serviceId'];
                                                        //                           print("service id $i");
                                                        //                           print(dataService[i]['serviceId']);
                                                        //                           print("selectedDataService $i");
                                                        //                           print(selectedDataService);
                                                        //                         }
                                                        //                         for (var i = 0; i < selectedDataService.length;) {
                                                        //                           if (selectedDataService[i]['serviceId'] == null) {
                                                        //                             print("data kosong");
                                                        //                             print(selectedDataService[i]['serviceId']);
                                                        //                             selectedDataService.removeAt(i);
                                                        //                           } else {
                                                        //                             print("data berisi");
                                                        //                             print(selectedDataService[i]['serviceId']);
                                                        //                             i++;
                                                        //                           }
                                                        //                         }
                                                        //                         print("data sebelum diinput");
                                                        //                         print(selectedDataService);

                                                        //                         final resInsert = await insertSparePart(selectedDataService);
                                                        //                         // print("error");
                                                        //                         // print(resInsert.error);
                                                        //                         // print("data hasil");
                                                        //                         // print(resInsert.data);
                                                        //                         // if (resInsert.error == null) {
                                                        //                         //   return showDialog(
                                                        //                         //       context: context,
                                                        //                         //       barrierDismissible: false,
                                                        //                         //       builder: (context) {
                                                        //                         //         return AlertDialog(
                                                        //                         //           content: Text("Spare Part berhasil ditambahkan"),
                                                        //                         //           actions: [
                                                        //                         //             TextButton(
                                                        //                         //                 onPressed: (() {
                                                        //                         //                   Navigator.of(context).pop();

                                                        //                         //                   setState(() {
                                                        //                         //                     Navigator.of(context).pop();
                                                        //                         //                   });
                                                        //                         //                   setState(() {});
                                                        //                         //                 }),
                                                        //                         //                 child: Text("oke"))
                                                        //                         //           ],
                                                        //                         //         );
                                                        //                         //       });
                                                        //                         // } else {
                                                        //                         //   return context.showErrorSnackBar(message: resInsert.error.toString());
                                                        //                         // }
                                                        //                       },
                                                        //                       child: Icon(
                                                        //                         Icons.check,
                                                        //                         color: Colors.green,
                                                        //                       )),
                                                        //                 ],
                                                        //               )
                                                        //             ],
                                                        //           );
                                                        //         },
                                                        //       );
                                                        //     });
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        color: Colors
                                                            .grey.shade200,
                                                        child: Center(
                                                            child: Text(
                                                          "+",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )),
                                                      ),
                                                    )
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
                              },
                            ),
                          );
                        } else {
                          return Text(
                              "tidak ada service yang sedang berlangsung");
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> getServiceData() async {
    print("sebeluh perubahan data");
    print(dataService);

    final res = await supabase.from('service').select().execute();
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

  // insertDetailServiceCustomerData(dataServiceCustomer) async {
  //   List<dynamic>? dataServiceCustomer;
  //   for (var i = 0; i < dataService.length;) {
  //     if (dataService[i]["value"] == false) {
  //       dataService.removeAt(i);
  //     } else if (dataService[i]["value"] == true) {
  //       i++;
  //     }
  //   }

  //   print("setelah dihapus yang false");
  //   print(dataService);

  //   late List<dynamic> selectedDataService = [
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {},
  //     {}
  //   ];

  //   //final result = await insertServiceCustomerData();
  //   for (var i = 0; i < dataService.length; i++) {
  //     selectedDataService[i]['serviceCustomerId'] =
  //         dataServiceCustomer[index]['serviceCustomerId'];

  //     selectedDataService[i]['serviceId'] = dataService[i]['serviceId'];
  //     print("service id $i");
  //     print(dataService[i]['serviceId']);
  //     print("selectedDataService $i");
  //     print(selectedDataService);
  //   }
  //   for (var i = 0; i < selectedDataService.length;) {
  //     if (selectedDataService[i]['serviceId'] == null) {
  //       print("data kosong");
  //       print(selectedDataService[i]['serviceId']);
  //       selectedDataService.removeAt(i);
  //     } else {
  //       print("data berisi");
  //       print(selectedDataService[i]['serviceId']);
  //       i++;
  //     }
  //   }
  //   print("data sebelum diinput");
  //   print(selectedDataService);

  //   final res = await supabase
  //       .from('detail_service_customer')
  //       .insert(selectedDataService)
  //       .execute();
  //   print("error");
  //   print(res.error);
  //   print("data hasil");
  //   print(res.data);
  //   if (res.error == null) {
  //     return showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text(
  //                 "Spare Part berhasil ditambahkan"),
  //             actions: [
  //               TextButton(
  //                   onPressed: (() {
  //                     setState(() {
  //                       Navigator.of(context).pop();
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(builder: (context) => BottNavBar()),
  //                       );
  //                     });
  //                   }),
  //                   child: Text("oke"))
  //             ],
  //           );
  //         });
  //   } else {
  //     return context.showErrorSnackBar(message: res.error.toString());
  //   }
  // }
  insertSparePart(selectedDataService) async {
    List ?? selectedDataService;
    print("data dalam function");
    print(selectedDataService);
    final res = await supabase
        .from('detail_service_customer')
        .insert(selectedDataService)
        .execute();
    if (res.error == null) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Text("Spare Part berhasil ditambahkan"),
              actions: [
                TextButton(
                    onPressed: (() {
                      Navigator.of(context).pop();

                      setState(() {
                        Navigator.of(context).pop();
                      });
                      setState(() {});
                    }),
                    child: Text("oke"))
              ],
            );
          });
    } else {
      return context.showErrorSnackBar(message: res.error.toString());
    }
  }
}

Future<List<dynamic>> getServiceCustomerData() async {
  //final List<dynamic> getData;
  final res = await supabase
      .from('service_customer')
      .select(
          'serviceCustomerId, status, bookingDate, customer(email, fName, lName, jarakTempuhHarian)')
      .or('status.eq.booked, status.eq.waiting, status.eq.on proccess')
      .order('created_at', ascending: true)
      .execute();
  List<dynamic> dataServiceCustomer = res.data;
  return dataServiceCustomer;
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

deleteSparePart(selectedServiceId, selectedServiceCustomer) async {
  String ?? selectedServiceId;
  String ?? selectedServiceCustomer;
  final res = await supabase.from('detail_service_customer').delete().match({
    'serviceId': selectedServiceId,
    'serviceCustomerId': selectedServiceCustomer
  }).execute();
  dynamic result = res.data;
}

updateStatusServiceCustomer(selectedCustomerOrder, newStatus) async {
  String ?? selectedCustomerOrder;
  String ?? newStatus;
  final res = await supabase
      .from('service_customer')
      .update({'status': newStatus}).match(
          {'serviceCustomerId': selectedCustomerOrder}).execute();
  dynamic result = res.data;
}

insertRemindTime(selectedEmail, selectedSparePart, newDate) async {
  String ?? selectedEmail;
  String ?? selectedSparePart;
  String ?? newDate;
  print("selectedEmail");
  print(selectedEmail);
  print("selected sparepart");
  print(selectedSparePart);
  print("newdate");
  print(newDate);

  final res = await supabase.from('reminder').insert({
    'serviceId': selectedSparePart,
    'email': selectedEmail,
    'remindDate': newDate,
  }).execute();

  return res.data;
}

updateRemindTime(selectedEmail, selectedSparePart, newDate) async {
  String ?? selectedEmail;
  String ?? selectedSparePart;
  String ?? newDate;
  final res = await supabase.from('reminder').update({
    'serviceId': selectedSparePart,
    'email': selectedEmail,
    'remindDate': newDate,
  }).match({'email': selectedEmail, 'serviceId': selectedSparePart}).execute();

  return res.data;
}

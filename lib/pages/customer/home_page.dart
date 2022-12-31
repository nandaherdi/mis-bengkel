import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../connection/constants.dart';
import '../../utils/notifications.dart';
import '../../widgets/on_going_service_widget.dart';
import '../../widgets/promo_banner_widget.dart';
import '../../widgets/queue_card_widget.dart';
import '../../widgets/reminder_list_widget.dart';
import 'history_notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String customerFName = "Selamat Datang";
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

  void initState() {
    super.initState();
    _jarakTempuhController = TextEditingController();
    _jarakTempuhHarian();
    getUserReminder();
  }

  bool _isLoading = false;
  late final TextEditingController _jarakTempuhController;
  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              child: RefreshIndicator(
                onRefresh: refresh,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: constraints.maxWidth - 120,
                              //color: Colors.red,
                              child: Text(
                                "Hi",
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 17, 52, 82)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: constraints.maxWidth - 120,
                              //color: Colors.red,
                              child: Text(
                                customerFName = supabase
                                    .auth.currentUser!.userMetadata["fName"],
                                style: GoogleFonts.roboto(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 17, 52, 82),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HistoryNotificationPage()),
                              );
                            },
                            child: Icon(
                              Icons.notifications_outlined,
                              size: 40,
                              color: Color.fromARGB(255, 17, 52, 82),
                            ))
                      ],
                    ),
                    PromoBannerWidget(),

//---------------------\/codingan untuk melihat list schedule notif sesuai dengan waktu yang ditentukan\/-----------------------
                    // TextButton(
                    //     onPressed: () async {
                    //       setState(() {});
                    //       Future<List> reminderData = AwesomeNotifications()
                    //           .listScheduledNotifications();
                    //       final res = await reminderData;
                    //       print("notif data length");
                    //       print(res.length);
                    //       print("notif data");
                    //       print(res);
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return AlertDialog(
                    //               content: Container(
                    //                 margin: EdgeInsets.only(top: 40),
                    //                 height: MediaQuery.of(context).size.height,
                    //                 width: MediaQuery.of(context).size.height,
                    //                 //color: Colors.red,
                    //                 child: SingleChildScrollView(
                    //                   scrollDirection: Axis.vertical,
                    //                   child: Column(
                    //                     verticalDirection:
                    //                         VerticalDirection.down,
                    //                     children: [
                    //                       Center(
                    //                         child: Text(
                    //                           res.toString(),
                    //                           textAlign: TextAlign.center,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             );
                    //           });
                    //     },
                    //     child: Icon(
                    //       Icons.print,
                    //       color: Colors.red,
                    //     )),
//----------------------------------------------------/\------------------------------------------

                    QueueWidget(
                      bookedColor: bookedColor,
                      onProccessColor: onProccessColor,
                      waitingColor: waitingColor,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Aktivitas Servis Terakhir",
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 17, 52, 82)),
                      ),
                    ),
                    OnGoingService(),
                    ReminderListWidget(),
                  ]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  _insertJarak() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    Text(
                        "masukkan rata-rata jarak yang anda tempuh dalam sehari (km)"),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _jarakTempuhController,
                      decoration: const InputDecoration(labelText: 'km'),
                    ),
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
                          child: _isLoading
                              ? Text("mohon menunggu")
                              : Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                          onPressed: () async {
                            final update = await updateJarakTempuhHarian();
                            // _isLoading = true;

                            // final res = await supabase.from('customer').update({
                            //   'jarakTempuhHarian':
                            //       int.parse(_jarakTempuhController.text)
                            // }).match({
                            //   'email': supabase.auth.currentUser!.email
                            // }).execute();
                            // if (res.error != null) {
                            //   _isLoading = false;
                            //   context.showErrorSnackBar(
                            //       message: res.error!.message);
                            // } else {
                            //   Navigator.of(context).pop();
                            //   _isLoading = false;
                            //   setState(() {});
                            //   return showDialog(
                            //       context: context,
                            //       builder: ((context) {
                            //         return AlertDialog(
                            //           content: Text(
                            //               "Berhasil! Anda akan mendapatkan notifikasi pengingat servis setelah selesai melakukan servis di bengkel kami"),
                            //           actions: [
                            //             TextButton(
                            //               child: Icon(
                            //                 Icons.close,
                            //                 color: Colors.red,
                            //               ),
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //                 setState(() {});
                            //               },
                            //             )
                            //           ],
                            //         );
                            //       }));
                            // }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  _jarakTempuhHarian() async {
    final res = await supabase
        .from('customer')
        .select('jarakTempuhHarian')
        .match({'email': supabase.auth.currentUser!.email}).execute();
    print("res jarak tempuh harian");
    print(res.data);
    if (res.data[0]['jarakTempuhHarian'] == null ||
        res.data[0]['jarakTempuhHarian'] <= 0) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Text(
                    "Anda harus menginput jarak tempuh harian agar bisa mendapatkan pengingat servis untuk sparepart yang pernah anda lakukan di kami"),
                actions: [
                  TextButton(
                    child: Text("oke"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      AwesomeNotifications().isNotificationAllowed().then(
                        (isAllowed) {
                          if (!isAllowed) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => WillPopScope(
                                onWillPop: () async => false,
                                child: AlertDialog(
                                  title: Text('Allow Notifications'),
                                  content: Text(
                                      'Our app would like to send you notifications'),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Don\'t Allow',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: ((context) {
                                              return WillPopScope(
                                                onWillPop: () async => false,
                                                child: AlertDialog(
                                                  content: Text(
                                                      "Maaf, anda harus mengijinkan notifikasi untuk aplikasi ini agar anda dapat mendapat pengingat servis"),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        "kembali",
                                                        selectionColor:
                                                            Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        return _jarakTempuhHarian();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            }));
                                        //Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Allow',
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        AwesomeNotifications()
                                            .requestPermissionToSendNotifications();
                                        Navigator.pop(context);
                                        AwesomeNotifications()
                                            .isNotificationAllowed()
                                            .then((isAllowed) {
                                          if (!isAllowed) {
                                            _jarakTempuhHarian();
                                          } else {
                                            _insertJarak();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return _insertJarak();
                          }
                        },
                      );
                    },
                  )
                ],
              ),
            );
          }));
    } else {}
  }

  Future<List<dynamic>> getUserReminder() async {
    final res = await supabase
        .from('reminder')
        .select('notificationId, remindDate, service(serviceId, serviceName)')
        .match({'email': supabase.auth.currentUser!.email}).execute();
    List<dynamic> reminderData = res.data;
    Future<List<NotificationModel>> notiflist =
        AwesomeNotifications().listScheduledNotifications();
    final localNotif = await notiflist;

    if (reminderData!.length > 0) {
      if (localNotif.length > 0) {
        for (var i = 0; i < localNotif.length; i++) {
          for (var j = 0; j < reminderData.length; j++) {
            if (j < reminderData.length - 1) {
              if (localNotif[i].content!.id ==
                      reminderData[j]['notificationId'] ||
                  (localNotif[i].content!.id! - 100) ==
                      reminderData[j]['notificationId']) {
                break;
              } else if (localNotif[i].content!.id !=
                      reminderData[j]['notificationId'] ||
                  (localNotif[i].content!.id! - 100) !=
                      reminderData[j]['notificationId']) {}
            }
            if (j == (reminderData.length - 1)) {
              if (localNotif[i].content!.id ==
                      reminderData[j]['notificationId'] ||
                  (localNotif[i].content!.id! - 100) ==
                      reminderData[j]['notificationId']) {
              } else if (localNotif[i].content!.id !=
                      reminderData[j]['notificationId'] ||
                  (localNotif[i].content!.id! - 100) !=
                      reminderData[j]['notificationId']) {
                print("cancel notif");
                AwesomeNotifications().cancel(localNotif[i].content!.id!);
              }
            }
          }
        }
      } else if (localNotif.length == 0) {}
    } else if (reminderData!.length == 0) {
      AwesomeNotifications().cancelAll();
    }

    for (var i = 0; i < reminderData.length; i++) {
      createServiceReminderNotification(
        reminderData[i]['notificationId'],
        '${reminderData[i]['remindDate']}',
        reminderData[i]['service']['serviceName'],
      );
      createServiceReminderNotification(
        reminderData[i]['notificationId'] + 100,
        '${DateTime.parse(reminderData[i]['remindDate']).subtract(Duration(days: 2)).toString()}',
        'Jangan lupa ya, 2 Hari lagi ${reminderData[i]['service']['serviceName']}',
      );
    }

    // print("iterasi 0");
    // if (localNotif.length > 0) {
    //   for (var i = 0; i < reminderData!.length; i++) {
    //     for (var j = 0; j < localNotif.length; j++) {
    //       if (j < reminderData.length - 1) {
    //         if (reminderData[i]['notificationId'] ==
    //             localNotif[j].content!.id) {
    //           if (DateTime.parse(reminderData[i]['remindDate']).compareTo(
    //                   DateUtils.dateOnly(
    //                       DateTime.parse(localNotif[j].content!.summary!))) ==
    //               0) {
    //             //return null;
    //           } else {
    //             AwesomeNotifications().cancel(localNotif[j].content!.id!);
    //             createServiceReminderNotification(
    //                 reminderData[i]['notificationId'],
    //                 '${reminderData[i]['remindDate']} 09:00:00');
    //           }
    //         } else if (reminderData[i]['notificationId'] !=
    //             localNotif[j].content!.id) {
    //           //return null;
    //         }
    //       } else if (j == reminderData.length - 1) {
    //         if (reminderData[i]['notificationId'] ==
    //             localNotif[j].content!.id) {
    //           if (DateTime.parse(reminderData[i]['remindDate']).compareTo(
    //                   DateUtils.dateOnly(
    //                       DateTime.parse(localNotif[j].content!.summary!))) ==
    //               0) {
    //             //return null;
    //           } else {
    //             AwesomeNotifications().cancel(localNotif[j].content!.id!);
    //             createServiceReminderNotification(
    //                 reminderData[i]['notificationId'],
    //                 '${reminderData[i]['remindDate']} 09:00:00');
    //           }
    //         } else if (reminderData[i]['notificationId'] !=
    //             localNotif[j].content!.id) {
    //           createServiceReminderNotification(
    //               reminderData[i]['notificationId'],
    //               '${reminderData[i]['remindDate']} 09:00:00');
    //         }
    //       }
    //     }
    //   }
    // } else if (localNotif.length == 0) {
    //   for (var i = 0; i < reminderData!.length; i++) {
    //     createServiceReminderNotification(reminderData[i]['notificationId'],
    //         '${reminderData[i]['remindDate']} 09:00:00');
    //   }
    // }

    print("setReminder selesai");
    final result = await notiflist;
    return result;
  }

//   setReminder(reminderData) async {
//     print("setReminder jalan");
//     //List<dynamic>? reminderData;
//     Future<List<NotificationModel>> notiflist =
//         AwesomeNotifications().listScheduledNotifications();
//     final localNotif = await notiflist;

//     DateTime newdate = DateTime.parse("2022-07-22");

//     String year = DateTime.parse("2022-07-22").year.toString();

//     print(
//         "buat ngecek notif di local udah sama belum idnya dengan yang ada di tabel reminder jalan");
//     print("reminderData");
//     print(reminderData.toString());
//     int iteration = 2;
// //buat ngecek notif di local udah sama belum idnya dengan yang ada di tabel reminder
// //  for (var i = 0; i < iteration;) {
//     print("i");
//     //print(i);
//     //if (i == 0) {
//     //print("iterasi 1");

//     if (reminderData!.length > 0) {
//       if (localNotif.length > 0) {
//         for (var i = 0; i < localNotif.length; i++) {
//           //int id = localNotif[i].content!.id!.toInt();
//           for (var j = 0; j < reminderData!.length; j++) {
//             if (j < reminderData.length - 1) {
//               // print(
//               //     'localnotifid: ${localNotif[i].content!.id} , reminderdataid: ${reminderData[j]['notificationId']}');
//               if (localNotif[i].content!.id ==
//                   reminderData[j]['notificationId']) {
//                 break;
//               } else if (localNotif[i].content!.id !=
//                   reminderData[j]['notificationId']) {}
//             }
//             if (j == (reminderData.length - 1)) {
//               if (localNotif[i].content!.id ==
//                   reminderData[j]['notificationId']) {
//               } else if (localNotif[i].content!.id !=
//                   reminderData[j]['notificationId']) {
//                 print("cancel notif");
//                 AwesomeNotifications().cancel(localNotif[i].content!.id!);
//               }
//             }
//           }
//         }
//         //iteration--;
//       } else if (localNotif.length == 0) {
//         //iteration--;
//         print(iteration);
//       }
//     } else if (reminderData!.length == 0) {
//       AwesomeNotifications().cancelAll();
//     }
//     //}
//     //else if (i == 1) {
//     print("iterasi 0");
//     if (localNotif.length > 0) {
//       for (var i = 0; i < reminderData!.length; i++) {
//         for (var j = 0; j < localNotif.length; j++) {
//           if (j < reminderData.length - 1) {
//             if (reminderData[i]['notificationId'] ==
//                 localNotif[j].content!.id) {
//               if (DateTime.parse(reminderData[i]['remindDate']).compareTo(
//                       DateUtils.dateOnly(
//                           DateTime.parse(localNotif[j].content!.summary!))) ==
//                   0) {
//                 return null;
//               } else {
//                 AwesomeNotifications().cancel(localNotif[j].content!.id!);
//                 createServiceReminderNotification(
//                     reminderData[i]['notificationId'],
//                     '${reminderData[i]['remindDate']} 09:00:00');
//               }
//             } else if (reminderData[i]['notificationId'] !=
//                 localNotif[j].content!.id) {
//               return null;
//             }
//           } else if (j == reminderData.length - 1) {
//             if (reminderData[i]['notificationId'] ==
//                 localNotif[j].content!.id) {
//               if (DateTime.parse(reminderData[i]['remindDate']).compareTo(
//                       DateUtils.dateOnly(
//                           DateTime.parse(localNotif[j].content!.summary!))) ==
//                   0) {
//                 return null;
//               } else {
//                 AwesomeNotifications().cancel(localNotif[j].content!.id!);
//                 createServiceReminderNotification(
//                     reminderData[i]['notificationId'],
//                     '${reminderData[i]['remindDate']} 09:00:00');
//               }
//             } else if (reminderData[i]['notificationId'] !=
//                 localNotif[j].content!.id) {
//               createServiceReminderNotification(
//                   reminderData[i]['notificationId'],
//                   '${reminderData[i]['remindDate']} 09:00:00');
//             }
//           }
//         }
//       }
//     } else if (localNotif.length == 0) {
//       for (var i = 0; i < reminderData!.length; i++) {
//         createServiceReminderNotification(reminderData[i]['notificationId'],
//             '${reminderData[i]['remindDate']} 09:00:00');
//       }
//     }

//     print("setReminder selesai");
//   }

  updateJarakTempuhHarian() async {
    _isLoading = true;

    if (_jarakTempuhController.text.isEmpty) {
      return context.showErrorSnackBar(
          message: "pastikan semua data sudah diisi dengan lengkap");
    } else if (_jarakTempuhController.text.isNotEmpty) {
      if (int.tryParse(_jarakTempuhController.text) == null) {
        return context.showErrorSnackBar(
            message: "jarak tempuh harian hanya bisa diisi angka");
      } else {
        if (int.tryParse(_jarakTempuhController.text)! <= 0) {
          return context.showErrorSnackBar(
              message: "jarak tempuh harian harus lebih dari 0");
        } else {
          final res = await supabase.from('customer').update({
            'jarakTempuhHarian': int.parse(_jarakTempuhController.text)
          }).match({'email': supabase.auth.currentUser!.email}).execute();
          if (res.error != null) {
            _isLoading = false;
            context.showErrorSnackBar(message: res.error!.message);
          } else {
            Navigator.of(context).pop();
            _isLoading = false;
            setState(() {});
            return showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    content: Text(
                        "Berhasil! Anda akan mendapatkan notifikasi pengingat servis setelah selesai melakukan servis di bengkel kami"),
                    actions: [
                      TextButton(
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          setState(() {});
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      )
                    ],
                  );
                }));
          }
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../connection/constants.dart';

class HistoryNotificationPage extends StatefulWidget {
  const HistoryNotificationPage({super.key});

  @override
  State<HistoryNotificationPage> createState() =>
      _HistoryNotificationPageState();
}

class _HistoryNotificationPageState extends State<HistoryNotificationPage> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  Container(
                    //color: Colors.red,
                    alignment: Alignment.center,
                    //margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      "Notification",
                      style: GoogleFonts.roboto(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 52, 82),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height - 115,
                //color: Colors.red,
                child: FutureBuilder<List<dynamic>>(
                  future: getReminder(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.length > 0) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 17, 52, 82)))),
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 0),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                  selected: false,
                                  tileColor: Colors.amber,
                                  selectedTileColor: Colors.amber,
                                  title: Text("Ayo ganti sparepart"),
                                  subtitle: Text(
                                      '${snapshot.data![index]['service']['serviceName']} kamu sudah harus diganti'),
                                  trailing: Text(
                                    DateTime.now().difference(DateTime.parse(snapshot.data![index]['remindDate'])).inMinutes <= 60 &&
                                            DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data![index]
                                                            ['remindDate']))
                                                    .inMinutes >
                                                0
                                        ? "${DateTime.now().difference(DateTime.parse(snapshot.data![index]['remindDate'])).inMinutes} minutes ago"
                                        : DateTime.now()
                                                        .difference(DateTime.parse(
                                                            snapshot.data![index]
                                                                ['remindDate']))
                                                        .inMinutes >
                                                    60 &&
                                                DateTime.now()
                                                        .difference(DateTime.parse(snapshot.data![index]['remindDate']))
                                                        .inDays <=
                                                    24
                                            ? "${DateTime.now().difference(DateTime.parse(snapshot.data![index]['remindDate'])).inHours} hours ago"
                                            : DateTime.now().difference(DateTime.parse(snapshot.data![index]['remindDate'])).inHours > 24
                                                ? "${DateTime.now().difference(DateTime.parse(snapshot.data![index]['remindDate'])).inDays} days ago"
                                                : "now",
                                  ),
                                ));
                          },
                        ),
                      );
                    } else {
                      return Text("tidak ada notifikasi");
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<dynamic>> getReminder() async {
  final res = await supabase
      .from('reminder')
      .select('notificationId, remindDate, service(serviceId, serviceName)')
      .match({'email': supabase.auth.currentUser!.email})
      .order('remindDate', ascending: false)
      .execute();
  List<dynamic> reminderData = res.data;
  print("reminderData");
  print(reminderData);
  for (var i = 0; i < res.data.length;) {
    if (DateTime.parse(reminderData[i]['remindDate'])
        .isBefore(DateTime.now())) {
      i++;
      break;
    } else {
      reminderData.removeAt(i);
    }
  }
  return reminderData;
}

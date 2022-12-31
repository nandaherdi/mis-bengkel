import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../connection/constants.dart';

class ReminderListWidget extends StatelessWidget {
  const ReminderListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //color: Colors.amber,
          margin: EdgeInsets.only(bottom: 0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Jadwal Servis",
            style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 17, 52, 82)),
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: getCustomerReminder(),
          builder: (context, snapshot) {
            print("getCustomerReminder");
            print(snapshot.data);
            if (snapshot.hasData) {
              if (snapshot.data!.length != 0) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        //height: 400,
                        child: ListTile(
                          //dense: true,
                          visualDensity: VisualDensity(vertical: 0),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          selected: false,
                          tileColor: Colors.amber,
                          selectedTileColor: Colors.amber,
                          title: Text(
                              '${DateTime.parse(snapshot.data![index]['remindDate']).year.toString()}-${DateTime.parse(snapshot.data![index]['remindDate']).month.toString()}-${DateTime.parse(snapshot.data![index]['remindDate']).day.toString()}'),
                          //subtitle: Text("asd"),
                          trailing: Text(
                              snapshot.data![index]['service']['serviceName']),

                          // Text(dataDetailServiceUser[index]
                          //     ['serviceId']),
                        ),
                      );
                    });
              } else {
                return Text("anda belum memiliki jadwal service apapun");
              }
            } else {
              return Text("anda belum memiliki jadwal service apapun");
            }
          },
        )
      ],
    );
  }
}

Future<List<dynamic>> getCustomerReminder() async {
  //final List<dynamic> getData;
  final res = await supabase
      .from('reminder')
      .select('remindDate, notificationId, service(serviceId, serviceName)')
      .match({'email': supabase.auth.currentUser!.email})
      .order('remindDate', ascending: true)
      .execute();
  List<dynamic> dataReminderCustomer = res.data;
  return dataReminderCustomer;
}

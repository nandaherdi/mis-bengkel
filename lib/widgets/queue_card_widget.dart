import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../connection/constants.dart';

class QueueWidget extends StatelessWidget {
  const QueueWidget({
    Key? key,
    required this.bookedColor,
    required this.onProccessColor,
    required this.waitingColor,
  }) : super(key: key);

  final List<Color> onProccessColor;
  final List<Color> waitingColor;
  final List<Color> bookedColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return StreamBuilder<List<dynamic>>(
          stream: supabase.from('queue').stream(['id']).execute(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                // height: constraints.maxHeight,
                // width: constraints.maxWidth,
                child: Row(
                  children: [
                    SingleQueueCardWidget(
                      titleInfo: "On Proccess",
                      info:
                          //"Antrian kendaraan yang sedang dalam proses pengerjaan servis",
                          "Kendaraan sedang dalam pengerjaan service",
                      antrianNumber:
                          snapshot.data![0]['on_proccess'].toString(),
                      bgColor: onProccessColor,
                      cardTitle: "on\nproccess",
                      bottPosition: -100,
                      rightPosition: -100,
                      leftMargin: 0,
                      rightMargin: 0,
                      titleTopMargin: 5,
                    ),
                    SingleQueueCardWidget(
                      titleInfo: "Waiting",
                      info:
                          //"Antrian kendaraan yang menunggu giliran pengerjaan servis di lokasi bengkel",
                          "Kendaraan sedang menunggu pengerjaan service dilakukan",
                      antrianNumber: snapshot.data![0]['waiting'].toString(),
                      bgColor: waitingColor,
                      cardTitle: "waiting",
                      bottPosition: 50,
                      rightPosition: -100,
                      leftMargin: 10,
                      rightMargin: 0,
                      titleTopMargin: 15,
                    ),
                    SingleQueueCardWidget(
                      titleInfo: "Booked",
                      info:
                          //"Antrian servis yang melakukan booking melalui aplikasi, namun belum tiba di lokasi bengkel",
                          "Customer yang melakukan booking melalui aplikasi, namun belum tiba di lokasi bengkel",
                      antrianNumber: snapshot.data![0]['booked'].toString(),
                      bgColor: bookedColor,
                      cardTitle: "booked",
                      bottPosition: -50,
                      rightPosition: 50,
                      leftMargin: 10,
                      rightMargin: 0,
                      titleTopMargin: 15,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          });
    });
  }
}

class SingleQueueCardWidget extends StatelessWidget {
  const SingleQueueCardWidget({
    Key? key,
    required this.antrianNumber,
    required this.bgColor,
    required this.cardTitle,
    required this.bottPosition,
    required this.rightPosition,
    required this.leftMargin,
    required this.rightMargin,
    required this.titleTopMargin,
    required this.info,
    required this.titleInfo,
  }) : super(key: key);

  final String antrianNumber;
  final String cardTitle;
  final List<Color> bgColor;
  final double bottPosition;
  final double rightPosition;
  final double leftMargin;
  final double rightMargin;
  final double titleTopMargin;
  final String info;
  final String titleInfo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  title: Text(
                    titleInfo,
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    info,
                    textAlign: TextAlign.center,
                  ),
                );
              }));
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(
            left: leftMargin,
            right: rightMargin,
            bottom: 20,
          ),
          width: 110.909,
          height: 145,
          // width: (MediaQuery.of(context).size.width / 3) - 6.7,
          // height: MediaQuery.of(context).size.height / 4.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: bgColor),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                  bottom: bottPosition,
                  right: rightPosition,
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(colors: bgColor),
                        borderRadius: BorderRadius.all(Radius.circular(300)),
                      ),
                    ),
                  )),
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                //color: Colors.blue,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: titleTopMargin, left: 15),
                              height: MediaQuery.of(context).size.height / 20,
                              width: MediaQuery.of(context).size.width / 6,
                              //color: Colors.amber,
                              child: Text(cardTitle,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal)
                                  // TextStyle(
                                  //   color: Colors.white,
                                  //   letterSpacing: 1,
                                  // ),
                                  )),
                          Container(
                            margin: EdgeInsets.only(
                              top: 12,
                              right: 10,
                              bottom: 20,
                            ),
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 20,
                            //color: Colors.amber,
                            child: Icon(
                              size: 15,
                              Icons.info_outline_rounded,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 0, left: 10, bottom: 0),
                        //color: Colors.black,
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          antrianNumber,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 80,
                          ),
                          // TextStyle(
                          //   color: Colors.white,
                          //   fontSize: 80,
                          //   fontFamily: 'Roboto',
                          //   fontWeight: FontWeight.w200,
                          // ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

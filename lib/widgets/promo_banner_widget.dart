import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../connection/constants.dart';

class PromoBannerWidget extends StatelessWidget {
  const PromoBannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getPromoData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length != 0) {
//--------------------------------\/pengecekan periode promo\/-------------------------------------------
              for (var i = 0; i < snapshot.data!.length;) {
                if (DateTime.now().compareTo(
                            DateTime.parse(snapshot.data![i]['startPromo'])) >=
                        0 &&
                    DateTime.now().compareTo(
                            DateTime.parse(snapshot.data![i]['endPromo'])) <=
                        0) {
                  i++;
                } else {
                  snapshot.data!.removeAt(i);
                }
              }
//--------------------------------/\pengecekan periode promo/\-------------------------------------------

              print("jumlah data");
              print(snapshot.data!.length.toString());
              print("isi data banner");
              print(snapshot.data);
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Promo",
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 52, 82)),
                    ),
                  ),
                  Container(
                    //color: Colors.amber,
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                        itemCount: snapshot.data!.length,
                        pageSnapping: true,
                        itemBuilder: (context, index) {
                          return Container(
                              //margin: EdgeInsets.only(bottom: 20),
                              // margin:
                              //     EdgeInsets.symmetric(horizontal: 10),
                              child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              snapshot.data![index]['imagePath'],
                              fit: BoxFit.fitWidth,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ));
                        }),
                  ),
                ],
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

Future<List<dynamic>> getPromoData() async {
  final res = await supabase.from('promo').select('*').execute();
  List<dynamic> response = res.data;
  return response;
}

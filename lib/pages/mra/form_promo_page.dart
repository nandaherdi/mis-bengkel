import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';

import '../../connection/constants.dart';

class FormPromoPage extends StatefulWidget {
  const FormPromoPage({super.key});

  @override
  State<FormPromoPage> createState() => _FormPromoPageState();
}

class _FormPromoPageState extends State<FormPromoPage> {
  XFile? selectedImage;
  String? selectedImagePath;
  String? startDate;
  String? endDate;
  //DateTimeRange? dateRange;
  DateTimeRange? dateRange;
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Text(
                    "Form",
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
                    "Promo",
                    style: GoogleFonts.roboto(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 52, 82),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  color: Colors.lightBlue,
                  child: selectedImage == null
                      ? Icon(Icons.image)
                      : Image.file(
                          File(selectedImage!.path),
                          fit: BoxFit.fitWidth,
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        final imageFile = await getImage();
                        print("image file inside button");
                        print(imageFile.path);
                        selectedImage = imageFile;
                        setState(() {});
                      },
                      child: Text("pilih banner dari galery")),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3,
                          //color: Colors.amber,
                          child: ElevatedButton(
                            onPressed: () {
                              pickDateRange(context);
                            },
                            child: Text(getStartDate()),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width / 3,
                          //color: Colors.amber,
                          child: ElevatedButton(
                            onPressed: () {
                              pickDateRange(context);
                            },
                            child: Text(getEndDate()),
                          )),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        _upload();
                      },
                      child: Text("upload banner")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  String getStartDate() {
    if (dateRange == null) {
      return 'Start Promo';
    } else {
      return DateFormat('yyyy-MM-dd').format(dateRange!.start);
    }
  }

  String getEndDate() {
    if (dateRange == null) {
      return 'End Promo';
    } else {
      return DateFormat('yyyy-MM-dd').format(dateRange!.end);
    }
  }

  Future<void> _upload() async {
    //XFile? imageFile;
    // print("daterange");
    // print(dateRange);
    // print("selectedImage");
    // print(selectedImage!.path);
    // print("imageFile");
    //print(imageFile);
    if (dateRange == null || selectedImage == null) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Silahkan lengkapi data"),
            );
          });
    } else if (dateRange != null && selectedImage != null) {
      final bytes = await selectedImage!.readAsBytes();
      final fileExt = selectedImage!.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      print("filepath");
      print(filePath);

      final response =
          await supabase.storage.from('promo').uploadBinary(filePath, bytes);
      print("response");
      print(response.data);
      print("error");
      print(response.error);
      print("startDate");
      print(getStartDate());
      print("endDate");
      print(getEndDate());
      if (response.error == null) {
        final imageUrlResponse =
            supabase.storage.from('promo').getPublicUrl(filePath);
        print(imageUrlResponse.data);
        final insertPromoData = await supabase.from('promo').insert({
          'startPromo': getStartDate(),
          'endPromo': getEndDate(),
          'imagePath': imageUrlResponse.data,
        }).execute();

        print("insertpromodata.data");
        print(insertPromoData.data);
        print("insertpromodata.error");
        print(insertPromoData.error);

        if (insertPromoData.error == null) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text("Banner promo berhasil diupload"),
                );
              });
        } else {
          return context.showErrorSnackBar(
              message: insertPromoData.error.toString());
        }
      } else {
        return context.showErrorSnackBar(message: response.error.toString());
      }
    }

    // setState(() => _isLoading = false);

    //final error = response.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    //   return;
    // }

    // widget.onUpload(imageUrlResponse.data!);
  }
}

getImage() async {
  final _picker = ImagePicker();
  final imageFile = await _picker.pickImage(
    source: ImageSource.gallery,
  );
  if (imageFile == null) {
    return;
  } else {
    return imageFile;
  }
}

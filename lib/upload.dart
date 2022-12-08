
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: (){
          createExcel();
        }, child: Icon(Icons.download)),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: (){}, child: Icon(Icons.upload)),
      ],
    );
  }
  Future<void> createExcel() async {
    // Create a new Excel document.
    final Workbook workbook =  Workbook();
    final Worksheet sheeta = workbook.worksheets[0];
    sheeta.getRangeByName("A1").setText("Products");
    sheeta.getRangeByName("B1").setText("Prices");


// Save the document.
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename ='$path/Output.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }

}

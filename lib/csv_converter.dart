
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;


class CsvConverter extends StatefulWidget {
  const CsvConverter({Key? key}) : super(key: key);

  @override
  State<CsvConverter> createState() => _CsvConverterState();
}

class _CsvConverterState extends State<CsvConverter> {
  List<List<dynamic>> data = [];
  String? filePath;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CSV Converter"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                createExcel();
              },
              child: Text("Create Excel"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                pickFile();
              },
              child: Text("Upload CSV File")),
          ListView.builder(
              itemCount: data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    leading: Text(data[index][0].toString()),
                    title: Text(data[index][0].toString()),
                    // trailing:Text(data[index][0].toString()),
                  ),
                );
              }),
        ],
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextField(
      //         controller: textEditingController,
      //         decoration:InputDecoration(
      //           hintText: "Enter value",
      //           border: OutlineInputBorder(),
      //         ),
      //       ),
      //     ),
      //     ElevatedButton(onPressed: (){
      //       SecondScreen.enterValue.value = textEditingController.text;
      //         Navigator.pushNamed(context, '/second');
      //
      //       // SecondScreen();
      //     },
      //         child:Icon(Icons.send) ,),
      //     SizedBox(height: 100,),
      //     ElevatedButton(
      //         onPressed: (){
      //
      //         },
      //         child: Icon(Icons.download))
      //   ],
      //
      // ),
    );
  }
  Future<void> createExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheeta = workbook.worksheets[0];
    sheeta.getRangeByName("A1").setText("Products");
    sheeta.getRangeByName("B1").setText("Prices");

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/Output.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    filePath = result.files.first.path!;
    final input = File(filePath!).openRead();

    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    setState(() {
      data = fields;
    });
  }

}

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<List<dynamic>> data = [];
  // List<String> data = [];
  String? filePath;

  List<ModelItem> list = [];


  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Enter Value"),
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
                _importFromExcel();
              },
              child:Text("Upload Excel File") ,
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed("/third");
          //
          //     },
          //     child: Text("CSV Converter"),
          // )

          Expanded(child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
            return ListTile(
              leading: Text(list[index].id),
              title: Text(list[index].name),
              subtitle: Text(list[index].price),
            );
          },),)

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
    sheeta.getRangeByName("A1").setText("id");
    sheeta.getRangeByName("B1").setText("name");
    sheeta.getRangeByName("C1").setText("price");
    sheeta.getRangeByName("D1").setText("description");

    sheeta.getRangeByName("A2").setText("1");
    sheeta.getRangeByName("B2").setText("oil");
    sheeta.getRangeByName("C2").setText("250");
    sheeta.getRangeByName("D2").setText("some dummy details");

    sheeta.getRangeByName("A3").setText("2");
    sheeta.getRangeByName("B3").setText("Suger");
    sheeta.getRangeByName("C3").setText("1000");
    sheeta.getRangeByName("D3").setText("some dummy details");


    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/Output.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }


  // List<String> rowdetail = [];
  List<List<dynamic>> rowdetail = [];

  _importFromExcel() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    filePath = result.files.first.path!;
    var bytes = File(filePath!).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table]?.maxCols);
      print(excel.tables[table]?.maxRows);


      excel.tables[table]!.rows.remove(0);

      for (List row in excel.tables[table]!.rows) {
        print("row element 1 ${row[0]}");

        if(row[0] != "id") {
          list.add(ModelItem(id: row[0].toString(), name: row[1], price: row[2].toString(), description: row[3]));

        }

      }
      setState(() {

      });

      print("row element ssss ${list.length}");

      list.forEach((element) {
        print("row element ssss ${element.toMap()}");

      });


    }



    // var file = "Path_to_pre_existing_Excel_File/excel_file.xlsx";
    //  var file = "$Path/output.xlsx";
    // var dir = (await getExternalStorageDirectory());
    // var filePath=dir!.path + '/Output.xlsx';
    // var filePath = '/storage/emulated/0/Android/Output.xlsx';
    // var bytes = File(filePath).readAsBytesSync();
    // var excel = Excel.decodeBytes(bytes);
    // for (var table in excel.tables.keys) {
    //   print(table);
    //   for (var row in excel.tables[table]!.rows) {
    //     rowdetail.add(row);
    //   }
    // }
  }
}

class ModelItem {
  String id;
  String name;
  String price;
  String description;

  ModelItem({required this.id,required this.name,required this.price,required this.description});

  Map<String, dynamic> toMap () => {
    "id" : id,
    "name" : name,
    "price" : price,
    "description" : description,
  };

}

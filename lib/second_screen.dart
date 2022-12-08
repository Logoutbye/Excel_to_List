
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);
  static ValueNotifier<String> enterValue = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Entered Value"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable:enterValue,
              builder: (context,String newvalue,_ ){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: Text(

                        newvalue,style: TextStyle( fontSize: 20),
                    ),
                  ),
                );

              },
            ),
          ],
        ),
      ),
    );
  }
}


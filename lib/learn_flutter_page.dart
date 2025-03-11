import 'package:flutter/material.dart';

import 'main.dart';

class LearnFlutterPage extends StatefulWidget {
  const LearnFlutterPage({super.key});

  @override
  State<LearnFlutterPage> createState() => _LearnFlutterPageState();
}

class _LearnFlutterPageState extends State<LearnFlutterPage> {
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Image.asset('images/eistein.jpg'),
          SizedBox(height: 10),
          const Divider(color: Colors.black),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            color: Colors.blueGrey,
            width: double.infinity,
            child: Center(
              child: Text(
                "Texto de teste",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSwitch ? Colors.amber : Colors.green,
            ),
            onPressed: () {
              debugPrint('Apertou!');
            },
            child: Text("Aperta eu aqui"),
          ),
          OutlinedButton(
            onPressed: () {
              debugPrint('Apertou!');
            },
            child: Text("Aperta eu aqui"),
          ),
          TextButton(
            onPressed: () {
              debugPrint('Apertou!');
            },
            child: Text("Aperta eu aqui"),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              debugPrint("Ativei ein");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.local_fire_department, color: Colors.amber),
                Icon(Icons.local_fire_department),
                Icon(Icons.local_fire_department),
                Icon(Icons.local_fire_department),
                Text("Alo"),
              ],
            ),
          ),
          Switch(
            value: isSwitch,
            onChanged: (bool newBool) {
              setState(() {
                isSwitch = newBool;
              });
            },
          ),
        ],
      ),
    );
  }
}

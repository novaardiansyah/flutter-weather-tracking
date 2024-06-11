import 'package:flutter/material.dart';
import 'package:weather_tracking/pages/result.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController placeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Nova Ardiansyah", style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: Colors.blueAccent,
          centerTitle: false,
        ),

        body: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'ex. Jakarta, Indonesia.'),
                  controller: placeController,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Result(place: placeController.text);
                    }));
                  }, 
                  child: const Text('Search')
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
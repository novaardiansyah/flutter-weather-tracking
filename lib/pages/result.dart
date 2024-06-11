import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;

  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather/?q=${widget.place}&units=metric&appid=4100549ba1c1150a75340a66131f5e9f"));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Something went wrong with request!');
    }
  }

  String _formatTimezone(int timezoneInSeconds) {
    final hours = timezoneInSeconds ~/ 3600;
    final sign = hours >= 0 ? '+' : '-';
    final formattedHours = hours.abs().toString().padLeft(2, '0');
    return 'GMT$sign$formattedHours';
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Find your weather info", style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          )
        ),

        body: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: FutureBuilder(
            future: getDataFromAPI(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${data['name']} - ${data['weather'][0]['description']}", style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      )),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FixedColumnWidth(150),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Weather:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text("${data['weather'][0]['main']} "),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 18,
                                        offset: const Offset(0, 3), // mengatur posisi shadow
                                      ),
                                    ],
                                  ),
                                  child: Image(
                                    image: NetworkImage("https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png"),
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ]),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Temperature:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['main']['feels_like']} °"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Wind Speed:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['wind']['speed']} m/s"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Sea Level:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['main']['sea_level'] ?? 'n/a'} hPa"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Ground Level:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['main']['grnd_level'] ?? 'n/a'} hPa"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Pressure:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['main']['pressure']} hPa"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Humidity:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['main']['humidity']} %"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Coordinates:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Lat: ${data['coord']['lat']}, Lon: ${data['coord']['lon']}"),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Country/State:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Image(
                                  alignment: Alignment.centerLeft,
                                  image: NetworkImage("https://flagsapi.com/${data['sys']['country']}/shiny/64.png"),
                                  width: 20,
                                  height: 20,
                                ),
                                Text(" ${data['name']}")
                              ]),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Timezone:"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_formatTimezone(data['timezone'])),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('Your location not found.');
              }
            },
          )
        )
      )
    );
  }
}
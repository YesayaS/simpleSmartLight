import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'handle_json.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: "LED Blink",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool connected;
  late IOWebSocketChannel channel;
  late String ledStatus;

  //String _status = '';
  // var url =
  //     Uri.parse('http://192.168.100.15:80/update'); //IP Address which is configured in NodeMCU Sketch
  // var response;

  @override
  void initState() {
    connected = false;
    ledStatus = "Turn On";
    //getInitLedState(); // Getting initial state of LED, which is by default on

    var wadu = '{"name": "ledtest", "connected_status": "off", "led_status": "off", "R": 0, "G": 0, "B": 0}';
    var parsedwadu = json.decode(wadu);
    var led = leddata.fromJson(parsedwadu);
    led.connectedStatus = "wow";
    print('${led.connectedStatus}');

    Future.delayed(Duration.zero,() async {
        channelConnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  // Future getInitLedState() async {
  //   try {
  //     response = await http.get(url);//, headers: {"Accept": "plain/text"});
  //     print('Response status: ${response.statusCode}');
  //     setState(() {
  //       _status = 'On';
  //     });
  //   } catch (e) {
  //     // If NodeMCU is not connected, it will throw error
  //     print(e);
  //     if (this.mounted) {
  //       setState(() {
  //         _status = 'Not Connected';
  //       });
  //     }
  //   }
  // }

  channelConnect() {
    try{
         channel = IOWebSocketChannel.connect("ws://192.168.100.30:81/"); //channel IP : Port
         channel.stream.listen((message) {
            print(message);
            setState(() {
              //action if message is coming
              if(message == "Connected"){
                connected = true;
                channel.sink.add("Connected!");
              }
            });
          }, 
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
              print("ws Disconnected");
              connected = false;
          });    
        },
        onError: (error) {
             print(error.toString());
        },);
    }catch (_){
      print("error on connecting to websocket.");
    }
  }

  Future<void> toggleLed() async {
    if (ledStatus == "Turn On"){
      channel.sink.add("on");
      setState(() {
        ledStatus = "Turn Off";
      }); 
    } else{
      channel.sink.add("off");
      setState(() {
        ledStatus = "Turn On";
      }); 
    }    
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
      appBar: AppBar(
        title: Text("NodeMCU With Flutter"),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: connected?Text("Websocket: Connected"):Text("Websocket: Disconnected")
                  ),
                  ElevatedButton(
                    onPressed: toggleLed,
                    child: 
                      Text("$ledStatus")
                  )
                ]                  
              ),
            ),
            // Text(
            //   'Server: $_status',
            //   textAlign: TextAlign.center,
            // )
          ],
        );
      }),
    );
  }
}
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class LocationSocket {
  // var wsUrl = "ws://192.168.29.180:8000/ws/buslocation/";
  // var wsUrl =
  //     "ws://congenial-adventure-v7ww59w77r4fpvwg-8000.app.github.dev/ws/buslocation/";
  String? wsUrl;
  int? busid;

  late WebSocketChannel ws;

  LocationSocket() {
    // start();
  }

  Future<void> start() async {
    var client = http.Client();
    if (wsUrl == null || busid == null) {
      try {
        var result = await client.get(
          Uri.parse(
            "https://json.extendsclass.com/bin/dcda445ef811",
          ),
        );
        var msg = jsonDecode(result.body);
        wsUrl = msg["socketUrl"];
        busid = msg["busid"];
      } on Exception {
        wsUrl =
            "wss://congenial-adventure-v7ww59w77r4fpvwg-8000.app.github.dev/ws/buslocation/";
        busid = 2;
      }
    } 
    print("wsurl from config file : $wsUrl");
    ws = WebSocketChannel.connect(Uri.parse("$wsUrl$busid"));
    
  }

  void sendMsg(String msg) {
    ws.sink.add(msg);
  }

  void dispose() {
    ws.sink.close();
  }
}

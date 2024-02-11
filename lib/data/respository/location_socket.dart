import 'package:web_socket_channel/web_socket_channel.dart';

class LocationSocket {
  // var wsUrl = "ws://192.168.29.180:8000/ws/buslocation/";
  var wsUrl =
      "ws://congenial-adventure-v7ww59w77r4fpvwg-8000.app.github.dev/ws/buslocation/";
  late WebSocketChannel ws;

  LocationSocket(int busId) {
    ws = WebSocketChannel.connect(Uri.parse("$wsUrl$busId"));
  }

  void sendMsg(String msg) {
    ws.sink.add(msg);
  }

  void dispose() {
    ws.sink.close();
  }
}

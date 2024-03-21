import 'dart:convert';

import 'package:http/http.dart' as http;

class BackendApi {
  // final _serverurl = "http://192.168.29.180:8000/";
  // final _serverurl =
  //     "https://congenial-adventure-v7ww59w77r4fpvwg-8000.app.github.dev/";
  // final _serverurl =
  //     "https://upgraded-yodel-9g4qq9grp9pf747q-8000.app.github.dev/";
  String? _serverurl;
  final _getBustApi = "api/busdetails/";

  var client = http.Client();

  Future<List<Map<String, dynamic>>> getBuses() async {
    var exc = true;
    if (_serverurl == null) {
      try {
        var result = await client
            .get(Uri.parse("https://json.extendsclass.com/bin/dcda445ef811"));
        _serverurl = jsonDecode(result.body)["url"];
        print("url from config file : $_serverurl");
        exc = false;
      } on Exception {
        _serverurl =
            "https://congenial-adventure-v7ww59w77r4fpvwg-8000.app.github.dev/";
      }
    } else {
      exc = true;
    }

    var url = Uri.parse(_serverurl! + _getBustApi);
    var response = await http.get(url);
    print(response.body);
    // var data = jsonDecode(response.body) as List<Map<String, dynamic>>;
    var data = (jsonDecode(response.body) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    _serverurl = exc ? null : _serverurl;
    return data;
  }
}

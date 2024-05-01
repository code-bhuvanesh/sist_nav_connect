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
        var result = await client.get(
            Uri.parse("https://api.jsonbin.io/v3/b/6624a9ecad19ca34f85d9496"),
            headers: {
              "X-Master-Key":
                  r"$2a$10$lP.Bl674yhOr.IWCNOoc6etqFJblV9c8Neu7qsKc8D88VmpmkrmZW"
            });

        ///for testing only remove it in production
        print(
            "read json data  '\$\$2a\$10\$lP.Bl674yhOr.IWCNOoc6etqFJblV9c8Neu7qsKc8D88VmpmkrmZW' : ${jsonDecode(result.body)}");
        _serverurl = jsonDecode(result.body)["record"]["url"];
        print("url from config file : $_serverurl");
        exc = false;
      } on Exception {
        print(
            "**********************************exception json************************************");
        _serverurl =
            "https://probable-chainsaw-94wwxrw4xqr2p46v-8000.app.github.dev/";
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

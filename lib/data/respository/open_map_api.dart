import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers.dart';

class OpenMapApi {
  var client = http.Client();
  Future<List<LatLng>> getInbetweenPoints(
      {List<LatLng>? pointsLatLng, List<List<double>>? pointsdouble}) async {
    var header = {
      "Content-Type": "application/json",
      "Authorization":
          "5b3ce3597851110001cf6248e39436fe480248a0901675a1fe89ff0e",
    };
    var body = {};
    if (pointsLatLng != null) {
      body = {
        "coordinates":
            pointsLatLng.map((e) => [e.longitude, e.latitude]).toList(),
      };
    } else {
      body = {
        "coordinates": pointsdouble,
      };
    }

    var mapUrl = "https://api.openrouteservice.org/v2/directions/driving-car";

    var response = await client.post(
      Uri.parse(mapUrl),
      headers: header,
      body: jsonEncode(body),
    );
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonEncode(body));
    print(data["routes"][0]["geometry"]);
    var polyPointEncoded = data["routes"][0]["geometry"];
    print(decodePolyline(polyPointEncoded).unpackPolyline());
    return decodePolyline(polyPointEncoded).unpackPolyline();
    // return [];
  }
}

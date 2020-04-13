import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'credentials.dart';

class PlacesProvider with ChangeNotifier {
  Future<List<String>> placesApiCall(String place) async {
    List<String> placeList = [];

    if (place != null && place.isNotEmpty) {
      String BASE_URL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String REQUEST = '$BASE_URL?input=$place&key=$GOOGLE_PLACES_API_KEY';
      final result = await http.get(REQUEST);
      print(result.body);
      final placeResult = json.decode(result.body);
      if (placeList.length > 0) {
        placeList.clear();
      }
      for (Map place in placeResult['predictions']) {
        placeList.add(place['description']);
      }

      return placeList;
    }
    notifyListeners();
//    print('places result ' + json.decode(result.body));
  }
}

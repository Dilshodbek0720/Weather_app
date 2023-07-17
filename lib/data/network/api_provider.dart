import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:n8_default_project/data/models/main/weather_main_model.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/network_utils.dart';
import 'package:n8_default_project/utils/constants.dart';

import '../models/detail/one_call_data.dart';

class ApiProvider {

  static Future<UniversalData> getWeatherOneCallData({
    required double lat,
    required double long,
})async{
    Uri uri = Uri.https(
      baseUrlWithoutHttp,
        "/data/2.5/onecall",
      {
        "appid":apiKeyForMain,
        "lat":lat.toString(),
        "lon":long.toString(),
        "exclude":"minutely,current",
        "units":"metric"
      },
    );

    try{
      http.Response response = await http.get(uri);
      if(response.statusCode == HttpStatus.ok){
        return UniversalData(
          data: OneCallData.fromJson(jsonDecode(response.body))
        );
      }
      return handleHttpErrors(response);
    } on SocketException{
      return UniversalData(error: "Internet Error!");
    } on FormatException{
      return UniversalData(error: "Format error!");
    } catch (err) {
      debugPrint("ERROR:$err. ERROR TYPE: ${err.runtimeType}");
      return UniversalData(error: err.toString());
    }

  }



  static Future<UniversalData> getMainWeatherDataByLatLong({
    required double lat,
    required double long,
  }) async {
    Uri uri = Uri.https(
      baseUrlWithoutHttp,
      "/data/2.5/weather",
      {
        "appid": apiKeyForMain,
        "lat": lat.toString(),
        "lon": long.toString(),
      },
    );

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        return UniversalData(
            data: WeatherMainModel.fromJson(jsonDecode(response.body)));
      }
      return handleHttpErrors(response);
    } on SocketException {
      return UniversalData(error: "Internet Error!");
    } on FormatException {
      return UniversalData(error: "Format Error!");
    } catch (err) {
      return UniversalData(error: err.toString());
    }
  }

  static Future<UniversalData> getMainWeatherDataByQuery(
      {required String query}) async {
    //Uri uri = Uri.parse("$baseUrl/data/2.5/weather?q=$query&appid=$apiKeyForMain");

    Uri uri = Uri.https(
      baseUrlWithoutHttp,
      "/data/2.5/weather",
      {
        "appid": apiKeyForMain,
        "q": query,
      },
    );

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        {
          return UniversalData(
            data: WeatherMainModel.fromJson(jsonDecode(response.body)),
            statusCode: response.statusCode,
          );
        }
      }
      return handleHttpErrors(response);
    } on SocketException {
      return UniversalData(error: "Internet Error!");
    } on FormatException {
      return UniversalData(error: "Format Error!");
    }
    // on TypeError{
    //   return UniversalData(error: "TYPE ERROR");
    // }
    catch (err) {
      return UniversalData(error: err.toString());
    }
  }

}

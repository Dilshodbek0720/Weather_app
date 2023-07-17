import 'dart:convert';
import 'dart:io';

import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:http/http.dart' as http;

UniversalData handleHttpErrors(http.Response response){
  switch (response.statusCode){
    case HttpStatus.badRequest:
      {
        return UniversalData(
          error: "Bad request exception",
          statusCode: response.statusCode
        );
      }
    case HttpStatus.unauthorized:
      {
        return UniversalData(
          error: jsonDecode(response.body)['message'],
          statusCode: response.statusCode
        );
      }
    case HttpStatus.forbidden:
      {
        return UniversalData(
          error: jsonDecode(response.body)['message'],
          statusCode: response.statusCode
        );
      }
    case HttpStatus.notFound:
      {
        return UniversalData(
          error: jsonDecode(response.body)["message"],
          statusCode: response.statusCode,
        );
      }
    case HttpStatus.internalServerError:
      {
        return UniversalData(
          error:
          "Error occurred while Communication with Server with StatusCode : ${response.statusCode}",
          statusCode: response.statusCode,
        );
      }
    case HttpStatus.notImplemented:
      {
        return UniversalData(
          error: "Server Error : ${response.statusCode}",
          statusCode: response.statusCode,
        );
      }
    default:
      {
        return UniversalData(
          error: "Unknown Error occurred!",
          statusCode: response.statusCode
        );
      }
  }
}
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hepy/app/Utils/api/custom_exception.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  Future<http.Response> post(
      {String apiurl = '',
      Map<String, String>? header,
      Map<String, dynamic>? body}) async {
    var urlParse = Uri.parse(apiurl);

    print("urlParse -----> $urlParse");
    body!.forEach((key, value) {
      print("$key : $value");
    });
    var response = null;
    try {
      response = await http
          .post(
            urlParse,
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(const Duration(minutes: 2));
    } on Exception catch (e) {
      debugPrint("Exception ===> ${e.toString()}");
      return response;
    }

    return response;
  }

  Future<http.Response> get(
      {String apiurl = '', Map<String, String>? header}) async {
    var urlParse = Uri.parse(apiurl);

    print("urlParse -----> $urlParse");
    var response = await http
        .get(
          urlParse,
          headers: header,
        )
        .timeout(const Duration(minutes: 2));
    return response;
  }

  Future<http.Response> put(
      {String apiurl = '',
      Map<String, String>? header,
      Map<String, dynamic>? body}) async {
    var urlParse = Uri.parse(apiurl);

    print("urlParse -----> $urlParse");
    body!.forEach((key, value) {
      print("$key : $value");
    });

    var response = await http
        .put(
          urlParse,
          headers: header,
          body: jsonEncode(body),
        )
        .timeout(const Duration(minutes: 2));

    return response;
  }

  Future<http.Response> delete(
      {String apiurl = '',
      Map<String, String>? header,
      Map<String, dynamic>? body}) async {
    var urlParse = Uri.parse(apiurl);

    print("urlParse -----> $urlParse");
    body!.forEach((key, value) {
      print("$key : $value");
    });

    var response = await http
        .delete(
          urlParse,
          headers: header,
          body: jsonEncode(body),
        )
        .timeout(const Duration(minutes: 2));

    return response;
  }
}

dynamic _response(response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body);
      if (kDebugMode) print("Response status 200 ====> $responseJson");
      return responseJson;
    case 400:
      var responseJson = json.decode(response.body);
      if (kDebugMode) print("Response status 400 ====> $responseJson");
      String message = responseJson["ResponseText"];
      WidgetHelper().showMessage(msg: message);
      throw BadRequestException(response.body);
    case 401:
      var responseJson = json.decode(response.body);
      if (kDebugMode) print("Response status 401 ====> $responseJson");
      String message = responseJson["ResponseText"];
      WidgetHelper().showMessage(msg: message);

      throw UnauthorisedException(response.body);
    case 403:
      var responseJson = json.decode(response.body);
      if (kDebugMode) print("Response status 403 ====> $responseJson");
      String message = responseJson["ResponseText"];
      WidgetHelper().showMessage(msg: message);
      throw UnauthorisedException(response.body);
    case 404:
      var responseJson = json.decode(response.body);
      if (kDebugMode) print("Response status 404 ====> $responseJson");
      String message = responseJson["ResponseText"];
      WidgetHelper().showMessage(msg: message);
      return responseJson;
    case 498:
      var responseJson = json.decode(response.body);
      if (kDebugMode) print("Response status 498 ====> $responseJson");
      String message = responseJson["ResponseText"];
      WidgetHelper().showMessage(msg: message);
      return null;

    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

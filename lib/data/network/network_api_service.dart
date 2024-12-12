import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:depd_2024_mvvm/data/app_exception.dart';
import 'package:depd_2024_mvvm/data/network/base_api_services.dart';
import 'package:depd_2024_mvvm/shared/shared.dart';
import 'package:http/http.dart' as http;


// fetch data from api by inputing endpoint
class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getGetApiResponse(String endpoint) async {
    dynamic responseJson;

    try {
      final response = await http
          .get(Uri.https(Const.baseUrl, endpoint), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apikey,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network request time out!');
    }

    return responseJson;
  }

  @override
Future<dynamic> getPostApiResponse(String endpoint, dynamic data) async {
  dynamic responseJson;

  try {
    // Construct the full URI
    final Uri uri = Uri.https(Const.baseUrl, endpoint);

    // Make the POST request
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apikey, // Add your API key
      },
      body: jsonEncode(data), // Encode the body to JSON format
    );

    // Parse and return the response
    responseJson = returnResponse(response);
  } on SocketException {
    throw NoInternetException('No Internet connection');
  } on TimeoutException {
    throw FetchDataException('Network request time out!');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }

  return responseJson;
}

}

// return response types
dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 500:
    case 404:
      throw UnauthorisedException(response.body.toString());
    default:
      throw FetchDataException('Error occured while communicating with server');
  }
}

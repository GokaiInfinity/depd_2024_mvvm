import 'package:depd_2024_mvvm/data/network/network_api_service.dart';
import 'package:depd_2024_mvvm/model/city.dart';
import 'package:depd_2024_mvvm/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiService();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse('/starter/province');
      List<Province> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<City>> fetchCityList(var provId) async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse('/starter/city');
      List<City> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }

      List<City> selectedCities = [];
      for (var c in result){
        if(c.provinceId == provId){
          selectedCities.add(c);
        }
      }

      return selectedCities;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Costs>> fetchShippingCost({
  required String origin,
  required String destination,
  required int weight,
  required String courier,
  }) async {
  try {
    print('Request Body: {' // Debug print
    'origin: $origin, '
    'destination: $destination, '
    'weight: $weight, '
    'courier: $courier'
  '}');
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'origin': origin,
      'destination': destination,
      'weight': weight,
      'courier': courier,
    };

    // Make the POST request
    dynamic response = await _apiServices.getPostApiResponse(
      '/starter/cost',
      requestBody,
    );

    // print('Full API Response: $response'); 
    // print(response);
    // print(response['rajaongkir']['results']);
    // Check if the response is successful
    if (response['rajaongkir']['status']['code'] == 200) {
      // print(response['rajaongkir']['results'][0]['costs']);
      return (response['rajaongkir']['results'][0]['costs'] as List)
          .map((e) => Costs.fromJson(e))
          .toList();
      
    } else {
      throw Exception(response['rajaongkir']['status']['description'] ?? 'Failed to fetch shipping cost');
    }
  } catch (e) {
    throw Exception('Error fetching shipping cost: $e');
  }
  }
  
}

import 'package:depd_2024_mvvm/data/response/api_response.dart';
import 'package:depd_2024_mvvm/model/city.dart';
import 'package:depd_2024_mvvm/model/model.dart';
import 'package:depd_2024_mvvm/repository/home_repository.dart';
import 'package:flutter/material.dart';

class CostViewModel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<List<Province>> provinceListOrigin = ApiResponse.loading();
  
  setProvinceListOrigin(ApiResponse<List<Province>> response) {
    provinceListOrigin = response;
    notifyListeners();
  }

  Future<void> getProvinceListOrigin() async {
    setProvinceListOrigin(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceListOrigin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceListOrigin(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>>cityListOrigin = ApiResponse.loading();

  setCityListOrigin(ApiResponse<List<City>> response) {
   cityListOrigin = response;
    notifyListeners();
  }

  Future<void> getCityListOrigin(var provId) async {
    setCityListOrigin(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityListOrigin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityListOrigin(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<Province>> provinceListDestination = ApiResponse.loading();
  
  setProvinceListDestination(ApiResponse<List<Province>> response) {
    provinceListDestination = response;
    notifyListeners();
  }

  Future<void> getProvinceListDestination() async {
    setProvinceListDestination(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceListDestination(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceListDestination(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>>cityListDestination = ApiResponse.loading();

  setCityListDestination(ApiResponse<List<City>> response) {
   cityListDestination = response;
    notifyListeners();
  }

  Future<void> getCityListDestination(var provId) async {
    setCityListDestination(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityListDestination(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityListDestination(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<dynamic> shippingCostResult = ApiResponse.loading();

// setShippingCostResult(ApiResponse<dynamic> response) {
//   // print(response);
//   // print(response.data);
//   shippingCostResult = response;
//   notifyListeners();
// }

// Future<void> calculateShippingCost({
//   required String origin, 
//   required String destination, 
//   required int weight, 
//   required String courier
// }) async {
//   setShippingCostResult(ApiResponse.loading());
  
//   try {
//     final result = await _homeRepo.fetchShippingCost(
//       origin: origin, 
//       destination: destination, 
//       weight: weight, 
//       courier: courier
//     );
//     // print(result);
//     setShippingCostResult(ApiResponse.completed(result));
//     notifyListeners();
//   } catch (error) {
//     setShippingCostResult(ApiResponse.error(error.toString()));
//   }
// }

Future<void> calculateShippingCost({
  required String origin, 
  required String destination, 
  required int weight, 
  required String courier
}) async {
  // Set to loading state immediately
  shippingCostResult = ApiResponse.loading();
  notifyListeners();

  try {
    final result = await _homeRepo.fetchShippingCost(
      origin: origin, 
      destination: destination, 
      weight: weight, 
      courier: courier
    );
    
    // Set to completed state
    shippingCostResult = ApiResponse.completed(result);
    notifyListeners(); // This will trigger UI update
  } catch (error) {
    // Set to error state
    shippingCostResult = ApiResponse.error(error.toString());
    notifyListeners();
  }
}

}
import 'dart:ffi';

import 'package:food_app/db/userController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderController {

  //add
  Future<ApiResponse> addCart(int user_id, int restaurant_id, int item_id, int quantity) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/cart/create');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'user_id': user_id,
        'restaurant_id': restaurant_id,
        'item_id': item_id,
        'quantity': quantity,
      }),
    );

    ApiResponse apiResponse = ApiResponse(response.statusCode, response.body);
    return apiResponse;
  }

  //getAll
  Future<ApiResponse> getAll(int user_id) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/order/getItems/${user_id}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    ApiResponse apiResponse = ApiResponse(response.statusCode, response.body);
    return apiResponse;
  }


}
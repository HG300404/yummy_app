import 'dart:ffi';

import 'package:food_app/db/userController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewController {

  //add
  Future<ApiResponse> create(String user_id, String restaurant_id, String rating, String order_id, String comment) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/comment/create');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id,
        'restaurant_id': restaurant_id,
        'rating': rating,
        'order_id': order_id,
        'comment': comment,
      }),
    );
    print(response.body);
    ApiResponse apiResponse = ApiResponse(response.statusCode, response.body);
    return apiResponse;
  }

  //getAll
  Future<ApiResponse> getItem(int order_id) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/comment/getItemByOrder/${order_id}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    ApiResponse apiResponse = ApiResponse(response.statusCode, response.body);
    return apiResponse;
  }

  //Put
  Future<ApiResponse> update(int user_id, int item_id, int restaurant_id, int quantity) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/cart/update');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'user_id': user_id,
        'item_id': item_id,
        'restaurant_id': restaurant_id,
        'quantity': quantity,
      }),
    );

    ApiResponse apiResponse = ApiResponse(response.statusCode, response.body);
    return apiResponse;
  }






}
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myhitha/bloc/cart_bloc.dart';
import '../bloc/veggieBlocModel.dart';
import './cart_state.dart';

abstract class CartRepository {
  /// Throws [NetworkException].
  Future<int> submitOrder(
      String paymentId, String paymentType, CartState state);
}

class SubmitCartRepository implements CartRepository {
  @override
  Future<int> submitOrder(
      String paymentId, String paymentType, CartState state) async {
    // var email = ;
    print('****** Started FUTURE SUBMITTED');

    // Simulate network delay
    final http.Response response = await http.post(
      'https://arcane-springs-88980.herokuapp.com/createOrder',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'products': state.veggieListy,
        'cost_of_order': state.completeCart["orderCost"],
        'userid': 9,
        'email': FirebaseAuth.instance.currentUser.email,
        'payment_type': state.completeCart["payment_type"] != null
            ? state.completeCart["payment_type"]
            : paymentType,
        'customerPhone': state.completeCart["customerPhone"],
        'customerName': state.completeCart["customerName"],
        'customerAddress': state.completeCart["customerAddress"],
        'payment_id': state.completeCart["payment_id"] != null
            ? state.completeCart["payment_id"]
            : paymentId,
      }),
    );
    if (response.statusCode == 201) {
      print('order Id');
      print(json.decode(response.body)['data']);
      return json.decode(response.body)['data'];
    } else {
      print('no order Created');
      return Future.error('Failed to create order');

      // throw Exception('Failed to create order.');
    }
  }
}

class NetworkException implements Exception {}

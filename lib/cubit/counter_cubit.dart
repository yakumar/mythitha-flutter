// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';

// part 'counter_state.dart';

// var email = FirebaseAuth.instance.currentUser.email;

// class CounterCubit extends Cubit<CounterState> {
//   CounterCubit()
//       : super(CounterState(
//             xcount: 0,
//             cartCount: 0,
//             completeCart: {},
//             veggieListy: [],
//             orderId: null));

//   var orderyId;

//   void increment() => emit(CounterState(xcount: state.xcount + 1));

//   void decrement() => emit(CounterState(xcount: state.xcount - 1));

//   Future<void> submitOrder(
//       [String paymentId = '0', String paymentType = "COD_Order"]) async {
//     print('***');

//     print('FROM CUBIT CART FROM Payment_TYPE ***!!');

//     print('${state.completeCart["payment_type"]}');

//     print("***");
//     try {
//       var a = 1;
//       a++;

//       debugPrint('A from CUBit cart ::>> ${a}');
//       print("***");

//       final http.Response response = await http.post(
//         'https://arcane-springs-88980.herokuapp.com/createOrder',
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'products': state.veggieListy,
//           'cost_of_order': state.completeCart["cost"],
//           'userid': 9,
//           'email': '${email}',
//           'payment_type': state.completeCart["payment_type"] != null
//               ? state.completeCart["payment_type"]
//               : paymentType,
//           'customerPhone': state.completeCart["customerPhone"],
//           'customerName': state.completeCart["customerName"],
//           'customerAddress': state.completeCart["customerAddress"],
//           'payment_id': state.completeCart["payment_id"] != null
//               ? state.completeCart["payment_id"]
//               : paymentId,
//         }),
//       );
//       if (response.statusCode == 201) {
//         print('success order posted');
//         debugPrint('****');
//         debugPrint(response.body);
//         // addOrderId(json.decode(response.body));
//         // orderyId = json.decode(response.body);
//         int orderyId = json.decode(response.body)['data'];
//         // return json.decode(response.body);

//         emit(CounterState(
//             xcount: 0,
//             cartCount: 0,
//             completeCart: {},
//             veggieListy: [],
//             orderId: orderyId));

//         // emit(CounterState(cartCount: 0, veggieListy: [], completeCart: {
//         //   "products": [],
//         //   "cost": 0,
//         //   "customerPhone": null,
//         //   "customerName": "",
//         //   "customerAddress": "",
//         //   "payment_type": "",
//         //   "payment_id": ""
//         // }));
//       } else {
//         throw Exception('Failed to create order.');
//         // return Future.error('');
//       }
//     } catch (e) {
//       print(e);
//       return Future.error('Please Order again');
//     }
//   }

//   getInitialState() {
//     debugPrint('From Initial state');
//     emit(CounterState(
//         xcount: 0,
//         cartCount: 0,
//         completeCart: {"products": [], "cost": 0},
//         veggieListy: [],
//         orderId: null));
//   }

//   void addItem(Map<String, dynamic> item) {
//     debugPrint('from addItem COunterCubit: ${item}');
//     debugPrint('from addItem COunterCubit state: ${state.veggieListy}');

//     if (state.veggieListy.length > 0) {
//       var tempVegCart2 = List.from(state.veggieListy);

//       // var tempVegCart2 = [...state.veggieListy];
//       debugPrint(
//           'from addItem COunterCubit ...state.veggieListy 2: ${tempVegCart2}');

//       var filteredMapy = tempVegCart2.firstWhere(
//           (elem) => elem['name'] == item['name'],
//           orElse: () => null);

//       print("*** Filtered MAP");
//       print(filteredMapy);

//       if (filteredMapy != null) {
//         filteredMapy['quantity'] = filteredMapy['quantity'] + item['quantity'];
//         filteredMapy['priceQuantity'] =
//             filteredMapy['priceQuantity'] + item['priceQuantity'];

//         // print('quanityt');

//         // filteredMapy['quantity']);
//         filteredMapy['cPrice'] =
//             filteredMapy['priceQuantity'] * filteredMapy['price'];

//         var numList =
//             tempVegCart2.map((elem) => elem['priceQuantity']).toList();

//         var carty = numList.fold(0, (curr, next) => curr + next);
//         List<dynamic> myArr =
//             tempVegCart2.map((mapy) => mapy['cPrice']).toList();

//         int orderCost2 =
//             myArr.fold(0, (previousValue, element) => previousValue + element);

//         debugPrint('cart count:');
//         debugPrint('state.cartCount');
//         debugPrint('*****');
//         debugPrint('complete cart');
//         debugPrint('state.completeCart');

//         emit(CounterState(
//           orderId: null,
//           cartCount: carty,
//           veggieListy: tempVegCart2,
//           completeCart: {"products": tempVegCart2, "cost": orderCost2},
//         ));

//         ////
//       } else {
//         var tempVegCart1 = List.from(state.veggieListy);
//         tempVegCart1.add(item);
//         // var tempVegCart1 = [...state.veggieListy, item];
//         debugPrint(
//             'from addItem COunterCubit ...state.veggieListy 1: ${tempVegCart1}');

//         var numList =
//             tempVegCart1.map((elem) => elem['priceQuantity']).toList();

//         var carty = numList.fold(0, (curr, next) => curr + next);

//         List<dynamic> myArr =
//             tempVegCart1.map((mapy) => mapy['cPrice']).toList();

//         int orderCost1 =
//             myArr.fold(0, (previousValue, element) => previousValue + element);

//         print('orderCost');
//         print(state.completeCart['cost']);
//         print('*****');
//         print('complete cart');
//         print(state.completeCart);

//         emit(CounterState(
//           orderId: null,
//           cartCount: carty,
//           veggieListy: tempVegCart1,
//           completeCart: {"products": tempVegCart1, "cost": orderCost1},
//         ));
//       }
//     } else {
//       var tempVegCart = List.from(state.veggieListy);

//       tempVegCart.add(item);

//       debugPrint(
//           'from addItem COunterCubit ...state.veggieListy : ${tempVegCart}');

//       var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

//       var carty = numList.fold(0, (curr, next) => curr + next);

//       List<dynamic> myArr = tempVegCart.map((mapy) => mapy['cPrice']).toList();

//       int orderCost =
//           myArr.fold(0, (previousValue, element) => previousValue + element);

//       print('cart count:');
//       print(state.cartCount);
//       print(carty);

//       print('*****');
//       print('complete cart');
//       print(state.completeCart);

//       emit(CounterState(
//         orderId: null,
//         cartCount: carty,
//         veggieListy: tempVegCart,
//         completeCart: {"products": tempVegCart, "cost": orderCost},
//       ));
//     }
//   }

//   void addUserDetails({int phone, String name, String address}) {
//     // var compeleteCartCopy = {...state.completeCart};

//     var tempVegCart = [...state.veggieListy];

//     var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

//     var carty = numList.fold(0, (curr, next) => curr + next);

//     List<dynamic> myArr = tempVegCart.map((mapy) => mapy['cPrice']).toList();

//     int orderCost =
//         myArr.fold(0, (previousValue, element) => previousValue + element);

//     emit(CounterState(completeCart: {
//       "products": tempVegCart,
//       "cost": orderCost,
//       "customerPhone": phone,
//       "customerName": name,
//       "customerAddress": address
//     }, cartCount: carty, veggieListy: tempVegCart, orderId: null));
//   }

//   void codOrder() {
//     var tempVegCart = [...state.veggieListy];

//     var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

//     var carty = numList.fold(0, (curr, next) => curr + next);

//     List<dynamic> myArr = tempVegCart.map((mapy) => mapy['cPrice']).toList();

//     int orderCost =
//         myArr.fold(0, (previousValue, element) => previousValue + element);

//     emit(CounterState(
//         orderId: null,
//         cartCount: carty,
//         veggieListy: tempVegCart,
//         completeCart: {
//           "products": tempVegCart,
//           "cost": orderCost,
//           "customerPhone": state.completeCart['customerPhone'],
//           "customerName": state.completeCart['customerName'],
//           "customerAddress": state.completeCart['customerAddress'],
//           "payment_type": "COD_Order",
//         }));
//   }

//   void addPaymentId(String paymentId) {
//     var tempVegCart = [...state.veggieListy];

//     var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

//     var carty = numList.fold(0, (curr, next) => curr + next);

//     List<dynamic> myArr = tempVegCart.map((mapy) => mapy['cPrice']).toList();

//     int orderCost =
//         myArr.fold(0, (previousValue, element) => previousValue + element);

//     emit(CounterState(
//         orderId: null,
//         cartCount: carty,
//         veggieListy: tempVegCart,
//         completeCart: {
//           "products": tempVegCart,
//           "cost": orderCost,
//           "customerPhone": state.completeCart['customerPhone'],
//           "customerName": state.completeCart['customerName'],
//           "customerAddress": state.completeCart['customerAddress'],
//           "payment_type": "mobile_order",
//           "payment_id": paymentId,
//         }));
//   }

//   void addOrderId(Map orderId) {
//     debugPrint('from OrderID in Counter Cubit, ${orderId['data']}');
//     emit(CounterState(orderId: orderId['data'], cartCount: 0, completeCart: {
//       "products": [],
//       "cost": 0,
//       "customerPhone": null,
//       "customerName": "",
//       "customerAddress": "",
//       "payment_type": "",
//       "payment_id": "",
//     }));
//   }

//   void removeProduct(String name) {
//     var tempVegCart = List.from(state.veggieListy);

//     tempVegCart.removeWhere((veg) => veg['name'] == name);

//     debugPrint('${tempVegCart}');

//     debugPrint(
//         'from addItem COunterCubit ...state.veggieListy : ${tempVegCart}');

//     var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

//     var carty = numList.fold(0, (curr, next) => curr + next);

//     List<dynamic> myArr = tempVegCart.map((mapy) => mapy['cPrice']).toList();

//     int orderCost =
//         myArr.fold(0, (previousValue, element) => previousValue + element);

//     print('cart count:');
//     print(state.cartCount);
//     print(carty);

//     print('*****');
//     print('complete cart');
//     print(state.completeCart);

//     emit(CounterState(
//       orderId: null,
//       cartCount: carty,
//       veggieListy: tempVegCart,
//       completeCart: {"products": tempVegCart, "cost": orderCost},
//     ));
//   }

//   void removeOrderId() {
//     emit(CounterState(
//         orderId: null,
//         cartCount: 0,
//         veggieListy: [],
//         completeCart: {
//           "products": [],
//           "cost": 0,
//           "customerPhone": null,
//           "customerName": "",
//           "customerAddress": "",
//           "payment_type": "",
//           "payment_id": "",
//         }));
//   }
// }

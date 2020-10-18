import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/homeCard.dart';

import './cart_event.dart';
import './cart_state.dart';
import 'veggieBlocModel.dart';
import './cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  CartBloc(this._cartRepository)
      : super(CartInitial([], {"products": [], "orderCost": 0}, 0, null));

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is AddCartEvent) {
      VeggieBloc item = event.veggie;
      int quantityAdded = event.quantityAdded;

      print('item, ${item}');
      print('quantity added:, ${quantityAdded}');

      print('veggie Listy, ${state.veggieListy}');

      // List<Veggie> newList = List.from(state.veggieListy);
      // newList.add(item);
      // List<Veggie> newList = [...state.veggieListy, _veg];

      if (state.veggieListy.length > 0) {
        var tempVegCart2 = state.veggieListy;

        // var myMap = Map<String, dynamic>.from(item);

        Map<String, dynamic> myItem = item.toMap();
        myItem['priceQuantity'] = quantityAdded;
        myItem['calcPrice'] = quantityAdded * myItem['price'];

        print('from addItem ITEM!! ...state.veggieListy : ${myItem}');
        // tempVegCart2.add(myItem);
        // var tempVegCart2 = [...state.veggieListy];
        print(
            'from addItem COunterCubit ...state.veggieListy 2: ${tempVegCart2}');

        var filteredMapy = tempVegCart2.firstWhere(
            (elem) => elem['name'] == item.name,
            orElse: () => null);

        print("*** Filtered MAP");
        print(filteredMapy);

        if (filteredMapy != null) {
          filteredMapy['quantity'] = filteredMapy['quantity'] + item.quantity;
          filteredMapy['priceQuantity'] =
              filteredMapy['priceQuantity'] + quantityAdded;

          // print('quanityt');

          // filteredMapy['quantity']);
          filteredMapy['calcPrice'] =
              filteredMapy['priceQuantity'] * filteredMapy['price'];

          var numList =
              tempVegCart2.map((elem) => elem['priceQuantity']).toList();

          var carty = numList.fold(0, (curr, next) => curr + next);
          List<dynamic> myArr =
              tempVegCart2.map((mapy) => mapy['calcPrice']).toList();

          int orderCost2 = myArr.fold(
              0, (previousValue, element) => previousValue + element);

          print('cart count:');
          print('state.cartCount');
          print('*****');
          print('complete cart');
          print('state.completeCart');
          Map<String, dynamic> completeAddCart = {
            "products": tempVegCart2,
            "orderCost": orderCost2
          };
          int orderId;
          yield AfterAddState(tempVegCart2, completeAddCart, carty, orderId);

          ////
        } else {
          var tempVegCart1 = state.veggieListy;

          // var myMap = Map<String, dynamic>.from(item);
          // var quan = 0;
          Map<String, dynamic> myItem = item.toMap();
          myItem['priceQuantity'] = quantityAdded;
          myItem['calcPrice'] = quantityAdded * myItem['price'];

          print('Quantity Added, ${quantityAdded}');

          print('from addItem ITEM!! ...state.veggieListy : ${myItem}');
          tempVegCart1.add(myItem);
          print(
              'from addItem COunterCubit ...state.veggieListy 1: ${tempVegCart1}');

          var numList =
              tempVegCart1.map((elem) => elem['priceQuantity']).toList();

          var carty = numList.fold(0, (curr, next) => curr + next);

          List<dynamic> myArr =
              tempVegCart1.map((mapy) => mapy['calcPrice']).toList();

          int orderCost1 = myArr.fold(
              0, (previousValue, element) => previousValue + element);

          print('orderCost');
          print(state.completeCart['cost']);
          print('*****');
          print('complete cart');
          print(state.completeCart);
          Map<String, dynamic> completeAddCart = {
            "products": tempVegCart1,
            "orderCost": orderCost1
          };
          int orderId;
          yield AfterAddState(tempVegCart1, completeAddCart, carty, orderId);
        }
      } else {
        var tempVegCart = state.veggieListy;

        // var myMap = Map<String, dynamic>.from(item);
        print('Quantity Added, ${quantityAdded}');

        Map<String, dynamic> myItem = item.toMap();
        myItem['priceQuantity'] = quantityAdded;
        myItem['calcPrice'] = quantityAdded * myItem['price'];

        print('from addItem ITEM!! ...state.veggieListy : ${myItem}');
        tempVegCart.add(myItem);

        var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

        print('From Cart BLOC ==>>> ${numList}');

        var carty = numList.fold(0, (curr, next) => curr + next);

        List<dynamic> myArr =
            tempVegCart.map((mapy) => mapy['calcPrice']).toList();
        print(' myARR =>> , ${myArr}');

        int orderCost =
            myArr.fold(0, (previousValue, element) => previousValue + element);

        print(' OrderCost =>> , ${orderCost}');

        print('cart count:');
        print(state.cartCount);
        print(' tempVEGCART ==>> ${tempVegCart}');

        print('*****');

        Map<String, dynamic> completeAddCart = {
          "products": tempVegCart,
          "orderCost": orderCost
        };
        print('complete cart');
        print(state.completeCart);
        int orderId;
        yield AfterAddState(tempVegCart, completeAddCart, carty, orderId);
      }
    } else if (event is DeleteCartEvent) {
      VeggieBloc item = event.veggie;
      // int quantityAdded = event.quantityAdded;

      var denttempVegCart = state.veggieListy;

      Map<String, dynamic> myItem = item.toMap();

      denttempVegCart.removeWhere((veg) => veg['name'] == item.name);

      print('${denttempVegCart}');

      print(
          'from addItem COunterCubit ...state.veggieListy : ${denttempVegCart}');

      var numList =
          denttempVegCart.map((elem) => elem['priceQuantity']).toList();

      var carty = numList.fold(0, (curr, next) => curr + next);

      List<dynamic> myArr =
          denttempVegCart.map((mapy) => mapy['calcPrice']).toList();

      int orderCost =
          myArr.fold(0, (previousValue, element) => previousValue + element);

      print('cart count:');
      print(state.cartCount);
      print(carty);

      Map<String, dynamic> completeAddCart = {
        "products": denttempVegCart,
        "orderCost": orderCost
      };
      print('*****');
      print('complete cart');
      print(state.completeCart);
      int orderId;
      yield AfterDeleteState(denttempVegCart, completeAddCart, carty, orderId);
    } else if (event is AddUserDetailsEvent) {
      var name = event.name;
      var address = event.address;
      var phone = event.phone;

      var tempVegCart = state.veggieListy;

      var numList = tempVegCart.map((elem) => elem['priceQuantity']).toList();

      var carty = numList.fold(0, (curr, next) => curr + next);

      List<dynamic> myArr =
          tempVegCart.map((mapy) => mapy['calcPrice']).toList();

      int orderCost =
          myArr.fold(0, (previousValue, element) => previousValue + element);
      Map<String, dynamic> completeAddCart = {
        "products": tempVegCart,
        "orderCost": orderCost,
        "customerPhone": phone,
        "customerName": name,
        "customerAddress": address
      };
      int orderId;
      print('Complete cart from user details bloc: ${completeAddCart.values}');
      yield AfterAddingUserDetails(
          tempVegCart, completeAddCart, carty, orderId);
    } else if (event is CodOrderEvent) {
      var codVegCart = state.veggieListy;

      var numList = codVegCart.map((elem) => elem['priceQuantity']).toList();

      var carty = numList.fold(0, (curr, next) => curr + next);

      List<dynamic> myArr =
          codVegCart.map((mapy) => mapy['calcPrice']).toList();

      int orderCost =
          myArr.fold(0, (previousValue, element) => previousValue + element);
      Map<String, dynamic> completeAddCart = {
        "products": codVegCart,
        "orderCost": orderCost,
        "customerPhone": state.completeCart['customerPhone'],
        "customerName": state.completeCart['customerName'],
        "customerAddress": state.completeCart['customerAddress'],
        "payment_type": "COD_Order",
      };
      int orderId;
      print('Complete cart from user details bloc: ${completeAddCart.values}');
      yield CodOrderState(codVegCart, completeAddCart, carty, orderId);
    } else if (event is AddPaymentIdEvent) {
      String payment_id = event.paymentId;
      var codVegCart = state.veggieListy;

      var numList = codVegCart.map((elem) => elem['priceQuantity']).toList();

      var carty = numList.fold(0, (curr, next) => curr + next);

      List<dynamic> myArr =
          codVegCart.map((mapy) => mapy['calcPrice']).toList();

      int orderCost =
          myArr.fold(0, (previousValue, element) => previousValue + element);
      Map<String, dynamic> completeAddCart = {
        "products": codVegCart,
        "orderCost": orderCost,
        "customerPhone": state.completeCart['customerPhone'],
        "customerName": state.completeCart['customerName'],
        "customerAddress": state.completeCart['customerAddress'],
        "payment_type": "mobile_order",
        "payment_id": payment_id,
      };
      int orderId;
      print('Complete cart from user details bloc: ${completeAddCart.values}');
      yield AddPaymentIdState(codVegCart, completeAddCart, carty, orderId);
    } else if (event is SubmitOrderEvent) {
      String paymentId = event.paymentId;
      String paymentType = event.paymentType;

      // await submittingOrder(paymentId, paymentType);
      //email, paymentId, paymentType

      try {
        final orderyId =
            await _cartRepository.submitOrder(paymentId, paymentType, state);
        //json.decode(response.body)['data']

        print('success order posted');
        print('****');
        // print(response);
        // addOrderId(json.decode(response.body));
        // int orderyId = 222;
        //  orderyId =
        // return json.decode(response.body);

        // emit(CounterState(
        //     xcount: 0,
        //     cartCount: 0,
        //     completeCart: {},
        //     veggieListy: [],
        //     orderId: orderyId));
        yield SubmitOrderState([], {}, 0, orderyId);
      } on NetworkException {
        yield SubmitErrorState("Couldn't submit Order. Is the device online?");
      }
    } else if (event is IntialEvent) {
      yield CartInitial([], {"products": [], "orderCost": 0}, 0, null);
    }
  }
}

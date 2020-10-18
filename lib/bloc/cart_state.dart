import './cart_bloc.dart';
import 'package:equatable/equatable.dart';
import 'veggieBlocModel.dart';

abstract class CartState extends Equatable {
  final List<Map> veggieListy;
  final Map<String, dynamic> completeCart;
  final int cartCount;
  final int orderId;

  const CartState(
      this.veggieListy, this.completeCart, this.cartCount, this.orderId);

  @override
  List<Object> get props => [veggieListy, completeCart, cartCount, orderId];
}

class CartInitial extends CartState {
  final List<Map> veggieListy = [];
  final int cartCount = 0;
  final Map<String, dynamic> completeCart = {"products": [], "orderCost": 0};
  final int orderId = null;

  CartInitial(List<Map> veggieListy, Map<String, dynamic> completeCart,
      int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}

class AfterAddState extends CartState {
  // final List<Veggie> veggieListy;
  //   final Map<String, dynamic> completeCart;

  AfterAddState(List<Map> veggieListy, Map<String, dynamic> completeCart,
      int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}

class AfterDeleteState extends CartState {
  AfterDeleteState(List<Map> veggieListy, Map<String, dynamic> completeCart,
      int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}

class AfterAddingUserDetails extends CartState {
  AfterAddingUserDetails(List<Map> veggieListy,
      Map<String, dynamic> completeCart, int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}

class CodOrderState extends CartState {
  CodOrderState(List<Map> veggieListy, Map<String, dynamic> completeCart,
      int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}

class AddPaymentIdState extends CartState {
  AddPaymentIdState(List<Map> veggieListy, Map<String, dynamic> completeCart,
      int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}
//orderyId

class SubmitOrderState extends CartState {
  SubmitOrderState(List<Map> veggieListy, Map<String, dynamic> completeCart,
      int cartCount, int orderId)
      : super(veggieListy, completeCart, cartCount, orderId);
}

class SubmitErrorState extends CartState {
  final String message;
  SubmitErrorState(this.message) : super([], {}, 0, null);
}

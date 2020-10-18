import 'package:equatable/equatable.dart';
import 'veggieBlocModel.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class IntialEvent extends CartEvent {
  IntialEvent();
}

class AddCartEvent extends CartEvent {
  final VeggieBloc veggie;
  final int quantityAdded;

  AddCartEvent(this.veggie, this.quantityAdded);
}

class DeleteCartEvent extends CartEvent {
  final VeggieBloc veggie;
  // final int quantityAdded;

  DeleteCartEvent(this.veggie);
}

class AddUserDetailsEvent extends CartEvent {
  final int phone;
  final String name;
  final String address;

  AddUserDetailsEvent(this.name, this.phone, this.address);
}

class CodOrderEvent extends CartEvent {
  CodOrderEvent();
}

class AddPaymentIdEvent extends CartEvent {
  final String paymentId;
  AddPaymentIdEvent(this.paymentId);
}
//SubmitOrderEvent

class SubmitOrderEvent extends CartEvent {
  final String paymentId;
  final String paymentType;
  SubmitOrderEvent([this.paymentId, this.paymentType]);
}

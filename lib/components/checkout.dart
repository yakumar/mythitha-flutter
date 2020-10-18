import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:myhitha/cubit/counter_cubit.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import './thanks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  Razorpay _razorpay;
  bool _netSelected = false;
  bool _codSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();

    super.initState();

    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  initialize() async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds

    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('Success' + response.paymentId),
    // ));
    var cartState;
    debugPrint("'Success' + ${response.paymentId}");

    debugPrint('**** STate');
    debugPrint(cartState);
    // BlocProvider.of<CounterCubit>(context).addPaymentId(response.paymentId);
    BlocProvider.of<CartBloc>(context)
        .add(AddPaymentIdEvent(response.paymentId));

    // BlocProvider.of<CounterCubit>(context)
    //     .submitOrder(response.paymentId, "mobile_order");

    BlocProvider.of<CartBloc>(context)
        .add(SubmitOrderEvent(response.paymentId, "mobile_order"));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Thanks()),
    );
    // Future.delayed(Duration(seconds: 5), () {
    // _getThanks();
    // });
  }

  _getThanks() async {
    await Get.offAll(Thanks());
  }

  void _placeCOD() {
    // BlocProvider.of<CounterCubit>(context).codOrder();
    BlocProvider.of<CartBloc>(context).add(CodOrderEvent());

    // BlocProvider.of<CounterCubit>(context).submitOrder();
    BlocProvider.of<CartBloc>(context).add(SubmitOrderEvent());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Thanks()),
    );
    // Future.delayed(Duration(seconds: 5), () {
    // _getThanks();
    // });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('Failure' + response.code.toString()),
    // ));

    debugPrint("'Failure' + response.code.toString()");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('Externam wallet : ' + response.walletName),
    // ));
    debugPrint("'Externam wallet : ' + response.walletName");
  }

  openCheckOut(int cost) async {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    double money = cost.toDouble();
    double tMoney = money * 100;
    String stringMoney = tMoney.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);
    var options = {
      'key': 'rzp_test_QNV0RMpW8dYb2g',
      'currency': "INR",
      'amount': totalMoney,
      'name': 'My Hitha',
      'description': 'Fresh Veggies/fruits',
      'prefill': {
        'contact': FirebaseAuth.instance.currentUser.phoneNumber,
        'email': ''
      }
    };
    debugPrint("*****");
    debugPrint("options :");
    debugPrint("${options}");

    await _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Order pay"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20.0),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'Order cost: ${state.completeCart['orderCost']}',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 19.0,
                  ),
                  CheckboxListTile(
                    title: const Text(
                        'Pay by Credit/Debit Card, NetBanking or PhonePe / Google Pay (UPI)'),
                    value: _netSelected,
                    onChanged: (bool value) {
                      setState(() {
                        _netSelected = !_netSelected;
                        _codSelected = false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Pay by Cash (COD)'),
                    value: _codSelected,
                    onChanged: (bool value) {
                      setState(() {
                        _codSelected = !_codSelected;
                        _netSelected = false;
                      });
                    },
                  ),
                  RaisedButton(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    color: Colors.orangeAccent,
                    onPressed: () {
                      _codSelected
                          ? _placeCOD()
                          : openCheckOut(state.completeCart['orderCost']);
                    },
                    child: Text('Order'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

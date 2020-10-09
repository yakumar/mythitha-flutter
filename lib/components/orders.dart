import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myhitha/cubit/counter_cubit.dart';
import '../utilities/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../components/auth/authservice.dart';
import '../components/drawer/navigationDrawer.dart';
import '../model/order.dart';
import './SingleOrder.dart';
import 'package:get/get.dart';

import '../model/SingleOrder.dart';

class Orders extends StatefulWidget {
  final String email;

  Orders({Key key, @required this.email}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future _fetchOrders;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List> fetchOrders() async {
    final queryParameters = {'email': widget.email};
    final uri = Uri.https('arcane-springs-88980.herokuapp.com',
        '/getUserOrders', {'phone': widget.email});

    // debugPrint('URI ${uri}');

    // final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var resp = await http.get(uri);
    // debugPrint('List ${resp.body['data']}');

    if (resp.statusCode == 200) {
      var tempList = json.decode(resp.body);

      List data = tempList['data'];

      // debugPrint('List ${data}');

      // print(vegL);

      // return vegL.map((pro) => Veggie.fromJson(pro)).toList();
      return data.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load list');
    }
  }

  @override
  void initState() {
    super.initState();

    // debugPrint('Orders Initiated');
    _fetchOrders = fetchOrders();

    // getCurrentUser();
  }

  @override
  void didChangeDependencies() {
    // final CounterCubit counterCubit = BlocProvider.of<CounterCubit>(context);
    setState(() {
      // _counterCubit = counterCubit;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _counterCubit.close();
    // CounterCubit blocProvider = BlocProvider.of<CounterCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Orders"),

        actions: [
          auth.currentUser != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    AuthService().signOut();
                  })
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _futureBuilder(context),
      ),
    );
  }

  _futureBuilder(BuildContext context) {
    return FutureBuilder(
      future: _fetchOrders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // debugPrint('from Snapshot: ${snapshot.data}');
          List<Order> ordersGiven = snapshot.data ?? [];

          return SingleChildScrollView(
            child: ListView.builder(
                reverse: true,
                physics: ClampingScrollPhysics(),
                itemCount: ordersGiven.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Order order = ordersGiven[index];
                  return _fetchedOrder(context, order);
                }),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _fetchedOrder(BuildContext context, Order order) {
    final double price = double.parse(order.costOfOrder);
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(order.orderDate);
    String convertedDate = new DateFormat("yyyy-MM-dd").format(tempDate);

    final List productList = order.orderDetails['veggies'];

    return Container(
        alignment: Alignment.center,
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Customer Name : ${order.customerName}'),
                // subtitle: Text('phone : ${order.phone}'),
                subtitle: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    'Ordered_on : ${convertedDate}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                trailing: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      'cost : ${price} rs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              ListTile(
                title: Text('Order_id : ${order.orderId}'),
                subtitle: Text('phone : ${order.phone}'),
              ),
              ListTile(
                title: Text('Payment type : ${order.paymentType}'),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text('Ordered items')),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) / 40, vertical: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('name'),
                        Text('wt/unit'),
                        Text('price'),
                        Text('qty'),
                        Text('calc_price')
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var product =
                            SingleOrderModel.fromJson(productList[index]);
                        return Table(
                          children: [
                            TableRow(children: [
                              Text('${product.name}'),
                              Text('${product.weight}'),
                              Text('${product.price}'),
                              Text('${product.priceQuantity}'),
                              Text('${product.calcPrice}'),
                            ]),
                          ],
                        );
                      },
                    ),
                    Divider()
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // _futureBuilder(BuildContext context) {
  //   return FutureBuilder(
  //       future: _fetchOrders,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           // List<Veggie> veggiesListed = snapshot.data ?? [];

  //           return Container();
  //         } else {
  //           return Container(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Fetching Veggies',
  //                   style: TextStyle(fontSize: 20.0, color: Colors.orange),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.symmetric(vertical: 10.0),
  //                 ),
  //                 CircularProgressIndicator(),
  //               ],
  //             ),
  //             alignment: Alignment.center,
  //           );
  //         }
  //       });
  // }
}

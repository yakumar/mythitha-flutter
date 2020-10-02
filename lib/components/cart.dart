import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myhitha/cubit/counter_cubit.dart';
import './thanks.dart';
import './checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/auth/login.dart';

import '../components/auth/authservice.dart';

import 'package:flutter/scheduler.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _formKey = GlobalKey<FormState>();
  int phoney;
  String namey;
  String addr;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  // _getAuth() {
  //   debugPrint('Getting auth');
  //   AuthService().handleAuth();
  // }

  _phoneTyped(num) {
    setState(() {
      phoney = int.parse(num);
    });
  }

  _nameTyped(nam) {
    setState(() {
      namey = nam;
    });
  }

  _addrTyped(addre) {
    setState(() {
      addr = addre;
    });
  }

//   String validateMobile(String value) {
// // Indian Mobile number are of 10 digit only
//     if (value.length != 10)
//       return 'Mobile Number must be of 10 digit';
//     else
//       return null;
//   }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: Text('Shopping Cart'),
      ),
      body: Container(child: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return state.veggieListy != null && state.veggieListy.length > 0
              ? CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.orange[200],
                      expandedHeight: 100.0,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title:
                            Text('Order cost: ${state.completeCart['cost']}'),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.veggieListy.length,
                            itemBuilder: (context, index) {
                              var namy = '${state.veggieListy[index]['name']}';
                              return ListTile(
                                  leading: Image.network(
                                      '${state.veggieListy[index]['imageUrl']}'),
                                  title: Text(namy),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                          '${state.veggieListy[index]['quantity']}'),
                                      // Text('${state.veggieListy[index]['priceQuantity']}'),
                                      state.veggieListy[index]['quantity'] >
                                                  1 &&
                                              state.veggieListy[index]
                                                      ['quantity_type'] ==
                                                  'unit'
                                          ? Text(' units')
                                          : Text(
                                              '${state.veggieListy[index]['quantity_type']}'),
                                      Text(' = '),
                                      Text(
                                          '${state.veggieListy[index]['calcPrice']} rs'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      color: Colors.red,
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        _deleteProduct(context,
                                            state.veggieListy[index]['name']);
                                      }));
                            },
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 18.0),
                      sliver: SliverToBoxAdapter(
                        child: Form(
                            key: _formKey,
                            child: Column(children: <Widget>[
                              // Add TextFormFields and RaisedButton here.
                              TextFormField(
                                initialValue:
                                    state.completeCart['customerPhone'] != null
                                        ? state.completeCart['customerPhone']
                                            .toString()
                                        : "",
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  helperText: 'Enter Mobile number',
                                ),
                                onSaved: (val) => _phoneTyped(val),
                                // The validator receives the text that the user has entered.
                                validator: validateMobile,
                              ),
                              TextFormField(
                                initialValue:
                                    state.completeCart['customerName'] != null
                                        ? state.completeCart['customerName']
                                        : "",
                                decoration: InputDecoration(
                                  helperText: 'Enter Name',
                                ),
                                keyboardType: TextInputType.name,
                                onSaved: (val) => _nameTyped(val),

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter name of the customer';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                initialValue:
                                    state.completeCart['customerAddress'] !=
                                            null
                                        ? state.completeCart['customerAddress']
                                        : "",
                                onSaved: (val) => _addrTyped(val),
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    helperStyle:
                                        TextStyle(color: Colors.green[500]),
                                    helperText:
                                        'Address : Only in and around Tirupati, Andhra Pradesh, are served'),

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Address';
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false
                                    // otherwise.
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      AuthService().handleAuth();

                                      // FirebaseAuth.instance
                                      //     .authStateChanges()
                                      //     .listen((User user) {
                                      //   if (user == null) {
                                      //     print(
                                      //         'User is currently signed out!');
                                      //     Navigator.of(context)
                                      //         .pushNamedAndRemoveUntil(
                                      //             '/login',
                                      //             (Route<dynamic> route) =>
                                      //                 false);
                                      //   } else {
                                      print('User is signed in!');
                                      // Navigator.pop(context);

                                      // SchedulerBinding.instance
                                      //     .addPostFrameCallback((_) {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             Checkout()),
                                      //   );
                                      // });
                                      // }
                                      // });

                                      BlocProvider.of<CounterCubit>(context)
                                          .addUserDetails(
                                              name: namey,
                                              address: addr,
                                              phone: phoney);

                                      // BlocProvider.of<CounterCubit>(context)
                                      //     .submitOrder(
                                      //         state, namey, phoney, addr);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => Thanks()),
                                      // );
                                      // _formKey.currentState.reset();

                                      // If the form is valid, display a Snackbar.
                                      // Scaffold.of(context).showSnackBar(
                                      //     SnackBar(
                                      //         content:
                                      //             Text('Processing Data')));
                                    }
                                  },
                                  child: Text('Submit Order'),
                                ),
                              ),
                            ])),
                      ),
                    ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      title: Text('Fresh Vegetables, Fruits delivered'),
                    )
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Add Vegetables / fruits',
                  ),
                );
        },
      )),
    );
  }

  _deleteProduct(BuildContext context, String name) {
    BlocProvider.of<CounterCubit>(context).removeProduct(name);
  }
}

// ListView.builder(
//                       itemCount: state.veggieListy.length,
//                       itemBuilder: (context, index) {
//                         var namy = '${state.veggieListy[index]['name']}';
//                         return ListTile(
//                           leading: Image.network(
//                               '${state.veggieListy[index]['imageUrl']}'),
//                           title: Text(namy),
//                           subtitle: Row(
//                             children: [
//                               Text('${state.veggieListy[index]['quantity']}'),
//                               // Text('${state.veggieListy[index]['priceQuantity']}'),
//                               Text(
//                                   '${state.veggieListy[index]['quantity_type']}'),
//                             ],
//                           ),
//                           trailing:
//                               Text('${state.veggieListy[index]['calcPrice']}'),
//                         );
//                       },
//                     ),

// ListTile(
//                       title: Text('${state.veggieListy[index]['name']}'),
//                       subtitle: Text('${state.completeCart['cost']}'),
//                       leading:
//                           Text('${state.veggieListy[index]['priceQuantity']}'),
//                       trailing: Text('${state.veggieListy[index]['quantity']}'),
//                     );

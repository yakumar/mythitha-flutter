import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myhitha/bloc/cart_bloc.dart';
import 'package:myhitha/cubit/counter_cubit.dart';
import '../utilities/sizes.dart';
import 'package:http/http.dart' as http;
import '../model/veggie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/auth/authservice.dart';
import '../bloc/cart_state.dart';
import '../components/drawer/navigationDrawer.dart';
import '../bloc/veggieBlocModel.dart';
import '../bloc/cart_event.dart';
import './my_flutter_app_icons.dart';

Future<List<Veggie>> fetchVeggies() async {
  final response =
      await http.get("https://arcane-springs-88980.herokuapp.com/getVeg");

  if (response.statusCode == 200) {
    Map<String, dynamic> tempList = json.decode(response.body);

    List<dynamic> vegL = tempList['data'];

    print(vegL);

    return vegL.map((pro) => Veggie.fromJson(pro)).toList();
  } else {
    throw Exception('Failed to load list');
  }
}

class HomeCard extends StatefulWidget {
  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Map<String, int> quantityCount = {};
  Future<List<Veggie>> _myVeggieList;
  bool isClicked = false;
  int _selectedIndex = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;
  // CounterCubit _counterCubit;
  @override
  void initState() {
    super.initState();

    _myVeggieList = fetchVeggies();

    if (FirebaseAuth.instance.currentUser != null) {
      print(' Firebase User : ${FirebaseAuth.instance.currentUser.email}');
    }

    // getCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.locale = Locale('te', 'IN');

    // final cartViewNotifier = watch(cartChangeNotifierProvider);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            title: Text('Vegetables'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.fruits),
            title: Text('Fruits'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Dry Fruits'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[400],
        onTap: _onItemTapped,
        unselectedItemColor: Colors.red[300],
      ),
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Freshies'),

        actions: [
          auth.currentUser != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    AuthService().signOut();
                  })
              : Container(),
          // Stack(
          //   children: [
          //     BlocBuilder<CartBloc, CartState>(
          //       builder: (context, state) {
          //         return Text('${state.cartCount}');
          //       },
          //     ),
          //     IconButton(
          //         icon: Icon(Icons.shopping_cart),
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/cart');
          //         }),
          //   ],
          // )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _futureBuilder(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange[800],
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        label: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Text('${state.cartCount}');
          },
        ),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  _futureBuilder(BuildContext context) {
    return FutureBuilder(
        future: _myVeggieList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Veggie> veggiesListed = snapshot.data ?? [];
            if (veggiesListed.length > 0) {
              if (_selectedIndex == 0) {
                veggiesListed = veggiesListed
                    .where((product) => product.category == 'vegetables')
                    .toList();
              } else if (_selectedIndex == 1) {
                veggiesListed = veggiesListed
                    .where((product) => product.category == 'fruits')
                    .toList();
              } else {
                veggiesListed = veggiesListed
                    .where((product) => product.category == 'dry fruits')
                    .toList();
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: displayHeight(context) / 24,
                    width: displayWidth(context),
                    color: Colors.red,
                    margin:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                    child: Text(
                      'Order by 9:00 pm for next day delivery',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                  ),
                  GridView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: veggiesListed?.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 7.0,
                          childAspectRatio: displayWidth(context) /
                              displayHeight(context) *
                              1.5),
                      itemBuilder: (BuildContext context, int index) {
                        Veggie hotVeggie = veggiesListed[index];
                        // debugPrint('Veggie List: ${hotVeggie.category}');

                        return _vegCard(context, hotVeggie);
                      }),
                ],
              ),
            );
          } else {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Fetching Veggies',
                      style: TextStyle(fontSize: 20.0, color: Colors.orange),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              alignment: Alignment.center,
            );
          }
        });
  }

  _vegCard(BuildContext context, Veggie newbie) {
    return Container(
      // width: displayWidth(context) / 2,
      // height: displayHeight(context) / 8,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Card(
        color: Colors.teal[100],
        elevation: 8.0,
        margin: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    newbie.imageUrl,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    width: displayWidth(context) / 3,
                    height: displayHeight(context) / 6,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${newbie.name}".toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    newbie.name.tr() == "not found"
                        ? Container()
                        : Text(
                            "(${newbie.name.tr()})".toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.0),
                          )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${newbie.quantity} ${newbie.quantityType}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      width: 8.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        '${newbie.price} Rs',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: quantityCount['${newbie.name}'] != null
                          ? IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                quantityCount['${newbie.name}'] > 0
                                    ? setState(
                                        () {
                                          quantityCount['${newbie.name}'] -= 1;

                                          print('******');
                                          print(quantityCount);
                                          print('******');
                                        },
                                      )
                                    : null;
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                quantityCount.addAll({'${newbie.name}': 0});
                                setState(
                                  () {
                                    quantityCount['${newbie.name}'] > 0
                                        ? quantityCount['${newbie.name}'] -= 1
                                        : null;
                                    print('******');
                                    print(quantityCount);
                                    print('******');
                                  },
                                );
                              },
                            ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: quantityCount['${newbie.name}'] != null
                            ? Text(
                                "${quantityCount[newbie.name]}",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                    Expanded(
                      child: quantityCount['${newbie.name}'] != null
                          ? IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(
                                  () {
                                    quantityCount['${newbie.name}'] += 1;
                                    // print('******');
                                    // print(quantityCount);
                                    // print('******');
                                  },
                                );
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                quantityCount.addAll({'${newbie.name}': 0});
                                setState(
                                  () {
                                    quantityCount['${newbie.name}'] += 1;
                                    print('******');
                                    print(quantityCount);
                                    print('******');
                                  },
                                );
                              },
                            ),
                    ),
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        color: Colors.blue,
                        child: Text(
                          'Add',
                        ),
                        onPressed: () {
                          // print('Add');

                          // vegBloc
                          VeggieBloc vegBloc = VeggieBloc(
                              name: newbie.name,
                              category: newbie.category,
                              price: newbie.price,
                              veggram_id: newbie.veggieId,
                              image_url: newbie.imageUrl,
                              weight: newbie.quantity,
                              quantity: quantityCount['${newbie.name}'] *
                                  newbie.quantity,
                              quantity_type: newbie.quantityType);
                          context.bloc<CartBloc>().add(AddCartEvent(
                              vegBloc, quantityCount['${newbie.name}']));
                          // Map<String, dynamic> productMap = {};

                          // productMap['name'] = newbie.name;
                          // productMap['price'] = newbie.price;
                          // productMap['quantity'] =
                          //     quantityCount['${newbie.name}'] * newbie.quantity;
                          // // productMap['weight'] = quantityCount;
                          // productMap['imageUrl'] = newbie.imageUrl;
                          // productMap['cPrice'] =
                          //     quantityCount['${newbie.name}'] * newbie.price;
                          // productMap['calcPrice'] =
                          //     quantityCount['${newbie.name}'] * newbie.price;
                          // productMap['priceQuantity'] =
                          //     quantityCount['${newbie.name}'];
                          // productMap['quantity_type'] = newbie.quantityType;
                          // productMap['weight'] = newbie.quantity;

                          // productMap['vegId'] = newbie.veggieId;
                          // print('Calc price');
                          // print(productMap['calcPrice']);

                          // cartStore.addItem(productMap);
                          // cartStore.increment();

                          // _counterCubit.addItem(productMap);

                          // BlocProvider.of<CounterCubit>(context)
                          //     .addItem(productMap);
                          // context.bloc<CounterCubit>().addItem(productMap);

                          setState(() {
                            quantityCount['${newbie.name}'] = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        shadowColor: Colors.black38,
      ),
    );
  }
}

// child: SingleChildScrollView(
//         child: GridView.builder(
//             physics: ClampingScrollPhysics(),
//             itemCount: _veggieList.length,
//             shrinkWrap: true,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10.0,
//                 mainAxisSpacing: 7.0,
//                 childAspectRatio: displayHeight(context) / 800),
//             itemBuilder: (BuildContext context, int index) {
//               return _vegCard(context);
//             }),
//       ),

//**** + and - buttons */

// Expanded(
//                   child: IconButton(
//                     padding: EdgeInsets.all(0),
//                     icon: Icon(Icons.remove,
//                         color: Colors.orangeAccent, size: 42),
//                     onPressed: () {
//                       quantityCount > 0
//                           ? setState(() {
//                               quantityCount -= 1;
//                             })
//                           : null;
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.center,
//                     child: Text(
//                       '${quantityCount}',
//                       style: TextStyle(
//                           fontSize: 30.0, fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: IconButton(
//                     padding: EdgeInsets.all(0),
//                     icon: Icon(Icons.add, color: Colors.orangeAccent, size: 42),
//                     onPressed: () {
//                       setState(() {
//                         quantityCount += 1;
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(),
//                 ),

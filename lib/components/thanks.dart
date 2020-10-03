import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myhitha/cubit/counter_cubit.dart';

class Thanks extends StatefulWidget {
  @override
  _ThanksState createState() => _ThanksState();
}

class _ThanksState extends State<Thanks> {
  // CounterCubit counterCubit;
  // CounterCubit _counterCubit;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _counterCubit = CounterCubit();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _counterCubit.getInitialState();
  //   _counterCubit.close();
  //   // CounterCubit blocProvider = BlocProvider.of<CounterCubit>(context);
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // counterCubit.close();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
        child: Center(
          child: BlocBuilder<CounterCubit, CounterState>(
            builder: (context, state) {
              // debugPrint('from THanks State::, ${state.orderId}');
              return state.orderId != null
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            'Order is successfully placed...\n \tYour Order id is : ${state.orderId}',
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.green),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            BlocProvider.of<CounterCubit>(context)
                                .getInitialState();

                            Navigator.popAndPushNamed(context, "/");

                            // Get.offAll(Orders(
                            //     phone: FirebaseAuth
                            //         .instance.currentUser.phoneNumber));

                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     '/', (Route<dynamic> route) => false);
                          },
                          child: Icon(Icons.home),
                        )
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            'Finding Fresh Veggies and Fruits for u',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

// Widget build(BuildContext context) {     return BlocBuilder(       builder: (context, state) {         // here you should check about the state that is being provided         return FutureBuilder(           future: _future,           builder: (context, snapshot) {             //here you should check snapshot.connectionState             return SizedBox();           },         );       },     ); }

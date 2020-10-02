import 'package:flutter/material.dart';
import '../model/order.dart';
import '../model/SingleOrder.dart';
import '../utilities/sizes.dart';

class SingleOrder extends StatelessWidget {
  final Order order;

  SingleOrder({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('getting singles: ${order.orderDetails['veggies']}');
    List orderList = order.orderDetails['veggies'];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        // height: displayHeight(context) / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.yellowAccent),
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Name'),
                Text('weight/Unit'),
                Text('Each price'),
                Text('Ordered'),
                Text('calc price'),
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (BuildContext context, int index) {
                  var product = SingleOrderModel.fromJson(orderList[index]);
                  debugPrint('Index list: ${product.name}');
                  return Column(
                    children: [
                      Table(
                        children: [
                          TableRow(children: [
                            Text('${product.name}'),
                            Text('${product.weight}'),
                            Text('${product.price}'),
                            Text('${product.priceQuantity}'),
                            Text('${product.calcPrice}'),
                          ]),
                        ],
                      )
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}

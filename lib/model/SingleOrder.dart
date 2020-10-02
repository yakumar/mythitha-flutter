class SingleOrderModel {
  String name;
  int price;
  int cPrice;
  int weight;
  String imageUrl;
  int calcPrice;

  int quantity;

  int priceQuantity;
  String quantity_type;

  SingleOrderModel(
      {this.name,
      this.weight,
      this.cPrice,
      this.calcPrice,
      this.imageUrl,
      this.price,
      this.priceQuantity,
      this.quantity,
      this.quantity_type});

  factory SingleOrderModel.fromJson(Map<String, dynamic> json) {
    return SingleOrderModel(
      name: json['name'],
      weight: json['weight'],
      cPrice: json['cPrice'],
      calcPrice: json['calcPrice'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      priceQuantity: json['priceQuantity'],
      quantity: json['quantity'],
      quantity_type: json['quantity_type'],
    );
  }
}

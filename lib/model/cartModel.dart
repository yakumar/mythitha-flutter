class CartModel {
  String name;
  String imageUrl;
  int quantity;
  int price;
  int calcPrice;
  int addedQuantity;
  int priceQuantity;

  CartModel(
      {this.name,
      this.quantity,
      this.price,
      this.calcPrice,
      this.imageUrl,
      this.addedQuantity,
      this.priceQuantity});
}

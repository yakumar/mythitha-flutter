class Veggie {
  String name;
  int quantity;
  int price;
  String quantityType;
  String imageUrl;
  int veggieId;
  String category;

  Veggie(
      {this.veggieId,
      this.name,
      this.quantity,
      this.price,
      this.quantityType,
      this.imageUrl,
      this.category});

  factory Veggie.fromJson(Map<String, dynamic> json) {
    return Veggie(
        veggieId: json['veggram_id'],
        name: json['name'],
        quantity: json['quantity'],
        quantityType: json['quantity_type'],
        price: json['each_price'],
        imageUrl: json['image_url'],
        category: json['category']);
  }
}

import 'package:equatable/equatable.dart';

// class Veggie extends Equatable {
//   String title;

//   @override
//   // TODO: implement props
//   List<Object> get props => [title];

//   Item(this.title);

//   Veggie copyWith({ String name,
//   int quantity,
//   int price,
//   String quantityType,
//   String imageUrl,
//   int veggieId,
//   String category,}) {
//     return Veggie(name ?? this.name, );
//   }
//   // factory Item.toTitle(String title): title = title;
// }

class VeggieBloc extends Equatable {
  final String name;
  final int weight;
  final int price;
  final int quantity;
  final int priceQuantity;
  final String quantity_type;
  final String image_url;
  final int veggram_id;
  final String category;

  VeggieBloc(
      {this.veggram_id,
      this.name,
      this.weight,
      this.price,
      this.quantity,
      this.quantity_type,
      this.image_url,
      this.category,
      this.priceQuantity});

  factory VeggieBloc.fromJson(Map<String, dynamic> json) {
    return VeggieBloc(
      veggram_id: json['veggram_id'],
      name: json['name'],
      weight: json['weight'],
      quantity: json['quantity'],
      quantity_type: json['quantity_type'],
      price: json['price'],
      image_url: json['image_url'],
      category: json['category'],
      priceQuantity: json['priceQuantity'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'veggram_id': veggram_id,
      'weight': weight,
      'quantity': quantity,
      'quantity_type': quantity_type,
      'price': price,
      'image_url': image_url,
      'category': category,
      'priceQuantity': priceQuantity
    };
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        veggram_id,
        name,
        price,
        weight,
        quantity,
        quantity_type,
        image_url,
        category,
        priceQuantity,
      ];

  VeggieBloc copyWith({
    String name,
    int weight,
    int price,
    int quantity,
    String quantity_type,
    String image_url,
    int veggieId,
    String category,
    int priceQuantity,
    int calcPrice,
  }) {
    return VeggieBloc(
        category: this.category,
        name: this.name,
        image_url: this.image_url,
        weight: this.weight,
        quantity: this.quantity,
        quantity_type: this.quantity_type,
        price: this.price,
        veggram_id: this.veggram_id,
        priceQuantity: this.priceQuantity);
  }
}

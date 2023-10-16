class Coffee {
  int? id;
  String name;
  String type;
  String description;
  String price;
  String imageUrl;
  int quantity = 1;

  Coffee({ this.id, required this.name, required this.type, required this.price, required this.imageUrl,required this.description, this.quantity = 1});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'description': description
    };
  }

  factory Coffee.fromMap(Map<String, dynamic> map) {
    return Coffee(
      id: map['id'],
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      price: map['price']?.toString() ?? '0',
      imageUrl: map['imageUrl'] ?? 'https://insanelygoodrecipes.com/wp-content/uploads/2023/06/Espresso-in-Shot-Glass-1024x1024.jpg',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }
}

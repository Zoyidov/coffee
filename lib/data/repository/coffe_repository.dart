import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/coffee_model.dart';

class CoffeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'coffees';

  Future<void> addCoffee({
    required String name,
    required String type,
    required String description,
    required double price,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection(collectionName).add({
        'name': name,
        'type': type,
        'description': description,
        'price': price,
        'image_url': imageUrl,
      });
    // ignore: empty_catches
    } catch (e) {
    }
  }


  Future<List<Coffee>?> getCoffees() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      return querySnapshot.docs
          .map((doc) => Coffee.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/coffee_model.dart';

class CoffeeEditScreen extends StatefulWidget {
  final Map<String, dynamic> coffee;

  const CoffeeEditScreen({super.key, required this.coffee});

  @override
  // ignore: library_private_types_in_public_api
  _CoffeeEditScreenState createState() => _CoffeeEditScreenState();
}

class _CoffeeEditScreenState extends State<CoffeeEditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.coffee['name'];
    typeController.text = widget.coffee['type'];
    priceController.text = widget.coffee['price'].toString();
    descriptionController.text = widget.coffee['description'];
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<void> updateCoffee(String coffeeId, Coffee updatedCoffee) async {
    final coffeeReference = firestore.collection('coffees').doc(coffeeId);

    final updatedData = {
      'name': updatedCoffee.name,
      'type': updatedCoffee.type,
      'price': updatedCoffee.price,
      'imageUrl': updatedCoffee.imageUrl,
      'description': updatedCoffee.description,
    };

    try {
      await coffeeReference.update(updatedData);
    // ignore: empty_catches
    } catch (e) {
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Coffee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateCoffee(widget.coffee['id'], Coffee(
                  name: nameController.text,
                  type: typeController.text,
                  price: priceController.text,
                  imageUrl: widget.coffee['imageUrl'],
                  description: descriptionController.text,
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

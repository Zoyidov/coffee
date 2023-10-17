import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../data/local/db.dart';
import '../../../data/model/coffee_model.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/images/app_images.dart';
import '../../../widgets/global_button.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Coffee> coffeeList = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCoffeeData();
  }

  Future<void> _loadCoffeeData() async {
    final database = CoffeeDatabase.instance;
    final coffees = await database.getAllCoffees();

    setState(() {
      coffeeList = coffees;
      total = _calculateTotal();
    });
  }

  double _calculateTotal() {
    double sum = 0.0;
    for (final item in coffeeList) {
      final price = double.tryParse(item.price) ?? 0.0;
      final quantity = item.quantity;
      sum += (price * quantity);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c_201,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.c_201,
        title: Text(
          'Cart',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: coffeeList.length,
                itemBuilder: (context, index) {
                  final item = coffeeList[index];
                  return Dismissible(
                    key: Key(item.name),
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      if (item.id != null) {
                        await CoffeeDatabase.instance.deleteCoffee(item.id!);
                        setState(() {
                          coffeeList.remove(item);
                          total = _calculateTotal();
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.white.withOpacity(0.1),
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          AppImages.second,
                          width: 80,
                          height: 80,
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              '\$${item.price}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity -= 1;
                                        total = _calculateTotal();
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item.quantity += 1;
                                      total = _calculateTotal();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text(
                          '\$${(item.price * item.quantity)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.0,
              height: 1.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery Charges\nTaxes",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "₹49\n₹64.87",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.0,
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Grand Total",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ZoomTapAnimation(
                child: GlobalButton(
                  buttonText: 'Book Now',
                  iconData: Icons.coffee_rounded,
                  onPressed: () {
                    _showOrderNotPossibleDialog(context); // Show the dialog
                  },
                  buttonColor: AppColors.white,
                  textColor: AppColors.black,
                  iconColor: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showOrderNotPossibleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Not Possible'),
          content: Text('Sorry, it is not possible to order at the moment.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

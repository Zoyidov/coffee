import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/data/local/db.dart';
import 'package:coffee/utils/colors/app_colors.dart';
import 'package:coffee/utils/images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../data/model/coffee_model.dart';
import 'detail_screen/detail_screen.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCoffeeData = [];
  bool isSearching = false;
  bool isLoading = true;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late CoffeeDatabase _database;
  late Future<void> _databaseInitialization;

  @override
  void initState() {
    super.initState();
    _database = CoffeeDatabase.instance;
    _databaseInitialization = _initializeDatabase();
  }



  Future<void> _initializeDatabase() async {
    await _database.initializeDatabase();
  }

  Future<int> addCoffeeToDatabase(Coffee coffee) async {
    await _databaseInitialization;
    return await _database.insertCoffee(coffee);
  }

  Future<void> fetchCoffeeData() async {
    try {
      final QuerySnapshot querySnapshot =
      await firestore.collection('coffees').get();

      setState(() {
        filteredCoffeeData = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching coffee data: $e');
    }
  }

  void filterData(String query) {
    setState(() {
      filteredCoffeeData = query.isEmpty
          ? []
          : filteredCoffeeData
          .where((coffee) =>
          coffee['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.c_201,
      title: isSearching
          ? TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        onChanged: (query) {
          filterData(query);
        },
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.white),
        ),
      )
          : Text(
        'Coffee',
        style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600),
      ),
      actions: <Widget>[
        IconButton(
          icon: isSearching
              ? const Icon(
            Icons.close,
            color: Colors.white,
          )
              : const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) {
                searchController.clear();
                filteredCoffeeData = [];
                fetchCoffeeData();
              }
            });
          },
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.c_201,
      appBar: appBar,
      body: filteredCoffeeData.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.60,
            mainAxisSpacing: 0,
            crossAxisSpacing: 16,
          ),
          itemCount: filteredCoffeeData.length,
          itemBuilder: (context, index) {
            final coffee = filteredCoffeeData[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.c_19ff,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 140,
                      width: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          coffee['imageUrl']?? 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 48.0,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coffee['name'] ?? 'Default Name',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            coffee['type'] ?? 'Default Type',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withOpacity(0.08),
                                ),
                                child: Text(
                                  '\$${coffee['price']?.toString() ?? '0'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              ZoomTapAnimation(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.c_EFE3,
                                  ),
                                  child: const Icon(Icons.add),
                                ),
                                onTap: () {
                                  print(coffee['description']);
                                  String name = coffee['name'] ?? 'Default Name';
                                  String type = coffee['type'] ?? 'Default Type';
                                  String price = coffee['cost']?.toString() ?? '0';
                                  String imageUrl = coffee['imageUrl'] ?? 'default_image_url.jpg';
                                  String description = coffee['description'] ?? 'Default Description';

                                  Coffee newCoffee = Coffee(
                                    name: name,
                                    type: type,
                                    price: price,
                                    imageUrl: imageUrl,
                                    description: description,
                                  );
                                  addCoffeeToDatabase(newCoffee);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Lottie.asset(AppImages.empty),
        ),
      )
    );
  }
}

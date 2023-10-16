import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/utils/colors/app_colors.dart';
import 'package:coffee/utils/images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'edit_screen/edit_screen.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCoffeeData = [];
  bool isSearching = false;
  bool isLoading = true;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchCoffeeData();
  }

  Future<void> fetchCoffeeData() async {
    try {
      final QuerySnapshot querySnapshot =
      await firestore.collection('coffees').get();

      filteredCoffeeData = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCoffee(String id) async {
    try {
      await firestore.collection('coffees').doc(id).delete();
    // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.c_201,
      title: isSearching
          ? TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        onChanged: (query) {},
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
        ),
      )
          : const Text(
        'Coffee App',
        style: TextStyle(color: Colors.white),
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
              }
            });
          },
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.c_201,
      appBar: appBar,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator()
      )
          : filteredCoffeeData.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.63,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: filteredCoffeeData.length,
          itemBuilder: (context, index) {
            final coffee = filteredCoffeeData[index];
            return Container(
              margin: const EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.c_19ff,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ZoomTapAnimation(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoffeeEditScreen(
                                coffee: coffee,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 140,
                          width: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.file(
                              File(coffee['imageUrl']??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3r1s8qt1jMFd_y-bzV8skZdYb6PYQgUKIAq7BXzuv6peeWIHsjPzK7seb7mrXgePv0a4&usqp=CAU'),
                              fit: BoxFit.fill,
                              errorBuilder:
                                  (context, error, stackTrace) {
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
                        )),
                    const SizedBox(height: 10),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coffee['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            coffee['type'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  color:
                                  Colors.white.withOpacity(0.08),
                                ),
                                child: Text(
                                  '\$${coffee['price'].toString()}',
                                  style:
                                  const TextStyle(color: Colors.white),
                                ),
                              ),
                              ZoomTapAnimation(
                                onTap: (){
                                  deleteCoffee(coffee['id']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    color: AppColors.c_EFE3,
                                  ),
                                  child: const Icon(Icons.delete),
                                ),
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
          :  Center(
        child:Center(
          child: Padding(
            padding: const EdgeInsets.all(100.0),
            child: Lottie.asset(AppImages.empty),
          ),
        )
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_task/features/addProduct/add_product_screen.dart';
import 'package:flutter_task/features/login/screens/login_screen.dart';
import 'package:flutter_task/features/shared_pref/products.dart';
import 'package:flutter_task/features/shared_pref/token.dart';
import 'package:flutter_task/models/product_model.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  List<ProductModel> productsList = [];
  bool isLoading = false;
  getProducts() async {
    setState(() {
      isLoading = true;
    });
    productsList = await SharedPrefProducts().getProducts() ?? [];
    Future.delayed(Duration(seconds: 1)).whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  logout() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      SharedPrefToken().removeToken();
      Get.to(() => LoginScreen());
    });
  }

  bool showSearchField = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showSearchField = !showSearchField;
                });
              },
              icon: Icon(
                showSearchField == false ? Icons.search : Icons.cancel_outlined,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
        centerTitle: true,
        title:
            showSearchField ? SizedBox(width: 250, child: TextField()) : null,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi-Fi Shop & Service",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 28),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Audio on Rustavelie Ave 57. \nThis shop offers both products and services",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        children: [
                          ...List.generate(productsList.length, (index) {
                            ProductModel product = productsList[index];
                            return Container(
                              width: Get.width * 0.42,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                          height: 140,
                                          width: 170,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image.file(
                                              File(product.image),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      Positioned(
                                          right: 10,
                                          top: 0,
                                          child: IconButton(
                                              onPressed: () async {
                                                await SharedPrefProducts()
                                                    .removeProduct(product.id);
                                                getProducts();
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              )))
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '\$' + "${product.price}.00",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddProductScreen())!.then((value) => setState(() {
                getProducts();
              }));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }
}

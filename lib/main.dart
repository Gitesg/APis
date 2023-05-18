import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'description.dart';
import 'login/formvalidation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignUp(),
    );
  }
}

class Home extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const Home({
    required this.name,
    required this.email,
    required this.phone,
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  String _productType = 'women';
  List<dynamic> _menProducts = [];
  List<dynamic> _womenProducts = [];

  Future<List<dynamic>> fetchDetails() async {
    var url = Uri.parse('https://fakestoreapi.com/products');

    try {
      var response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          _menProducts = responseJson
              .where((product) => product['category'] == "men's clothing")
              .toList();
          _womenProducts = responseJson
              .where((product) => product['category'] == "women's clothing")
              .toList();
        });

        return responseJson;
      } else {
        //print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Timeout occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Request timed out');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetails().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> productsToShow =
    _productType == 'men' ? _menProducts : _womenProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Store'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _productType = 'men';
              });
            },
            icon: const Icon(Icons.person),
            tooltip: "Men's Products",
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _productType = 'women';
              });
            },
            icon: const Icon(Icons.person_pin),
            tooltip: "Women's Products",
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Name: ${widget.name}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Email: ${widget.email}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Phone: ${widget.phone}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _productType = 'men';
                      productsToShow = _menProducts;
                    });
                  },
                  child: const Text('Men'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _productType = 'women';
                      productsToShow = _womenProducts;
                    });
                  },
                  child: const Text('Women'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _productType = 'all';
                      productsToShow = [
                        ..._menProducts,
                        ..._womenProducts,
                      ];
                    });
                  },
                  child: const Text('All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: productsToShow.length,
              itemBuilder: (BuildContext context, int index) {
                var item = productsToShow[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedProduct(
                          product: item,
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black87,
                      title: Text(
                        item['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '\$${item['price']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


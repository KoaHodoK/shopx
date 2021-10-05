import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopx/model/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final url = "https://fakestoreapi.com/products";

  /* late var _postPosts;
  Future<Product> fetchPosts() async {
    final response = await get(Uri.parse(url));
    final jsonData = jsonDecode(response.body);
    return Product.fromJson(jsonData);
  } 
  

  
  }*/
  late Future<List<Product>> posts;
  Future<List<Product>> fetchPost() async {
    final response = await get(Uri.parse(url)); //return String
    List<dynamic> jsonData =
        jsonDecode(response.body); //return list of  json obj

    List<Product> products = jsonData.map((e) => Product.fromJson(e)).toList();

    return products; //change json obj to product obj
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posts = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
            body: FutureBuilder<List<Product>>(
                future: fetchPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data![index];

                        return Card(
                          elevation: 2.0,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage("${post.image}"),
                                        fit: BoxFit.cover)),
                              ),
                              ListTile(
                                title: Text(
                                  "${post.title}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text('${index + 1}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                subtitle: Text(
                                  "\$ ${post.price}",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
            floatingActionButton: FloatingActionButton.extended(
              splashColor: Colors.yellowAccent,
              label: Text(
                'Shop',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
              backgroundColor: Colors.amber,
              onPressed: () {},
              icon: Icon(
                Icons.shopping_basket,
                color: Colors.black,
                size: 30,
              ),
            )),
      ),
    );
  }
}

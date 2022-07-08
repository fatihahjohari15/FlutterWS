import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor/constants.dart';
import 'package:mytutor/models/cart.dart';
import 'package:mytutor/models/user.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = <Cart>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  double totalpayable = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenHeight <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 211, 168, 197),
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: cartList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Text(titlecenter,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 1),
                            children: List.generate(cartList.length, (index) {
                              return InkWell(
                                  child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 242, 238, 238),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 6,
                                            child: CachedNetworkImage(
                                              imageUrl: CONSTANTS.server +
                                                  "/mytutor/mobile/assets/courses/" +
                                                  cartList[index]
                                                      .subid
                                                      .toString() +
                                                  '.png',
                                              fit: BoxFit.cover,
                                              width: resWidth,
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Text(
                                            cartList[index].subname.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 1),
                                          Flexible(
                                              flex: 4,
                                              child: Column(children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 7,
                                                      child: Column(children: [
                                                        const SizedBox(
                                                            height: 1),
                                                        Text(
                                                            "Price:\nRM " +
                                                                cartList[index]
                                                                    .pricetotal
                                                                    .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ]),
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              _deleteItem(
                                                                  index);
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete))),
                                                  ],
                                                ),
                                              ]))
                                        ],
                                      )));
                            }))),
                    Card(
                      color: const Color.fromARGB(255, 232, 164, 227),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Subtotal: RM " + totalpayable.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Pay Now",
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )));
  }

  void _loadCart() {
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_cart.php"),
        body: {
          'email': widget.user.email,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['cart'] != null) {
          cartList = <Cart>[];
          extractdata['cart'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          int qty = 0;
          totalpayable = 0.00;
          for (var element in cartList) {
            qty = qty + int.parse(element.cartqty.toString());
            totalpayable =
                totalpayable + double.parse(element.pricetotal.toString());
          }
          titlecenter = qty.toString() + " Subjects Has Been Added";
          setState(() {});
        }
      } else {
        titlecenter = "Your Cart is Empty 😞 ";
        cartList.clear();
        setState(() {});
      }
    });
  }

  void _deleteItem(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/delete_item.php"),
        body: {
          'email': widget.user.email,
          'cartid': cartList[index].cartid
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Subject successfully removed from your cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}

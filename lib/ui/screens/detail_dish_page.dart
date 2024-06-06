import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/db/cartController.dart';
import 'package:food_app/db/dishController.dart';
import 'package:food_app/ui/screens/my_order_view.dart';

import '../../constants.dart';
import '../../db/restaurantController.dart';
import '../../db/userController.dart';
import '../../model/dishes.dart';
import '../../model/restaurants.dart';

class DetailDish extends StatefulWidget {
  final int resID;
  const DetailDish({super.key, required this.resID});

  @override
  State<DetailDish> createState() => _DetailDishState();
}

class _DetailDishState extends State<DetailDish> with SingleTickerProviderStateMixin {
  Map<int, int> cart = {};

  @override
  void initState() {
    super.initState();
    _getItem();
    _search1();
    _search2();
    _search3();
    _getCart();
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Restaurants item = Restaurants(
    id: 0,
    name: '',
    address: '',
    phone: '',
    opening_hours: '',
    created_at: null,
    updated_at: null,
  );

  Future<void> _getItem() async {
    try {
      ApiResponse response = await RestaurantController().getItem(widget.resID);
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = jsonDecode(response.body);
          item = Restaurants.fromMap(data);
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  List<dynamic> list1 = [];
  List<dynamic> list2 = [];
  List<dynamic> list3 = [];
  List<dynamic> list = [];

  Future<void> _search1() async {
    try {
      ApiResponse response = await DishController().search("Món chính");
      if (response.statusCode == 200) {
        setState(() {
          list1 = jsonDecode(response.body);
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  Future<void> _search2() async {
    try {
      ApiResponse response = await DishController().search("Món thêm");
      if (response.statusCode == 200) {
        setState(() {
          list2 = jsonDecode(response.body);
          print(list2);
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  Future<void> _search3() async {
    try {
      ApiResponse response = await DishController().search("Đồ uống");
      if (response.statusCode == 200) {
        setState(() {
          list3 = jsonDecode(response.body);
          print(list3);
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  Future<void> _searchQuantity() async {
    try {
      ApiResponse response = await DishController().search("Đồ uống");
      if (response.statusCode == 200) {
        setState(() {
          list3 = jsonDecode(response.body);
          print(list3);
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  Future<void> _getCart() async {
    try {
      ApiResponse response = await CartController().getAll("1", widget.resID);
      if (response.statusCode == 200) {
        setState(() {
          list = jsonDecode(response.body);
          print(list.length);
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                // Các hành động của bạn ở đây
              },
              icon: Icon(
                Icons.favorite_outlined,
                color: Constants.primaryColor,
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "${item.name}",
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Image(image: AssetImage("assets/images/address.png")),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "${item.address}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Image(image: AssetImage("assets/images/phone.png")),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "${item.phone}  -  ${item.opening_hours}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Constants.backgroundTable,
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(text: 'Món chính'),
                      Tab(text: 'Món thêm'),
                      Tab(text: 'Đồ uống'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    buildDishList(list1),
                    buildDishList(list2),
                    buildDishList(list3),
                  ],
                ),
              ),
            ),
          ),
          buildCartButton(context),
        ],
      ),
    );
  }

  Widget buildDishList(List<dynamic> dishList) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: dishList.length,
              itemBuilder: ((context, index) {
                var pObj = Dishes.fromMap(dishList[index]);

                final prefix = 'data:image/jpeg;base64,';
                Uint8List? bytes;
                if (pObj.img != null && pObj.img.startsWith(prefix)) {
                  var base64Image = pObj.img.substring(prefix.length);
                  if (base64Image.length % 4 == 0) {
                    try {
                      bytes = base64Decode(base64Image);
                    } on FormatException {
                      print('Không thể giải mã hình ảnh: dữ liệu base64 không hợp lệ.');
                      bytes = null;
                    }
                  } else {
                    print('Dữ liệu hình ảnh bị hỏng: độ dài không phải là bội số của 4.');
                    bytes = null;
                  }
                } else {
                  bytes = null;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bytes != null
                        ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.memory(
                        bytes,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/address.png",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 2),
                            child: Text(
                              pObj.name,
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${pObj.price}.000đ",
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          buildQuantityButton(CupertinoIcons.minus, () => onDecrement(pObj.id)),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${cart[pObj.id] ?? 0}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          buildQuantityButton(CupertinoIcons.add, () => onIncrement(pObj)),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget buildCartButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Constants.backgroundTable,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return buildCartPopup(context);
                },
                isScrollControlled: true,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: AssetImage("assets/images/cart.png")),
                Text(
                  "(${cart.length})",
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Text(
            "${getTotalAmount()}.000đ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Constants.primaryColor,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOrderView()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Đặt hàng",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartPopup(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.67,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Giỏ hàng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Constants.primaryColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Constants.primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      int id = cart.keys.elementAt(index);
                      var item = getItemById(id);
                      return ListTile(
                        leading: item.img != null ? Image.memory(
                          base64Decode(item.img.substring('data:image/jpeg;base64,'.length)),
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                        ) : Icon(Icons.image_not_supported),
                        title: Text(item.name),
                        subtitle: Text("${item.price}.000đ"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildQuantityButton(CupertinoIcons.minus, () {
                              setState(() {
                                onDecrement(item.id);
                              });
                            }),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${cart[item.id]}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            buildQuantityButton(CupertinoIcons.add, () {
                              setState(() {
                                onIncrement(item);
                              });
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tổng cộng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Constants.primaryColor,
                      ),
                    ),
                    Text(
                      "${getTotalAmount()}.000đ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Dishes getItemById(int id) {
    for (var dish in list1) {
      if (Dishes.fromMap(dish).id == id) return Dishes.fromMap(dish);
    }
    for (var dish in list2) {
      if (Dishes.fromMap(dish).id == id) return Dishes.fromMap(dish);
    }
    for (var dish in list3) {
      if (Dishes.fromMap(dish).id == id) return Dishes.fromMap(dish);
    }
    throw Exception('Item not found');
  }

  void onDecrement(int id) {
    setState(() {
      if (cart[id] != null && cart[id]! > 0) {
        cart[id] = cart[id]! - 1;
        if (cart[id] == 0) {
          cart.remove(id);
        }
      }
    });
  }

  void onIncrement(Dishes pObj) {
    setState(() {
      if (cart[pObj.id] != null) {
        cart[pObj.id] = cart[pObj.id]! + 1;
      } else {
        cart[pObj.id] = 1;
      }
    });
  }

  int getTotalAmount() {
    int total = 0;
    cart.forEach((id, quantity) {
      total += getItemById(id).price * quantity;
    });
    return total;
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/model/carts.dart';
import 'package:food_app/model/dishes.dart';
import 'package:food_app/model/orders.dart';
import 'package:food_app/model/reviews.dart';
import 'package:food_app/ui/screens/detail_dish_page.dart';
import 'package:food_app/ui/screens/reviewScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/cartController.dart';
import '../../db/firebaseController.dart';
import '../../db/orderController.dart';
import '../../db/restaurantController.dart';
import '../../db/reviewController.dart';
import '../../db/userController.dart';
import '../../model/firebaseModel.dart';
import '../../model/restaurants.dart';

void main() {
  runApp(MaterialApp(
    home: OrderScreen(),
    theme: ThemeData(
      primaryColor: Constants.primaryColor,
    ),
  ));
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getUserId().then((_) {
      _getItem();
    });
  }

  var user_id = 0;
  // Lấy user_id
  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt('user_id')!;
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

  List<dynamic> list = [];
  Map<int, Map<dynamic, dynamic>> cart = {};
  Future<void> _getItem() async {
    try {
      ApiResponse response = await CartController().getAllByUser(user_id);
      if (response.statusCode == 200) {
        setState(() {
          list = jsonDecode(response.body);
          list.forEach((item) {
            cart[item['id']] = {
              'restaurant_name': item['restaurant_name'],
              'address': item['address'],
              'img': item['img'],
              'count': item['count'],
            };
          });
        });
      } else {
        _showSnackBar('Server error. Please try again later.', Colors.red);
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print(error);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng',
            style:
                TextStyle(color: Constants.white, fontWeight: FontWeight.bold)),
        backgroundColor: Constants.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Constants.white,
          labelStyle: TextStyle(fontSize: 18.0, color: Constants.white),
          tabs: [
            Tab(text: 'Đang đến'),
            Tab(text: 'Đánh giá'),
            Tab(text: 'Giỏ hàng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DangDenTab(),
          DanhGiaTab(),
          GioHangTab(cart),
        ],
      ),
    );
  }
}

class DangDenTab extends StatelessWidget {
  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  final FirebaseController _controller = FirebaseController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final user_id = snapshot.data ?? 0;
          return StreamBuilder<List<FirebaseModel>>(
            stream: _controller.getAll(user_id.toInt(), "Hoàn thành"),
            builder: (context, snapshot1) {
              if (!snapshot1.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                final orders = snapshot1.data;
                return ListView.builder(
                  itemCount: orders?.length,
                  itemBuilder: (context, index) {
                    final order = orders?[index];
                    print("order_id: ${order?.status}");
                    Future<Restaurants> _getItem(int resId) async {
                      Restaurants res = Restaurants(
                        id: 0,
                        name: '',
                        address: '',
                        phone: '',
                        opening_hours: '',
                        created_at: null,
                        updated_at: null,
                      );

                      try {
                        ApiResponse response =
                            await RestaurantController().getItem(resId);

                        if (response.statusCode == 200) {
                          Map<String, dynamic> data = jsonDecode(response.body);
                          res = Restaurants.fromMap(data);
                        }
                      } catch (error) {
                        print(error);
                      }

                      return res;
                    }

                    return FutureBuilder<Restaurants>(
                      future: _getItem(order!.res_id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          Restaurants? res = snapshot.data;
                          return Card(
                            margin: EdgeInsets.all(10),
                            color: Constants.backgroundTable,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Đồ ăn ${order.order_id}',
                                      style: TextStyle(
                                          color: Constants.highlightColor,
                                          fontSize: 15)),
                                  SizedBox(height: 5),
                                  Text("${res?.name}",
                                      style: TextStyle(
                                          color: Constants.accentColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text("Tình trạng: ${order?.status}",
                                      style: TextStyle(
                                          color: Constants.accentColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  FutureBuilder(
                                    future: OrderController()
                                        .getAllByOrder(order!.order_id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        List<dynamic> list =
                                            jsonDecode(snapshot.data!.body);
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            var orderItem = list[index];

                                            return Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: (orderItem['dishes']
                                                          as List)
                                                      .map<Widget>((item) {
                                                    final prefix =
                                                        'data:image/jpeg;base64,';
                                                    Uint8List? bytes;
                                                    if (item['img'] != null &&
                                                        item['img'].startsWith(
                                                            prefix)) {
                                                      var base64Image =
                                                          item['img'].substring(
                                                              prefix.length);
                                                      if (base64Image.length %
                                                              4 ==
                                                          0) {
                                                        try {
                                                          bytes = base64Decode(
                                                              base64Image);
                                                        } on FormatException {
                                                          print(
                                                              'Không thể giải mã hình ảnh: dữ liệu base64 không hợp lệ.');
                                                          bytes = null;
                                                        }
                                                      } else {
                                                        print(
                                                            'Dữ liệu hình ảnh bị hỏng: độ dài không phải là bội số của 4.');
                                                        bytes = null;
                                                      }
                                                    } else {
                                                      bytes = null;
                                                    }
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5.0),
                                                      child: Row(
                                                        children: [
                                                          bytes != null
                                                              ? Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Image
                                                                      .memory(
                                                                    bytes,
                                                                    width: 60,
                                                                    height: 60,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            exception,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return const Icon(
                                                                          Icons
                                                                              .error);
                                                                    },
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/image.png",
                                                                    width: 60,
                                                                    height: 60,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            item['dish_name'],
                                                            style: TextStyle(
                                                              color: Constants
                                                                  .textColor,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "${item['quantity']}",
                                                            style: TextStyle(
                                                              color: Constants
                                                                  .textColor,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                                Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${order.total}.000đ',
                                                      style: TextStyle(
                                                        color: Constants
                                                            .primaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${orderItem['length']} món',
                                                      style: TextStyle(
                                                        color: Constants
                                                            .lightTextColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}

class DanhGiaTab extends StatelessWidget {
  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  String done = "Đã đánh giá";
  final FirebaseController _controller = FirebaseController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final user_id = snapshot.data ?? 0;
          return StreamBuilder<List<FirebaseModel>>(
            stream: _controller.getOrdered(user_id.toInt(), "Hoàn thành"),
            builder: (context, snapshot1) {
              if (!snapshot1.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                final orders = snapshot1.data;
                return ListView.builder(
                  itemCount: orders?.length,
                  itemBuilder: (context, index) {
                    final order = orders?[index];

                    Future<Restaurants> _getItem(int resId) async {
                      Restaurants res = Restaurants(
                        id: 0,
                        name: '',
                        address: '',
                        phone: '',
                        opening_hours: '',
                        created_at: null,
                        updated_at: null,
                      );

                      try {
                        ApiResponse response =
                        await RestaurantController().getItem(resId);

                        if (response.statusCode == 200) {
                          Map<String, dynamic> data = jsonDecode(response.body);
                          res = Restaurants.fromMap(data);
                        }
                      } catch (error) {
                        print(error);
                      }

                      return res;
                    }

                    return FutureBuilder<Restaurants>(
                      future: _getItem(order!.res_id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          Restaurants? res = snapshot.data;

                          Future<Reviews> _getReview(int order_id) async {
                            Reviews reviews = Reviews(
                              id: 0,
                              order_id: 0,
                              user_id: 0,
                              restaurant_id: 0,
                              rating: 0,
                              comment: '',
                              created_at: null,
                              updated_at: null,
                            );

                            try {
                              ApiResponse response =
                              await ReviewController().getItem(order.order_id);

                              if (response.statusCode == 200) {
                                Map<String, dynamic> data = jsonDecode(response.body);
                                reviews = Reviews.fromMap(data);
                              }
                            } catch (error) {
                              print(error);
                            }

                            return reviews;
                          }

                          return FutureBuilder<Reviews>(
                            future: _getReview(order.order_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                Reviews? review = snapshot.data;
                                if (review?.id == 0) {
                                  done = "Đánh giá";
                                }
                                return
                                  Card(
                                    margin: EdgeInsets.all(10),
                                    color: Constants.backgroundTable,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Đồ ăn ${order.order_id}',
                                              style: TextStyle(
                                                  color: Constants.textColor,
                                                  fontSize: 16)),
                                          SizedBox(height: 5),
                                          Text("${res?.name}",
                                              style: TextStyle(
                                                  color: Constants.accentColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          FutureBuilder(
                                            future: OrderController()
                                                .getAllByOrder(order!.order_id),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text("Error: ${snapshot.error}");
                                              } else {
                                                List<dynamic> list =
                                                jsonDecode(snapshot.data!.body);
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  itemCount: list.length,
                                                  itemBuilder: (context, index) {
                                                    var orderItem = list[index];
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children:
                                                              (orderItem['dishes']
                                                              as List)
                                                                  .map<Widget>(
                                                                      (item) {
                                                                    final prefix =
                                                                        'data:image/jpeg;base64,';
                                                                    Uint8List? bytes;
                                                                    if (item['img'] !=
                                                                        null &&
                                                                        item['img']
                                                                            .startsWith(
                                                                            prefix)) {
                                                                      var base64Image = item[
                                                                      'img']
                                                                          .substring(prefix
                                                                          .length);
                                                                      if (base64Image
                                                                          .length %
                                                                          4 ==
                                                                          0) {
                                                                        try {
                                                                          bytes = base64Decode(
                                                                              base64Image);
                                                                        } on FormatException {
                                                                          print(
                                                                              'Không thể giải mã hình ảnh: dữ liệu base64 không hợp lệ.');
                                                                          bytes = null;
                                                                        }
                                                                      } else {
                                                                        print(
                                                                            'Dữ liệu hình ảnh bị hỏng: độ dài không phải là bội số của 4.');
                                                                        bytes = null;
                                                                      }
                                                                    } else {
                                                                      bytes = null;
                                                                    }
                                                                    return Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                          5.0),
                                                                      child: Row(
                                                                        children: [
                                                                          bytes != null
                                                                              ? Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                            child: Image
                                                                                .memory(
                                                                              bytes,
                                                                              width:
                                                                              60,
                                                                              height:
                                                                              60,
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                              errorBuilder: (BuildContext context,
                                                                                  Object
                                                                                  exception,
                                                                                  StackTrace?
                                                                                  stackTrace) {
                                                                                return const Icon(
                                                                                    Icons.error);
                                                                              },
                                                                            ),
                                                                          )
                                                                              : Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                            child: Image
                                                                                .asset(
                                                                              "assets/images/image.png",
                                                                              width:
                                                                              60,
                                                                              height:
                                                                              60,
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                            item[
                                                                            'dish_name'],
                                                                            style:
                                                                            TextStyle(
                                                                              color: Constants
                                                                                  .textColor,
                                                                              fontSize: 15,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                            ),
                                                            Spacer(),
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Text(
                                                                  '${order.total}.000đ',
                                                                  style: TextStyle(
                                                                    color: Constants
                                                                        .primaryColor,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${orderItem['length']} món',
                                                                  style: TextStyle(
                                                                    color: Constants
                                                                        .lightTextColor,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                  Colors.white,
                                                                  backgroundColor:
                                                                  Colors.pinkAccent,
                                                                ),
                                                                onPressed: () {
                                                                  if (done == "Đánh giá"){
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ReviewScreen(resID: res!.id, userID: user_id, orderID: order.order_id)),
                                                                    );
                                                                  }
                                                                },
                                                                child: Text("${done}"),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              child: ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                  Colors.pinkAccent,
                                                                  backgroundColor:
                                                                  Colors.white,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => DetailDish(resID: res!.id) //replace with your new page
                                                                      )
                                                                  );},
                                                                child: Text('Đặt lại'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                              }
                            },
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}

class GioHangTab extends StatelessWidget {
  final Map<int, Map<dynamic, dynamic>> cart;

  GioHangTab(this.cart);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (context, index) {
        int id = cart.keys.elementAt(index);
        var item = cart[id];
        return GestureDetector(
          // Sử dụng GestureDetector
          onTap: () {
            // Navigate to HomePage when card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailDish(resID: id)),
            );
          },
          child: Card(
            margin: EdgeInsets.all(10),
            color: Constants.backgroundTable,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  item?['img'] != null
                      ? Image.memory(
                          base64Decode(item?['img']
                              .substring('data:image/jpeg;base64,'.length)),
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        )
                      : Icon(Icons.image_not_supported),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item?['restaurant_name'],
                            style: TextStyle(
                                color: Constants.accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(item?['address'],
                            style: TextStyle(
                                color: Constants.textColor, fontSize: 15)),
                        SizedBox(height: 5),
                        Text("${item?['count']} sản phẩm",
                            style: TextStyle(color: Constants.lightTextColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

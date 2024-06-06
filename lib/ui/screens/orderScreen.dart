import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/ui/screens/reviewScreen.dart';


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

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('Đơn hàng', style: TextStyle(color: Constants.white, fontWeight: FontWeight.bold)),
        backgroundColor: Constants.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Constants.white,
          labelStyle: TextStyle(fontSize: 18.0, color: Constants.white),
          tabs: [
            Tab(text: 'Đang đến'),
            Tab(text: 'Lịch sử'),
            Tab(text: 'Đánh giá'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DangDenTab(),
          LichSuTab(),
          DanhGiaTab(),
        ],
      ),
    );
  }
}

class DangDenTab extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'id': '#06064-784530415',
      'shop': 'Bee Milktea & Coffee - Nguyễn Phước Lan',
      'items': [
        {'name': 'Trà mãng cầu size L', 'image': 'assets/images/item_1.png'},
        {'name': 'Trà sữa thái xanh', 'image': 'assets/images/item_2.png'}
      ],
      'total': 110050,
      'status': 'Đang giao',
      'deliveryTime': '22:35 Hôm nay'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: EdgeInsets.all(10),
          color: Constants.backgroundTable,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đồ ăn ${order['id']}', style: TextStyle(color: Constants.highlightColor, fontSize: 15)),
                SizedBox(height: 5),
                Text(order['shop'], style: TextStyle(color: Constants.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order['items'].map<Widget>((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Image.asset(item['image'], height: 60),
                              SizedBox(width: 10),
                              Text(item['name'], style: TextStyle(color: Constants.textColor, fontSize: 15)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${order['total']}đ', style: TextStyle(color: Constants.primaryColor, fontSize: 16)),
                        Text('${order['items'].length} món', style: TextStyle(color: Constants.lightTextColor, fontSize: 16)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(order['status'], style: TextStyle(color: Constants.textColor, fontWeight: FontWeight.bold)),
                      Text('Dự kiến giao: ${order['deliveryTime']}', style: TextStyle(color: Constants.textColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LichSuTab extends StatelessWidget {
  final List<Map<String, dynamic>> history = [
    {
      'id': '#05054-674530315',
      'shop': 'Highlands Coffee - Nguyễn Huệ',
      'items': [
        {'name': 'Cà phê sữa đá', 'image': 'assets/images/item_3.png'},
        {'name': 'Bánh mì thịt', 'image': 'assets/images/item_1.png'}
      ],
      'total': 85000,
      'date': '21/4 lúc 14:00',
      'status': 'Đã giao'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Constants.backgroundTable,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.yellow),
              SizedBox(width: 10),
              Text('Đánh giá quán, nhận ngay 500 Xu', style: TextStyle(color: Constants.textColor, fontSize: 16)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: Constants.textColor),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final order = history[index];
              return Card(
                margin: EdgeInsets.all(10),
                color: Constants.backgroundTable,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đồ ăn ${order['id']}', style: TextStyle(color: Constants.textColor, fontSize: 16)),
                      SizedBox(height: 5),
                      Text(order['shop'], style: TextStyle(color: Constants.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: order['items'].map<Widget>((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Image.asset(item['image'], height: 60),
                                    SizedBox(width: 10),
                                    Text(item['name'], style: TextStyle(color: Constants.textColor, fontSize: 16)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${order['total']}đ', style: TextStyle(color: Constants.primaryColor, fontSize: 16)),
                              Text('${order['items'].length} món', style: TextStyle(color: Constants.lightTextColor, fontSize: 16)),
                              Text('Ngày đặt: ${order['date']}', style: TextStyle(color: Constants.lightTextColor)),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.pinkAccent,
                              ),
                              onPressed: () {},
                              child: Text(order['status']),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.pinkAccent, backgroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              child: Text('Đặt lại'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DanhGiaTab extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      'shop': 'Bee Milktea & Coffee',
      'item': 'Trà mãng cầu size L',
      'image': 'assets/images/item_1.png',
      'daysLeft': 26,
    },
    {
      'shop': 'Bánh Tráng  Quỳnh Anh',
      'item': '20 cái Phồng Sữa',
      'image': 'assets/images/item_2.png',
      'daysLeft': 25,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: EdgeInsets.all(10),
          color: Constants.backgroundTable,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(review['image'], height: 60),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review['shop'], style: TextStyle(color: Constants.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(review['item'], style: TextStyle(color: Constants.textColor, fontSize: 15)),
                      SizedBox(height: 5),
                      Text('Chỉ còn ${review['daysLeft']} ngày để đánh giá', style: TextStyle(color: Constants.lightTextColor)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReviewScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Text('Đánh giá', style: TextStyle(color: Constants.accentColor)),
                      SizedBox(width: 5),
                      Icon(Icons.monetization_on, color: Colors.yellow),
                      Text('200', style: TextStyle(color: Constants.accentColor)),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.accentColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

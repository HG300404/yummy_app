import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/ui/admin/dashboard.dart';
import 'package:food_app/ui/admin/dish_admin/dishes_admin.dart';
import 'package:food_app/ui/admin/favorite_admin/favorite_admin.dart';
import 'package:food_app/ui/admin/restaurant_admin/restaurant_admin.dart';
import 'package:food_app/ui/admin/user_admin/users_admin.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    UsersAdmin(),
    DishesAdmin(),
    RestaurantAdmin(),
    FavoriteAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_selectedIndex == 1 ? "QUẢN LÝ NGƯỜI DÙNG" :
              _selectedIndex == 2 ? "QUẢN LÝ MÓN ĂN" :
                  _selectedIndex == 3 ? "QUÁN LÝ QUÁN ĂN" :
                      _selectedIndex == 4 ? "QUÁN LÝ YÊU THÍCH" : ""
          ),
        ),
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "YUMMY FOOD",
                  style: TextStyle(fontSize: 20.0),
                ),
                accountEmail: Text(
                  "yummy@gmail.com",
                  style: TextStyle(fontSize: 14.0),
                ),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/logo.png")),
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                ),
              ),
              ListTile(
                leading: ImageIcon(
                    AssetImage("assets/images/icon_dashboard.png"),
                    color: (_selectedIndex == 0
                        ? Constants.primaryColor
                        : Constants.accentColor)),
                title: Text(
                  'Tổng quan',
                  style: TextStyle(
                    color: (_selectedIndex == 0
                        ? Constants.primaryColor
                        : Constants.accentColor),
                  ),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: ImageIcon(AssetImage("assets/images/icon_user.png"),
                    color: (_selectedIndex == 1
                        ? Constants.primaryColor
                        : Constants.accentColor)),
                title: Text(
                  'Người dùng',
                  style: TextStyle(
                    color: (_selectedIndex == 1
                        ? Constants.primaryColor
                        : Constants.accentColor),
                  ),
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: ImageIcon(AssetImage("assets/images/icon_dishes.png"),
                    color: (_selectedIndex == 2
                        ? Constants.primaryColor
                        : Constants.accentColor)),
                title: Text(
                  'Món ăn',
                  style: TextStyle(
                    color: (_selectedIndex == 2
                        ? Constants.primaryColor
                        : Constants.accentColor),
                  ),
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: ImageIcon(
                    AssetImage("assets/images/icon_restaurant.png"),
                    color: (_selectedIndex == 3
                        ? Constants.primaryColor
                        : Constants.accentColor)),
                title: Text(
                  'Quán ăn',
                  style: TextStyle(
                    color: (_selectedIndex == 3
                        ? Constants.primaryColor
                        : Constants.accentColor),
                  ),
                ),
                selected: _selectedIndex == 3,
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: ImageIcon(
                    AssetImage("assets/images/icon_favorite.png"),
                    color: (_selectedIndex == 4
                        ? Constants.primaryColor
                        : Constants.accentColor)),
                title: Text(
                  'Yêu thích',
                  style: TextStyle(
                    color: (_selectedIndex == 4
                        ? Constants.primaryColor
                        : Constants.accentColor),
                  ),
                ),
                selected: _selectedIndex == 4,
                onTap: () {
                  _onItemTapped(4);
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 15),

              Divider(),

              SizedBox(height: 15),

              ListTile(
                leading:
                    Image(image: AssetImage("assets/images/icon_home.png")),
                title: Text(
                  'Trang chủ',
                  style: TextStyle(color: Constants.accentColor),
                ),
                selected: _selectedIndex == 5,
                onTap: () {
                  _onItemTapped(5);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    Image(image: AssetImage("assets/images/icon_logout.png")),
                title: Text(
                  'Đăng xuất',
                  style: TextStyle(color: Constants.accentColor),
                ),
                selected: _selectedIndex == 6,
                onTap: () {
                  _onItemTapped(6);
                  Navigator.pop(context);
                },
              ),
              // You can add other sections or footer here
            ],
          ),
        ));
  }
}

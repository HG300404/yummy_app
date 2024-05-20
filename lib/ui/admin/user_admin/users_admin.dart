import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/db/usersDB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../model/users.dart';

class UsersAdmin extends StatefulWidget {
  const UsersAdmin({super.key});

  @override
  State<UsersAdmin> createState() => _UsersAdminState();
}


class _UsersAdminState extends State<UsersAdmin> {


  // Tạo controller cho TextFormField
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _addressController = TextEditingController();
  final _levelController = TextEditingController();
  final _coinController = TextEditingController();
  final _imageURLController = TextEditingController();

  // Hàm để hiển thị AlertDialog
  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm người dùng mới"),
        content: SingleChildScrollView(
          // Bao gồm Column trong một SingleChildScrollView
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Tên người dùng'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _userTypeController,
                decoration: const InputDecoration(labelText: 'Phân quyền'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(labelText: 'Level'),
              ),
              TextFormField(
                controller: _coinController,
                decoration: const InputDecoration(labelText: 'Số coin'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              UsersDB().deleteDatabase();
              Navigator.of(context).pop(); // Đóng popup
            },
          ),
          TextButton(
            child: const Text('Lưu'),
            onPressed: () async {
              // Lưu dữ liệu vào Firestore
              Users newUser = Users(
                user_id: Uuid().v4(),
                username: _userNameController.text,
                password: _passwordController.text ,
                email: _emailController.text,
                phone: _phoneController.text,
                address: _addressController.text,
                type: int.parse(_userTypeController.text),
                imageURL: _imageURLController.text,
                level: int.parse(_levelController.text),
                coin: int.parse(_coinController.text),
                createdAt: (Timestamp.now()).toString(),
                updatedAt: (Timestamp.now()).toString(),
              );

              UsersDB().insert(newUser);

              // Xóa nội dung sau khi lưu
              _userNameController.clear();
              _passwordController.clear();
              _phoneController.clear();
              _emailController.clear();
              _userTypeController.clear();
              _imageURLController.clear();
              _addressController.clear();
              _levelController.clear();
              _coinController.clear();

              Navigator.of(context).pop(); // Đóng popup
            },
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: Image(image: AssetImage("assets/images/person.png"))
     ),
      body: FutureBuilder<List<Users>>(
        future: UsersDB().getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Có lỗi xảy ra: ${snapshot.error.toString()}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Chưa có dữ liệu'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Users item = snapshot.data![index];
                  return ListTile(
                    title: Text(item.username),
                    leading: Text(item.user_id),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

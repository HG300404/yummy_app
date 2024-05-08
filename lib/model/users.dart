class Users {
  final String user_id;
  final String username;
  final String password;
  final String email;
  final String phone;
  final String address;
  final int type;
  final String ? imageURL;
  final int level;
  final int coin;
  final String createdAt;
  final String updatedAt;

  const Users(
   {
     required this.user_id,
     required this.username,
     required this.password,
     required this.email,
     required this.phone,
     required this.address,
     required this.type,
     required this.imageURL,
     required this.level,
     required this.coin,
     required this.createdAt,
     required this.updatedAt,
  });
}
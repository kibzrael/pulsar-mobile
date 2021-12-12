// class User {
//   int id;
//   String username;
//   String? category;
//   String? fullname;
//   String? email;
//   String? phone;
//   String? bio;
//   String? portfolio;
//   bool isSuperuser;

//   String? token;

//   @override
//   String toString() {
//     return 'User: $id, @$username - $category';
//   }

//   User(this.id,
//       {required this.username,
//       this.category,
//       this.fullname,
//       this.bio,
//       this.portfolio,
//       this.email,
//       this.phone,
//       this.isSuperuser = false,
//       this.token});

//   User.fromJson(Map<String, dynamic> info)
//       : assert(info['id'] != null),
//         assert(info['username'] != null),
//         assert(info['username'] is String),
//         id = info['id'] is int ? info['id'] : int.tryParse(info['id']),
//         username = info['username'],
//         category = info['category'],
//         fullname = info['fullname'],
//         email = info['email'],
//         phone = info['phone'],
//         bio = info['bio'],
//         portfolio = info['portfolio'],
//         isSuperuser = info['is_superuser'] ?? false;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'username': username,
//       'category': category,
//       'fullname': fullname,
//       'email': email,
//       'phone': phone,
//       'bio': bio,
//       'portfolio': portfolio,
//       'token': token
//     };
//   }
// }

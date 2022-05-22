class User {
  String? name;
  String? phonenum;
  String? email;
  String? password;
  String? address;

  User({this.name, this.phonenum, this.email, this.password, this.address});

  User.fromJson(Map<String, dynamic> json) {
    name = json['user_name'];
    phonenum = json['user_phonenum'];
    email = json['user_email'];
    password = json['user_pass'];
    address = json['user_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_name'] = name;
    data['user_phonenum'] = phonenum;
    data['user_email'] = email;
    data['password'] = password;
    data['user_address'] = address;
    return data;
  }
}

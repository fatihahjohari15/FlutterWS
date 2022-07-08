class User {
  String? name;
  String? phonenum;
  String? email;
  String? password;
  String? address;
  String? cart;

  User(
      {this.name,
      this.phonenum,
      this.email,
      this.password,
      this.address,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phonenum = json['phonenum'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phonenum'] = phonenum;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    data['cart'] = cart.toString();
    return data;
  }
}

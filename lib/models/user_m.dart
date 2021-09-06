class UserM {
  int? date;
  String? id;
  String? company;
  String? email;
  String? phone;
  String? password;
  String? address;
  String? name;
  String? type;
  String? status;

  UserM(
      {this.date,
      this.id,
      this.company,
      this.email,
      this.phone,
      this.address,
      this.name,
      this.type,
      this.status, 
      this.password});

  UserM.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    company = json['company'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.id;
    data['company'] = this.company;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['name'] = this.name;
    data['type'] = this.type;
    data['status'] = this.status;
    data['password'] = this.password;
    return data;
  }
}

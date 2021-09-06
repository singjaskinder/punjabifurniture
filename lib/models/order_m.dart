class OrderM {
  int? date;
  String? id;
  String? typeId;
  String? userId;
  String? company;
  int? orderDate;
  int? deliveryDate;
  String? jobDetails;
  String? adminNote;
  String? userNote;
  String? status;
  bool? completed;
  List<Files>? files;

  OrderM({
    this.date,
    this.id,
    this.typeId,
    this.userId,
    this.company,
    this.orderDate,
    this.deliveryDate,
    this.jobDetails,
    this.adminNote,
    this.userNote,
    this.status,
    this.completed,
    this.files,
  });

  OrderM.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    typeId = json['typed_id'];
    userId = json['user_id'];
    company = json['company'];
    orderDate = json['order_date'];
    deliveryDate = json['delivery_date'];
    jobDetails = json['job_details'];
    adminNote = json['admin_note'];
    userNote = json['user_note'];
    status = json['status'];
    completed = json['completed'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['typed_id'] = this.typeId;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company'] = this.company;
    data['order_date'] = this.orderDate;
    data['delivery_date'] = this.deliveryDate;
    data['job_details'] = this.jobDetails;
    data['admin_note'] = this.adminNote;
    data['user_note'] = this.userNote;
    data['status'] = this.status;
    data['completed'] = this.completed;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  String? type;
  String? link;
  String? fileName;

  Files({this.type, this.link, this.fileName});

  Files.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    link = json['link'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['link'] = this.link;
    data['file_name'] = this.fileName;
    return data;
  }
}

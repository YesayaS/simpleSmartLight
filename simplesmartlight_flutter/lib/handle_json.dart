import 'dart:convert';

class leddata {
  late String name;
  late String connectedStatus;
  late String ledStatus;
  late int r;
  late int g;
  late int b;

  leddata(
      {
        required this.name,
        required this.connectedStatus,
        required this.ledStatus,
        required this.r,
        required this.g,
        required this.b
      });

  leddata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    connectedStatus = json['connected_status'];
    ledStatus = json['led_status'];
    r = json['R'];
    g = json['G'];
    b = json['B'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['connected_status'] = this.connectedStatus;
    data['led_status'] = this.ledStatus;
    data['R'] = this.r;
    data['G'] = this.g;
    data['B'] = this.b;
    return data;
  }
}
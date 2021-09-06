import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

String getImage(String imageName) => 'assets/images/$imageName';

int setDate() => DateTime.now().millisecondsSinceEpoch;

Color hexToColor(String color) =>
    Color(int.parse(color.replaceAll('#', '0xFF')));

String makePrice(dynamic amount) => '\$ ' + amount.toStringAsFixed(2);

String makeDate(int date) {
  final format = DateFormat('dd MMM, on EEEE ');
  final parsedDate = DateTime.fromMillisecondsSinceEpoch(date);
  return format.format(parsedDate);
}

String makeDateTime(String date) {
  if (date != null) {
    final format = DateFormat('dd MMM, E hh:mm a');
    final parsedDate = DateTime.parse(date);
    return format.format(parsedDate);
  } else
    return '';
}

String withCurrency(dynamic amount) => '\$ ' + amount.toString();

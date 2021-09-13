import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/auth.dart';
import 'package:punjabifurniture/apis/order.dart';
import 'package:punjabifurniture/models/order_m.dart';
import 'package:punjabifurniture/models/user_m.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'dart:js' as js;

import 'package:punjabifurniture/utils/overlays/progress_dialog.dart';

class OrderStatusController extends GetxController {
  final orderApis = OrderRepo();
  late bool isAdmin;
  final actions = [
    'Created',
    'Stage 1',
    'Production stage',
    'Ready',
    'Dispatched',
    'Received',
  ];
  final selectedStatus = 'Created'.obs;
  final selectedUser = 'Select Company'.obs;
  String selectedUserId = '';
  final orderDate = 0.obs;
  final deliveryDate = 0.obs;
  final searchCtrl = TextEditingController();
  final searchText = ''.obs;
  final typedIdCtrl = TextEditingController();
  final jobDetailsCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final files = <dynamic>[].obs;
  final filesNames = <String>[].obs;
  List<UserM> users = [];
  late Map<String, String> userWithIds;
  final gettingUser = true.obs;
  final showDetails = false.obs;
  late OrderM order;

  @override
  void onInit() {
    super.onInit();
    isAdmin = (Preferences.saver.getString('type') ?? 'admin') == 'admin';
    searchCtrl.addListener(() {
      searchText.value = searchCtrl.text;
      update();
    });
  }

  Stream<QuerySnapshot> watch() async* {
    if (isAdmin) {
      yield* watchForAdmin();
    } else {
      yield* watchForUser();
    }
  }

  void openFile(int i) async {
    js.context.callMethod('open', [files[i].link]);
  }

  void updateStatus(OrderM order) async {
    try {
      isLoading(true);
      await orderApis.update(order);
      isLoading(false);
      BuildDialog(title: 'Confirmation', description: 'Job status updated');
    } catch (e) {
      print(e);
      isLoading(false);
      BuildDialog();
    }
  }

  void auOrder(bool isUpdate, OrderM? order) async {
    if (typedIdCtrl.text.isEmpty) {
      BuildDialog(description: 'Please enter order id');
      return;
    }
    if (selectedUserId.isEmpty) {
      BuildDialog(description: 'Please select company');
      return;
    }
    if (orderDate.value == 0) {
      BuildDialog(description: 'Please select order date');
      return;
    }
    if (deliveryDate.value == 0) {
      BuildDialog(description: 'Please select delivery date');
      return;
    }
    if (jobDetailsCtrl.text.isEmpty) {
      BuildDialog(description: 'Please enter job details');
      return;
    }
    isLoading(true);
    final List<Files> filesM = [];
    if (!isUpdate) {
      final images = await orderApis.validateFiles(files);
      for (int i = 0; i < files.length; i++) {
        final file = Files(
            type: files[i].name.split('.')[1],
            link: images[i],
            fileName: files[i].name);
        filesM.add(file);
      }
    }

    final orderM = OrderM(
        date: setDate(),
        typeId: typedIdCtrl.text.trim().toLowerCase(),
        id: isUpdate ? order!.id : '',
        userId: selectedUserId,
        company: selectedUser.value,
        orderDate: orderDate.value,
        deliveryDate: deliveryDate.value,
        jobDetails: jobDetailsCtrl.text.trim(),
        status: selectedStatus.value,
        completed: selectedStatus.value == 'Received',
        adminNote: isAdmin ? noteCtrl.text.trim() : order?.adminNote ?? '',
        userNote: !isAdmin ? noteCtrl.text.trim() : order?.userNote ?? '',
        files: isUpdate
            ? files.map((element) => element as Files).toList()
            : filesM);
    if (order!.typeId! != typedIdCtrl.text) {
      final res = await orderApis.checkTypeId(orderM);
      if (res) {
        isLoading(false);
        BuildDialog(description: 'Order Id already exists');
        return;
      }
    }
    await orderApis.update(orderM);
    clearData();
    isLoading(false);
    BuildDialog(
        title: 'Success',
        description: isUpdate ? 'Order details updated' : 'New order added');
  }

  void clearData() {
    showDetails.value = false;
    order = OrderM();
    if (users.isNotEmpty) {
      selectedUser.value = users[0].name!;
      selectedUserId = users[0].id!;
    }
    orderDate.value = 0;
    deliveryDate.value = 0;
    selectedStatus.value = 'Created';
    noteCtrl.clear();
    jobDetailsCtrl.clear();
    typedIdCtrl.clear();
    filesNames.clear();
    files.clear();
  }

  void showJobDetails(OrderM order) {
    this.order = order;
    showDetails.value = true;
    typedIdCtrl.text = order.typeId!;
    jobDetailsCtrl.text = order.jobDetails!;
    orderDate.value = order.orderDate!;
    deliveryDate.value = order.deliveryDate!;
    noteCtrl.text = order.jobDetails!;
    selectedUser.value = order.company!;
    selectedUserId = order.userId!;
    files.clear();
    for (Files file in order.files ?? []) {
      files.add(file);
      filesNames.add(file.fileName!);
    }
  }

  Stream<QuerySnapshot> watchForAdmin() async* {
    yield* orderApis.watch(false, '', isAdmin);
  }

  Stream<QuerySnapshot> watchForUser() async* {
    String id = Preferences.saver.getString('id')!;
    yield* orderApis.watch(false, id, isAdmin);
  }
}

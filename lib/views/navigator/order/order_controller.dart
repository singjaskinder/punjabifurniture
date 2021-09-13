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
import 'package:punjabifurniture/utils/overlays/progress_dialog.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';
import 'package:punjabifurniture/views/navigator/buildnavigator_controller.dart';
import 'dart:js' as js;

class OrderController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    isAdmin = (Preferences.saver.getString('type') ?? 'admin') == 'admin';
    searchCtrl.addListener(() {
      searchText.value = searchCtrl.text;
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
    getUsers();
  }

  void getUsers() async {
    users.clear();
    gettingUser.value = true;
    users = await orderApis.getUsers();
    gettingUser.value = false;
    userWithIds = {};
    for (UserM user in users) {
      userWithIds[user.name!] = user.id!;
    }
    selectedUser.value = users[0].name!;
    selectedUserId = users[0].id!;
  }

  void removeFile(int i) async {
    files.removeAt(i);
    filesNames.removeAt(i);
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx', 'xlsx', 'xls'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      files.add(file);
      filesNames.add(file.name);
    }
  }

  void selectDate(bool isOrderDate) async {
    DateTime? selectedDate;
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2025, 1, 1),
      builder: (_, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.brown,
            ),
            timePickerTheme: TimePickerTheme.of(Get.context!).copyWith(),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate = picked;
      if (isOrderDate) {
        orderDate.value = selectedDate.millisecondsSinceEpoch;
      } else {
        deliveryDate.value = selectedDate.millisecondsSinceEpoch;
      }
    }
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
      BuildDialog(description: 'Please enter order Id');
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
    final res = await orderApis.checkTypeId(orderM);
    if (res) {
      isLoading(false);
      BuildDialog(description: 'Order Id already exists');
      return;
    }
    await orderApis.create(orderM);
    clearData();
    isLoading(false);
    BuildDialog(
        title: 'Success',
        description: isUpdate ? 'Order details updated' : 'New order added');
  }

  void clearData() {
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
}

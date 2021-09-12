import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/order.dart';
import 'package:punjabifurniture/common/build_circular_loading.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/models/order_m.dart';
import 'package:punjabifurniture/models/user_m.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/overlays/progress_dialog.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/res/app_styles.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:js' as js;

class DashboardController extends GetxController {
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

  Stream<QuerySnapshot> watch() async* {
    if (isAdmin) {
      yield* watchForAdmin();
    } else {
      yield* watchForUser();
    }
  }

  String getNotes(OrderM order) {
    return isAdmin ? order.adminNote! : order.userNote!;
  }

  void showOrderDialog(bool isUpdate, OrderM? order) {
    if (isUpdate) {
      typedIdCtrl.text = order!.typeId!;
      jobDetailsCtrl.text = order.jobDetails!;
      orderDate.value = order.orderDate!;
      deliveryDate.value = order.deliveryDate!;
      noteCtrl.text = getNotes(order);
      selectedUser.value = order.company!;
      selectedUserId = order.userId!;
      files.clear();
      for (Files file in order.files ?? []) {
        files.add(file);
        filesNames.add(file.fileName!);
        // networkfiles.add(file);
      }
    } else {
      getUsers();
    }
    Get.dialog(Scaffold(
        backgroundColor: AppColors.black.withOpacity(0.5),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(15),
                  color: AppColors.white,
                  width: getValueForScreenType<double>(
                    context: Get.context!,
                    mobile: SizeConfig.widthMultiplier * 90,
                    desktop: SizeConfig.widthMultiplier * 60,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          BuildText(
                            isUpdate ? 'Update order details' : 'Create order',
                            size: getValueForScreenType<double>(
                              context: Get.context!,
                              mobile: 2.8,
                              desktop: 2,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Get.back();
                                clearData();
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                      Divider(
                        color: AppColors.lightBrown,
                      ),
                      BuildSizedBox(
                        height: 2,
                      ),
                      TextField(
                        enabled: isAdmin,
                        controller: typedIdCtrl,
                        style:
                            AppStyles.primaryTextStyle.copyWith(fontSize: 18),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: 'Order Id',
                            filled: true,
                            fillColor: AppColors.brown.withOpacity(0.1),
                            isDense: true),
                      ),
                      BuildSizedBox(),
                      Visibility(
                        visible: isAdmin && !isUpdate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: BuildText(
                                'Select Company:',
                                fontWeight: FontWeight.bold,
                                size: getValueForScreenType<double>(
                                  context: Get.context!,
                                  mobile: 2,
                                  desktop: 1,
                                ),
                              ),
                            ),
                            BuildSizedBox(
                              height: 0.2,
                            ),
                            Obx(() => gettingUser.value
                                ? BuildCircularLoading()
                                : Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.lightBrown
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColors.darkerBrown,
                                            width: 0.5)),
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        elevation: 0,
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: const BuildText(
                                            'Select Company',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: AppColors.brown,
                                          ),
                                        ),
                                        items: users.map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value.name,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig
                                                          .widthMultiplier *
                                                      1.5),
                                              child: BuildText(
                                                value.name!,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.darkerBrown,
                                                size: getValueForScreenType<
                                                    double>(
                                                  context: Get.context!,
                                                  mobile: 2.4,
                                                  desktop: 1.2,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedUser.value,
                                        onChanged: (val) {
                                          selectedUser.value = val!;
                                          selectedUserId = userWithIds[val]!;
                                          print(selectedUserId);
                                        }),
                                  )),
                          ],
                        ),
                      ),
                      BuildSizedBox(),
                      Row(
                        children: [
                          BuildSizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: BuildText(
                              'Order Date:',
                              fontWeight: FontWeight.w400,
                              size: getValueForScreenType<double>(
                                context: Get.context!,
                                mobile: 2.6,
                                desktop: 1.4,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectDate(true),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.lighterBrown.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Obx(() => BuildText(
                                      orderDate.value == 0
                                          ? 'Select'
                                          : makeDate(orderDate.value),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      size: getValueForScreenType<double>(
                                        context: Get.context!,
                                        mobile: 2.6,
                                        desktop: 1.2,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          BuildSizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      BuildSizedBox(),
                      Row(
                        children: [
                          BuildSizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: BuildText(
                              'Delivery Date:',
                              fontWeight: FontWeight.w400,
                              size: getValueForScreenType<double>(
                                context: Get.context!,
                                mobile: 2.6,
                                desktop: 1.4,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectDate(false),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.lighterBrown.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Obx(() => BuildText(
                                      deliveryDate.value == 0
                                          ? 'Select'
                                          : makeDate(deliveryDate.value),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      size: getValueForScreenType<double>(
                                        context: Get.context!,
                                        mobile: 2.6,
                                        desktop: 1.2,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          BuildSizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      BuildSizedBox(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: BuildText(
                          'Select status:',
                          fontWeight: FontWeight.bold,
                          size: getValueForScreenType<double>(
                            context: Get.context!,
                            mobile: 2,
                            desktop: 1,
                          ),
                        ),
                      ),
                      BuildSizedBox(
                        height: 0.2,
                      ),
                      Obx(() => Container(
                            decoration: BoxDecoration(
                                color: AppColors.lightBrown.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: AppColors.darkerBrown, width: 0.5)),
                            child: DropdownButton<String>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                elevation: 0,
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: const BuildText(
                                    'Select Status',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.brown,
                                  ),
                                ),
                                items: actions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              SizeConfig.widthMultiplier * 1.5),
                                      child: BuildText(
                                        value,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.darkerBrown,
                                        size: getValueForScreenType<double>(
                                          context: Get.context!,
                                          mobile: 2.4,
                                          desktop: 1.2,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                value: selectedStatus.value,
                                onChanged: (val) =>
                                    selectedStatus.value = val!),
                          )),
                      BuildSizedBox(),
                      Visibility(
                        visible: !isUpdate,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => selectFile(),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.lighterBrown.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4)),
                              child: BuildText(
                                'Select Files',
                                fontWeight: FontWeight.bold,
                                size: getValueForScreenType<double>(
                                  context: Get.context!,
                                  mobile: 1.8,
                                  desktop: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      BuildSizedBox(
                        height: 0.6,
                      ),
                      Obx(() => filesNames.isEmpty
                          ? SizedBox()
                          : Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filesNames.length,
                                  itemBuilder: (_, i) {
                                    final file = filesNames[i];
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 14),
                                      decoration: BoxDecoration(
                                          color: AppColors.lighterBrown,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          BuildText(
                                            file,
                                            size: getValueForScreenType<double>(
                                              context: Get.context!,
                                              mobile: 1.8,
                                              desktop: 1,
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () =>
                                                decideProcess(isUpdate, i),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Icon(
                                                isUpdate
                                                    ? Icons.download
                                                    : Icons.close,
                                                color: AppColors.black,
                                                size: getValueForScreenType<
                                                    double>(
                                                  context: Get.context!,
                                                  mobile: SizeConfig
                                                          .imageSizeMultiplier *
                                                      4,
                                                  desktop: SizeConfig
                                                          .imageSizeMultiplier *
                                                      2,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            )),
                      BuildSizedBox(),
                      Column(
                        children: [
                          TextField(
                            controller: jobDetailsCtrl,
                            maxLines: 2,
                            style: AppStyles.primaryTextStyle
                                .copyWith(fontSize: 18),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: 'Job details',
                                filled: true,
                                fillColor: AppColors.brown.withOpacity(0.1),
                                isDense: true),
                          ),
                          BuildSizedBox(),
                          TextField(
                            controller: noteCtrl,
                            maxLines: 3,
                            style: AppStyles.primaryTextStyle
                                .copyWith(fontSize: 18),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: 'Additional Notes or message',
                                filled: true,
                                fillColor: AppColors.brown.withOpacity(0.1),
                                isDense: true),
                          ),
                        ],
                      ),
                      BuildSizedBox(),
                      BuildSizedBox(
                        height: 3,
                      ),
                      BuildPrimaryButton(
                        onTap: () => auOrder(isUpdate, order),
                        label: isUpdate ? 'Update Details' : 'Add +',
                        fontSize: getValueForScreenType<double>(
                          context: Get.context!,
                          mobile: 2.5,
                          desktop: 1.8,
                        ),
                      ),
                      BuildSizedBox(),
                    ],
                  ))),
        )));
  }

  void decideProcess(bool isUpdate, int i) async {
    if (isUpdate) {
      js.context.callMethod('open', [files[i].link]);
    } else {
      files.removeAt(i);
      filesNames.removeAt(i);
    }
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
    final res = await orderApis.checkTypeId(orderM);
    if (res) {
      isLoading(false);
      BuildDialog(description: 'Order Id already exists');
      return;
    }
    if (isUpdate) {
      await orderApis.update(orderM);
    } else {
      await orderApis.create(orderM);
    }
    Get.back();
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

  Future<void> delete(OrderM order) async {
    try {
      isLoading(true);
      orderApis.delete(order);
      isLoading(false);
      BuildDialog(title: 'Success', description: 'Order has been removed');
    } catch (e) {
      print(e);
      isLoading(false);
      BuildDialog();
    }
  }

  Stream<QuerySnapshot> watchForAdmin() async* {
    yield* orderApis.watch(false, searchText.value, isAdmin);
  }

  Stream<QuerySnapshot> watchForUser() async* {
    String id = Preferences.saver.getString('id')!;
    yield* orderApis.watch(false, id, isAdmin);
  }
}

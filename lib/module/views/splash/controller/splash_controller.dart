import 'dart:async';
import 'package:budget_tracker_app/module/helper/database_helper.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    DBHelper.dbHelper.initDB();
    Timer(
      const Duration(seconds: 2),
      () => Get.offAllNamed('/'),
    );
  }
}

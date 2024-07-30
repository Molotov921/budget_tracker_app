import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_tracker_app/module/helper/database_helper.dart';
import 'package:budget_tracker_app/module/model/category.dart';
import 'package:budget_tracker_app/module/views/homepage/model/fetch_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxInt currentPage = 0.obs;

  List<FetchedCategory> fetchedCategory = [];
  List<Map<String, Object?>> fetchedBudget = [];
  PageController pageController = PageController();
  DateTime dateTime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  TextEditingController moneyController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  RxString date = "".obs;
  RxString time = "".obs;
  RxString selCategory = "".obs;
  RxString selPaymentMethod = "".obs;
  RxString selType = "".obs;

  RxBool addBudgetIconVisibleOrNot = false.obs;

  List<CategoryData> allCategory = [
    CategoryData(
        categoryName: "Travelling",
        categoryImage: "assets/icon/travelling.png",
        isSelect: false),
    CategoryData(
        categoryName: "Salary",
        categoryImage: "assets/icon/salary.png",
        isSelect: false),
    CategoryData(
        categoryName: "Rent",
        categoryImage: "assets/icon/rent.png",
        isSelect: false),
    CategoryData(
        categoryName: "Recharge",
        categoryImage: "assets/icon/recharge.png",
        isSelect: false),
    CategoryData(
        categoryName: "Ott",
        categoryImage: "assets/icon/ott.png",
        isSelect: false),
    CategoryData(
        categoryName: "Shopping",
        categoryImage: "assets/icon/online-shopping.png",
        isSelect: false),
    CategoryData(
        categoryName: "Loan",
        categoryImage: "assets/icon/loan.png",
        isSelect: false),
    CategoryData(
        categoryName: "Hospital",
        categoryImage: "assets/icon/hospital.png",
        isSelect: false),
    CategoryData(
        categoryName: "Electricity",
        categoryImage: "assets/icon/electrical-energy.png",
        isSelect: false),
    CategoryData(
        categoryName: "Education",
        categoryImage: "assets/icon/education.png",
        isSelect: false),
    CategoryData(
        categoryName: "Food",
        categoryImage: "assets/icon/diet.png",
        isSelect: false),
    CategoryData(
        categoryName: "Business",
        categoryImage: "assets/icon/business-model.png",
        isSelect: false),
  ];

  RxBool isVisible = false.obs;

  @override
  void onInit() async {
    super.onInit();
    fetchedCategory = await DBHelper.dbHelper.fetchCategoryAllData();
    fetchedBudget = await DBHelper.dbHelper.fetchAllBudget();

    date.value = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    time.value =
        "${timeOfDay.hour}:${timeOfDay.minute} ${timeOfDay.period.name}";

    fetchTimeRemoveCategory();
  }

  Object? budgetImage(String categoryName) {
    Object? image;

    for (var element in fetchedCategory) {
      if (element.catName == categoryName) {
        image = element.catImage;
      }
    }
    return image;
  }

  editBudgetData(Map<String, Object?> data) {}

  Future<void> deleteBudget(id) async {
    await DBHelper.dbHelper.deleteBudget(id);
    fetchedBudget = await DBHelper.dbHelper.fetchAllBudget();
    update();
  }

  bottomSheetForUpdate(Map<String, Object?> e, BuildContext context) {
    TextEditingController moneyEditingController = TextEditingController();
    TextEditingController noteEditingController = TextEditingController();
    String editDate = "";
    String editTime = "";
    String editSelPaymentMethod = "";
    String editSelType = "";
    String? editSelCategory = "";

    moneyEditingController.text = e['amount'] as String;
    noteEditingController.text = e['note'] as String;
    editDate = e['date'] as String;
    editTime = e['time'] as String;
    editSelPaymentMethod = e['method'] as String;
    editSelType = e['type'] as String;
    editSelCategory = e['category'] as String;

    void editDateChanges(DateTime? date) {
      editDate = "${date!.day}/${date.month}/${date.year}";
      update();
    }

    void editTimeChanges(TimeOfDay? time) {
      editTime = "${time!.hour}:${time.minute} ${time.period.name}";
      update();
    }

    void editMethodChanges(String val) {
      editSelPaymentMethod = val;
      update();
    }

    void editTypeChanges(String val) {
      editSelType = val;
      update();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          height: 750,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.lightGreen.shade300,
              ],
            ),
          ),
          child: GetBuilder<HomePageController>(builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 30,
                  ),
                  child: TextField(
                    onChanged: (val) {},
                    controller: moneyEditingController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(30),
                      border: OutlineInputBorder(),
                      hintText: "Amount in Rs.",
                      hintStyle: TextStyle(fontSize: 30),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: noteEditingController,
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: "Add a note",
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              DateTime? selectDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2025),
                              );
                              editDateChanges(selectDate);
                            },
                            icon: const Icon(Icons.date_range),
                          ),
                          Text(
                            editDate,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              TimeOfDay? selectTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              editTimeChanges(selectTime);
                            },
                            icon: const Icon(Icons.timer),
                          ),
                          Text(
                            "$editTime     ",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Payment Method:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: "Online",
                          groupValue: editSelPaymentMethod,
                          onChanged: (val) {
                            editMethodChanges(val!);
                          },
                          activeColor: Colors.green.shade800,
                        ),
                        const Text("Online", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        Radio(
                          value: "Cash",
                          groupValue: editSelPaymentMethod,
                          onChanged: (val) {
                            editMethodChanges(val!);
                          },
                          activeColor: Colors.green.shade800,
                        ),
                        const Text("Cash", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Payment Type:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: "Income",
                          groupValue: editSelType,
                          onChanged: (val) {
                            editTypeChanges(val!);
                          },
                          activeColor: Colors.green.shade800,
                        ),
                        const Text("Income", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        Radio(
                          value: "Expense",
                          groupValue: editSelType,
                          onChanged: (val) {
                            editTypeChanges(val!);
                          },
                          activeColor: Colors.green.shade800,
                        ),
                        const Text("Expence", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Category:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: DropdownButtonFormField(
                          value: editSelCategory,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Category",
                            contentPadding: EdgeInsets.only(
                              left: 5,
                              right: 3,
                            ),
                          ),
                          dropdownColor: Colors.lightGreen.shade200,
                          items: fetchedCategory
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.catName,
                                  child: Text(e.catName),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            editSelCategory = val!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        moneyEditingController.clear();
                        noteEditingController.clear();
                        editDate = "";
                        editTime = "";
                        editSelPaymentMethod = "";
                        editSelType = "";
                        editSelCategory = "";
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await DBHelper.dbHelper
                            .updateBudgetRecord(
                                moneyEditingController.text,
                                noteEditingController.text,
                                editDate,
                                editTime,
                                editSelPaymentMethod,
                                editSelType,
                                editSelCategory!,
                                e['budgetId'] as int)
                            .then((value) async {
                          moneyEditingController.clear();
                          noteEditingController.clear();
                          editDate = "";
                          editTime = "";
                          editSelPaymentMethod = "";
                          editSelType = "";
                          editSelCategory = null;

                          Get.back();
                          fetchedBudget =
                              await DBHelper.dbHelper.fetchAllBudget();
                          update();

                          SnackBar snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Success!',
                              message: 'Budget update successfully!!',
                              contentType: ContentType.success,
                            ),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade800),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future<void> insertBudgetData(BuildContext ctx) async {
    await DBHelper.dbHelper
        .insertBudget(
            moneyController.text,
            noteController.text,
            date.value,
            time.value,
            selPaymentMethod.value,
            selType.value,
            selCategory.value)
        .then((value) {
      SnackBar snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Budget ${moneyController.text} added successfully!!',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(ctx)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      noteController.clear();
      moneyController.clear();
      date.value = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      time.value =
          "${timeOfDay.hour}:${timeOfDay.minute} ${timeOfDay.period.name}";
      selPaymentMethod.value = "";
      selType.value = "";
      selCategory.value = "";
      iconVisibleOrNot();
    });
  }

  void iconVisibleOrNot() {
    if (moneyController.text.isNotEmpty &&
        noteController.text.isNotEmpty &&
        selCategory.value != "" &&
        selPaymentMethod.value != "" &&
        selType.value != "") {
      addBudgetIconVisibleOrNot.value = true;
    } else {
      addBudgetIconVisibleOrNot.value = false;
    }
  }

  void changedSelPaymentMethod(String? val) {
    selPaymentMethod.value = val!;
    iconVisibleOrNot();
  }

  void changedSelType(String? val) {
    selType.value = val!;
    iconVisibleOrNot();
  }

  void setSelectedCategory(String val) {
    selCategory.value = val;
    iconVisibleOrNot();
  }

  void fetchTimeRemoveCategory() {
    List<CategoryData> toRemoveCategory = [];

    for (var element in fetchedCategory) {
      for (var e in allCategory) {
        if (e.categoryName == element.catName) {
          toRemoveCategory.add(e);
        }
      }
    }

    allCategory.removeWhere((element) => toRemoveCategory.contains(element));
    update();
  }

  void selectDate(DateTime? selectDate) {
    date.value = "${selectDate!.day}/${selectDate.month}/${selectDate.year}";
  }

  void selectTime(TimeOfDay? selectTime) {
    time.value =
        "${selectTime!.hour}:${selectTime.minute} ${selectTime.period.name}";
  }

  void iconVisibility() {
    int bug = 0;
    for (var element in allCategory) {
      if (element.isSelect == false) {
        bug++;
      }
    }

    if (bug == allCategory.length) {
      isVisible.value = false;
    } else {
      isVisible.value = true;
    }
  }

  void removeCategory(CategoryData data) {
    allCategory.remove(data);
    update();
  }

  Future<void> changePage(int val) async {
    fetchedCategory = await DBHelper.dbHelper.fetchCategoryAllData();
    fetchedBudget = await DBHelper.dbHelper.fetchAllBudget();
    currentPage.value = val;
    pageController.animateToPage(
      val,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void selectCategory(CategoryData data) {
    data.isSelect = !data.isSelect;
    update();
  }

  void uploadedCategory(CategoryData data) {
    data.isSelect = false;
    update();
  }
}

import 'package:budget_tracker_app/module/views/homepage/controller/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBudget extends StatelessWidget {
  const AddBudget({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController homePageController = Get.put(HomePageController());

    return Container(
      alignment: Alignment.topCenter,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "Add Budget",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Obx(
                () {
                  return Visibility(
                    visible: homePageController.addBudgetIconVisibleOrNot.value,
                    child: IconButton(
                      onPressed: () async {
                        homePageController.insertBudgetData(context);
                      },
                      icon: Icon(
                        Icons.add_task,
                        color: Colors.green.shade800,
                      ),
                    ),
                  );
                },
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 30,
                  ),
                  child: TextField(
                    onChanged: (val) {
                      homePageController.iconVisibleOrNot();
                    },
                    controller: homePageController.moneyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(),
                      hintText: "Amount in Rs.",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: homePageController.noteController,
                  onChanged: (val) {
                    homePageController.iconVisibleOrNot();
                  },
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
                                initialDate: homePageController.dateTime,
                              );

                              homePageController.selectDate(selectDate);
                            },
                            icon: const Icon(Icons.date_range),
                          ),
                          Obx(
                            () {
                              return Text(
                                homePageController.date.value,
                                style: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              TimeOfDay? selectTime = await showTimePicker(
                                context: context,
                                initialTime: homePageController.timeOfDay,
                              );

                              homePageController.selectTime(selectTime);
                            },
                            icon: const Icon(Icons.timer),
                          ),
                          Obx(
                            () {
                              return Text(
                                "${homePageController.time.value}     ",
                                style: const TextStyle(fontSize: 16),
                              );
                            },
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
                        Obx(
                          () {
                            return Radio(
                              value: "Online",
                              groupValue:
                                  homePageController.selPaymentMethod.value,
                              onChanged: (val) {
                                homePageController.changedSelPaymentMethod(val);
                              },
                              activeColor: Colors.green.shade800,
                            );
                          },
                        ),
                        const Text("Online", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        Obx(
                          () {
                            return Radio(
                              value: "Cash",
                              groupValue:
                                  homePageController.selPaymentMethod.value,
                              onChanged: (val) {
                                homePageController.changedSelPaymentMethod(val);
                              },
                              activeColor: Colors.green.shade800,
                            );
                          },
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
                        Obx(
                          () {
                            return Radio(
                              value: "Income",
                              groupValue: homePageController.selType.value,
                              onChanged: (val) {
                                homePageController.changedSelType(val);
                              },
                              activeColor: Colors.green.shade800,
                            );
                          },
                        ),
                        const Text("Income", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        Obx(
                          () {
                            return Radio(
                              value: "Expense",
                              groupValue: homePageController.selType.value,
                              onChanged: (val) {
                                homePageController.changedSelType(val);
                              },
                              activeColor: Colors.green.shade800,
                            );
                          },
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
                          value: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Category",
                            contentPadding: EdgeInsets.only(
                              left: 5,
                              right: 3,
                            ),
                          ),
                          dropdownColor: Colors.lightGreen.shade200,
                          items: homePageController.fetchedCategory
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.catName,
                                  child: Text(e.catName),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            homePageController.setSelectedCategory(val!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:budget_tracker_app/module/views/homepage/controller/homepage_controller.dart';
import 'package:budget_tracker_app/module/views/homepage/screens/components/add_budget.dart';
import 'package:budget_tracker_app/module/views/homepage/screens/components/budget_history.dart';
import 'package:budget_tracker_app/module/views/homepage/screens/components/categories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController homePageController = Get.put(HomePageController());

    List<Widget> pages = [
      const Categories(),
      const AddBudget(),
      const BudgetHistory(),
    ];

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.lightGreen.shade300,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PageView(
                  onPageChanged: (val) async {
                    await homePageController.changePage(val);
                  },
                  controller: homePageController.pageController,
                  children: pages,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(0.75),
                  ),
                  child: Obx(
                    () => BottomNavigationBar(
                      currentIndex: homePageController.currentPage.value,
                      onTap: (val) async {
                        await homePageController.changePage(val);
                      },
                      elevation: 0,
                      type: BottomNavigationBarType.shifting,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.lightGreen.shade200,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.category),
                          label: 'Add Category',
                          backgroundColor: Colors.transparent,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.monetization_on),
                          label: 'Add Budget',
                          backgroundColor: Colors.transparent,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.history),
                          label: 'Budget History',
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

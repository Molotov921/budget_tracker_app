import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_tracker_app/module/helper/database_helper.dart';
import 'package:budget_tracker_app/module/views/homepage/controller/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController homePageController = Get.put(HomePageController());

    Future<void> insertData() async {
      for (var element in homePageController.allCategory) {
        if (element.isSelect) {
          ByteData byteData = await rootBundle.load(element.categoryImage);
          Uint8List uInt8list = byteData.buffer.asUint8List();

          DBHelper.dbHelper
              .insertCategory(element.categoryName, uInt8list)
              .then((value) {
            homePageController.uploadedCategory(element);
            homePageController.removeCategory(element);
            SnackBar snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Success!',
                message: 'Category added successfully!!',
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          });
        }
      }
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(
            "Categories",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            GetBuilder<HomePageController>(builder: (controller) {
              return Visibility(
                visible: homePageController.isVisible.value,
                child: IconButton(
                  onPressed: () async {
                    await insertData();
                  },
                  icon: const Icon(Icons.add_circle),
                ),
              );
            }),
          ],
          backgroundColor: Colors.transparent,
        ),
        GetBuilder<HomePageController>(builder: (controller) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: homePageController.allCategory.length,
              (context, index) {
                return GestureDetector(
                  onTap: () {
                    homePageController.selectCategory(
                      homePageController.allCategory[index],
                    );
                    homePageController.iconVisibility();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(18),
                      border: (homePageController.allCategory[index].isSelect)
                          ? Border.all(
                              color: Colors.black,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          homePageController.allCategory[index].categoryImage,
                          height: 80,
                        ),
                        Text(
                          homePageController.allCategory[index].categoryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
          );
        })
      ],
    );
  }
}

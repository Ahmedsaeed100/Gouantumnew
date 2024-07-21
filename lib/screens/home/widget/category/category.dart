import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utilities/palette.dart';
import '../../home_controller.dart';

class AppCategories extends StatelessWidget {
  AppCategories({
    super.key,
    required this.size,
  });
  final Size size;
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isDataLoadingCategory.value
        ? const Center(child: CircularProgressIndicator())
        : Container(
            height: size.height * 0.15,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories!.length,
              itemBuilder: (context, index) {
                final category = controller.categories![index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.01,
                  ),
                  height: size.height * 0.15,
                  width: size.width * 0.3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.network(
                          category.image!,
                          width: size.width,
                          height: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: size.height * 0.04,
                          width: size.width * 0.31,
                          decoration: BoxDecoration(
                            gradient: Palette.myLinearGradientTow,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            category.name!,
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ));
  }
}

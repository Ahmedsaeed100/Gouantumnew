import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/home/widget/posts/add_post.dart';
import 'package:gouantum/utilities/palette.dart';
import '../../widgets/widgets.dart';
import 'home_controller.dart';
import 'widget/app_bar.dart';
import 'widget/category/category.dart';
import 'widget/featured_providers.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({
    super.key,
  });

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.07),
        child: HomeAppBar(size: size),
      ),
      body: Obx(
        () => homeController.isDataLoading.value ||
                homeController.isDataLoadingPosts.value
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Palette.mainBlueColor),
                ),
              )
            : Container(
                color: Palette.mainBlueColor,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!homeController.isDataLoadingPosts.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      // print("lasttttttttttttttttttttt");
                      // controller.loadMorePosts();
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: homeController.scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: size.height * 0.01,
                            top: size.height * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // User Short State // User Image and User Rate and his Minute Price
                              UserShortState(size: size),
                              //Go Live Button
                              // GoLiveIcon(size: size),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: UserAddPost(size: size),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          // height: size.height * 0.58,
                          height: size.height * 0.56,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.025,
                              vertical: size.height * 0.015,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: size.width * 0.03),
                                    Text(
                                      "Categories",
                                      style: TextStyle(
                                        fontSize: size.width * 0.050,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    //const Spacer(),
                                    // TextButton
                                    // TextButton(
                                    //   onPressed: () {
                                    //     Get.to(const AddCategory());
                                    //   },
                                    //   child: Text(
                                    //     "Add Category",
                                    //     style: TextStyle(
                                    //       fontSize: size.width * 0.04,
                                    //       fontWeight: FontWeight.w500,
                                    //       color: Palette.mainBlueColor,
                                    //       fontFamily: "Poppins",
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                AppCategories(size: size),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: size.width * 0.03,
                                    top: size.height * 0.03,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Featured Providers",
                                        style: TextStyle(
                                          fontSize: size.width * 0.050,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: size.width * 0.035,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FeaturedProviders(size: size),
                                Text(
                                  "Newsfeed",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Palette.darkGrayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => homeController.isDataLoadingPosts.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Palette.mainBlueColor,
                                  ),
                                ),
                              )
                            : SliverToBoxAdapter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: homeController.postsModel!.length,
                                  itemBuilder: (context, index) {
                                    return UserPosts(
                                      size: size,
                                      postsModel:
                                          homeController.postsModel![index],
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

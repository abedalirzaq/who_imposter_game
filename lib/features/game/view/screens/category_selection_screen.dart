import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_imposter/features/ads_manager/view/widgets/banner_ad_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../controller/game_controller.dart';

class CategorySelectionScreen extends StatelessWidget {
  CategorySelectionScreen({super.key});

  final GameController controller = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(
        slotId: 'category_screen_bottom',
        adSize: AdSize.banner,
      ),
      backgroundColor: Color(0xFF1c2528),

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child:
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: FaIcon(
                            FontAwesomeIcons.arrowLeftLong,
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            shape: BoxShape.circle,
                          ),
                        ).animate().scale(
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                              'اختر الفئة',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .moveY(
                              begin: -10,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "لا يمكنك تخصيص الاعدادات حاليا",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.yellowAccent,
                          margin: EdgeInsets.only(
                            bottom: 30,
                            left: 20,
                            right: 20,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: FaIcon(FontAwesomeIcons.gear, color: Colors.black),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                    delay: 200.ms,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Obx(() {
                  if (controller.words.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                  final categories = controller.categories;

                  return ListView(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.0,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isRandom = category == 'عشوائي';
                          final imagePath = _getCategoryImage(category);

                          return GestureDetector(
                                onTap: () =>
                                    controller.selectCategory(category),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Background Image
                                      if (imagePath != null)
                                        Image.asset(
                                          imagePath,
                                          fit: BoxFit.cover,
                                        )
                                      else
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isRandom
                                                  ? [
                                                      Colors.orangeAccent,
                                                      Colors.deepOrange,
                                                    ]
                                                  : [
                                                      const Color(0xFF333333),
                                                      const Color(0xFF555555),
                                                    ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                        ),

                                      // Black Overlay
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.5),
                                              Colors.black.withOpacity(1),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Category Name
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            category,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10,
                                                  color: Colors.black,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),

                                      // Recommended Label
                                      if (isRandom)
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.yellowAccent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'موصى به',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: (index * 50).ms)
                              .scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1, 1),
                                duration: 500.ms,
                                curve: Curves.easeOutBack,
                                delay: (index * 50).ms,
                              );
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getCategoryImage(String category) {
    switch (category) {
      case 'برمجة':
        return 'assets/images/categories/dev.png';
      case 'حيوانات':
        return 'assets/images/categories/animals.png';
      case 'مأكولات':
        return 'assets/images/categories/food.png';
      case 'سيارات':
        return 'assets/images/categories/cars.png';
      case 'دول':
        return 'assets/images/categories/country.png';
      case 'فواكة وخضراوات':
        return 'assets/images/categories/fruits.png';
      case 'مهن':
        return 'assets/images/categories/jobs.png';
      case 'أثاث':
        return 'assets/images/categories/home_items.png';
      case 'عشوائي':
        return 'assets/images/categories/random.png';
      default:
        return null;
    }
  }
}

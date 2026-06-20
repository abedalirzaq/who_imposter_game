import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/controllers/system_controller.dart';
import '../../../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _startAnimation = false;
  final GlobalKey _startButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  Future<void> _initSplash() async {
    // 1. Start the 3-second timer
    final timerFuture = Future.delayed(const Duration(seconds: 3));

    // 2. Wait for BOTH the 3-second timer and the config API call
    final systemController = Get.find<SystemController>();

    await Future.wait([timerFuture, systemController.configFetchFuture]);

    if (mounted) {
      setState(() {
        _startAnimation = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              // Logo & Loading Animation
              AnimatedAlign(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOutQuart,
                alignment: _startAnimation
                    ? const Alignment(0, -0.5)
                    : Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOutQuart,
                      width: _startAnimation
                          ? size.width * 0.6
                          : size.width * 0.8,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _startAnimation ? 0.0 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: const SizedBox(
                          width: 35,
                          height: 35,
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Buttons Section (Start / Update)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                bottom: _startAnimation ? 120 : -250,
                left: 0,
                right: 0,
                child: GetBuilder<SystemController>(
                  builder: (sys) {
                    final config = sys.apiConfig;
                    final status = config.appStatus;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status 2: Show Message above Update Button
                        if (status == 2)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child:
                                Text(
                                      config.updateMessage,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .moveY(begin: 10, end: 0),
                          ),

                        // Status 0 or 1: Show Start Game Button
                        if (status == 0 || status == 1)
                          Center(
                            child:
                                ElevatedButton(
                                      key: _startButtonKey,
                                      onPressed: () {
                                        final RenderBox? renderBox =
                                            _startButtonKey.currentContext
                                                    ?.findRenderObject()
                                                as RenderBox?;
                                        Offset? center;
                                        if (renderBox != null) {
                                          final size = renderBox.size;
                                          final offset = renderBox
                                              .localToGlobal(Offset.zero);
                                          center = Offset(
                                            offset.dx + size.width / 2,
                                            offset.dy + size.height / 2,
                                          );
                                        }

                                        Navigator.of(context).push(
                                          CircularRevealRoute(
                                            page: const MainGameNavigation(),
                                            center: center,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellowAccent,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50,
                                          vertical: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        elevation: 10,
                                      ),
                                      child: const Text(
                                        'ابدأ اللعب',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .animate(target: _startAnimation ? 1 : 0)
                                    .scale(
                                      delay: 500.ms,
                                      duration: 600.ms,
                                      curve: Curves.easeOutBack,
                                    )
                                    .fadeIn(delay: 500.ms, duration: 400.ms),
                          ),

                        if (status == 1) const SizedBox(height: 15),

                        // Status 1 or 2: Show Update Button in Green
                        if (status == 1 || status == 2)
                          Center(
                            child:
                                ElevatedButton.icon(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(
                                          config.updateUrl,
                                        );
                                        try {
                                          if (!await launchUrl(
                                            url,
                                            mode:
                                                LaunchMode.externalApplication,
                                          )) {
                                            throw Exception(
                                              'Could not launch $url',
                                            );
                                          }
                                        } catch (e) {
                                          debugPrint(
                                            'Error launching update URL: $e',
                                          );
                                        }
                                      },
                                      label: const Text(
                                        'تحديث الآن',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 700.ms, duration: 500.ms)
                                    .shake(delay: 1000.ms, duration: 500.ms),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // Footer Animation
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                bottom: _startAnimation ? 50 : 70,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _startAnimation ? 0.6 : 1.0,
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        try {
                          final config = Get.find<SystemController>().apiConfig;
                          final Uri url = Uri.parse(config.developerUrl);
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        } catch (e) {
                          debugPrint('Error launching URL: $e');
                        }
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'بواسطة ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          children: [
                            TextSpan(
                              text: Get.find<SystemController>()
                                  .apiConfig
                                  .developerName,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                decorationColor: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularRevealRoute extends PageRouteBuilder {
  final Widget page;
  final Offset? center;

  CircularRevealRoute({required this.page, this.center})
    : super(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ClipPath(
            clipper: MyCircularRevealClipper(
              fraction: animation.value,
              center: center,
            ),
            child: child,
          );
        },
      );
}

class MyCircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset? center;

  MyCircularRevealClipper({required this.fraction, this.center});

  @override
  Path getClip(Size size) {
    final Offset center =
        this.center ?? Offset(size.width / 2, size.height / 2);

    final double maxRadius = _calculateMaxRadius(size, center);

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
  }

  double _calculateMaxRadius(Size size, Offset center) {
    final double w = size.width;
    final double h = size.height;
    final double dx = center.dx;
    final double dy = center.dy;

    final double d1 = _distance(dx, dy, 0, 0);
    final double d2 = _distance(dx, dy, w, 0);
    final double d3 = _distance(dx, dy, 0, h);
    final double d4 = _distance(dx, dy, w, h);

    return [d1, d2, d3, d4].reduce(math.max);
  }

  double _distance(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
  }

  @override
  bool shouldReclip(MyCircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}

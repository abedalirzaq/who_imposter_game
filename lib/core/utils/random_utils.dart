import 'dart:math';

class RandomUtils {
  static final Random _random = Random();

  static int generateRandomIndex(int length) {
    if (length <= 0) return 0;
    return _random.nextInt(length);
  }
}

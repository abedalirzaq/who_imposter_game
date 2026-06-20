import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:game_imposter/core/config/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SystemController extends GetxController {
  final ApiConfig apiConfig = ApiConfig();
  final Completer<void> _configCompleter = Completer<void>();

  Future<void> get configFetchFuture => _configCompleter.future;

  @override
  void onInit() {
    super.onInit();
    getConfigFromApi();
  }

  Future<void> getConfigFromApi() async {
    try {
      final String baseUrl =
          "https://gist.githubusercontent.com/abedalirzaq/e9297a8c734a67bae79f2e9725399fcf/raw/gistfile1.txt";
      final int cacheTimestamp = DateTime.now().millisecondsSinceEpoch;
      final Uri url = Uri.parse("$baseUrl?cache=$cacheTimestamp");

      final response = await http.get(url).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint("data ============================");
        debugPrint(data.toString());
        apiConfig.fromMap(data);
        if (kDebugMode) {
          debugPrint("Config loaded successfully: $data");
        }
      } else {
        if (kDebugMode) {
          debugPrint("Failed to load config: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error fetching config: $e");
      }
    } finally {
      if (!_configCompleter.isCompleted) {
        _configCompleter.complete();
      }
      update();
    }
  }
}

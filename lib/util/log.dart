import 'package:logger/logger.dart';

import '../../constants/constants.dart';

class Log {
  i(String? message) {
    if (kDebugMode) {
      Logger().i(message);
    }
  }

  e(String? message) {
    if (kDebugMode) {
      Logger().e(message);
    }
  }
}

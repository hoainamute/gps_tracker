import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger();

  static void logInfo(String message) {
    _logger.i(message);
  }

  static void logError(String message) {
    _logger.e(message);
  }

  static void logWarning(String message) {
    _logger.w(message);
  }

  static void logDebug(String message) {
    _logger.d(message);
  }
}

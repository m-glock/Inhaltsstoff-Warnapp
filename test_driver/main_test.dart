import 'package:flutter_driver/driver_extension.dart';
import '../lib/main.dart' as app;

/*
to run the integration test, type in the console: flutter drive --target=test_driver/main_test.dart
 */
void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}
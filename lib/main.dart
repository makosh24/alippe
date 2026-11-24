import 'package:alippe/src/app.dart';
import 'package:alippe/src/parent/media_override_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _startUp();
  runApp(const MyApp());
}

/// Storage and the system UI must not keep the alphabet off the screen.
Future<void> _startUp() async {
  try {
    await MediaOverrideStore.instance
        .ensureLoaded()
        .timeout(const Duration(seconds: 3));
  } catch (error, stack) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stack,
      library: 'alippe',
      context: ErrorDescription('while loading letter pictures and voices'),
    ));
  }
  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
        .timeout(const Duration(seconds: 2));
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).timeout(const Duration(seconds: 2));
  } catch (error, stack) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stack,
      library: 'alippe',
      context: ErrorDescription('while setting landscape mode'),
    ));
  }
}

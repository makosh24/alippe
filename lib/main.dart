import 'package:alippe/src/app.dart';
import 'package:flutter/material.dart';
// Step 1
import 'package:flutter/services.dart';

void main() {
  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

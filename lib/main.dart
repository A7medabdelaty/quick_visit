import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/service_initializer.dart';

void main() async {
  await ServiceInitializer.initialize();
  runApp(const App());
}

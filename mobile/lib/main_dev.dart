import './main_app.dart';
import 'package:flutter/material.dart';
import './config/env.dart';

void main() {
  BuildEnvironment.init(
      flavor: BuildFlavor.development, baseUrl: 'http://localhost:3000/');
  assert(env != null);
  runApp(new MyApp());
}
import './main_app.dart';
import 'package:flutter/material.dart';
import './config/env.dart';

void main() {
  BuildEnvironment.init(
      flavor: BuildFlavor.production, baseUrl: 'https://mighty-refuge-38136.herokuapp.com');
  assert(env != null);
  runApp(new MyApp());
}
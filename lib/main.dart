import 'package:flutter/material.dart';
import 'package:news/di/di.dart';
import 'package:news/ui/app.dart';

void main() {
  registerDependencies();
  runApp(const App());
}

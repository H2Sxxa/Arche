import 'package:arche/impl/provider.dart';

class Singleton extends TypeProvider {
  Singleton._internal();
  static final Singleton _singleton = Singleton._internal();
  factory Singleton() => _singleton;
}

var singleton = Singleton();

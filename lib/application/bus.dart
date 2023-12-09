import 'package:arche/arche.dart';

class ArcheBus extends TypeProvider {
  ArcheBus._();
  factory ArcheBus() => singleton.provideof<ArcheBus>(instance: ArcheBus._());
  static ArcheBus get bus => ArcheBus();
  late ArcheConfig config;
  late ArcheLogger logger;
}

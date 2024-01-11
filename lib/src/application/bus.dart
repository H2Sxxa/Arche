import 'package:arche/arche.dart';

class ArcheBus extends TypeProvider {
  ArcheBus._();
  factory ArcheBus() => singleton.provideof<ArcheBus>(instance: ArcheBus._());
  static ArcheBus get bus => ArcheBus();
  static ArcheConfig get config => bus.of();
  static ArcheLogger get logger => bus.of();
  ArcheConfig get getConfig => of();
  ArcheLogger get getLogger => of();
}

import 'package:arche/arche.dart';
import 'package:flutter/widgets.dart';

enum Loglevel { info, warn, error, debug }

class Log {
  DateTime time;
  String message;
  Loglevel level;
  Log(this.time, this.message, this.level);

  @override
  String toString() {
    return "$time $level $message";
  }
}

class ArcheLogger extends Subordinate<ArcheLogger> {
  @override
  TypeProvider get provider => ArcheBus();

  late Translator<Loglevel, Color> colorTranslator;
  final List<Log> _logs = [];

  Translator<Loglevel, Color> translateColor({
    required Color info,
    required Color warn,
    required Color error,
    required Color debug,
  }) {
    colorTranslator = Translator(Loglevel.values)
        .translate(Loglevel.info, info)
        .translate(Loglevel.warn, warn)
        .translate(Loglevel.error, error)
        .translate(Loglevel.debug, debug)
        .defaultValue(info) as Translator<Loglevel, Color>;
    return colorTranslator;
  }

  void log(Loglevel level, String message) {
    var log = Log(DateTime.now(), message, level);
    debugWrite(log.toString());
    _logs.add(log);
  }

  void info(String message) => log(Loglevel.info, message);
  void warn(String message) => log(Loglevel.warn, message);
  void error(String message) => log(Loglevel.error, message);
  void debug(String message) => log(Loglevel.debug, message);

  List<Log> getLogs() {
    return _logs;
  }
}

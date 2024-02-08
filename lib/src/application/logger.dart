import 'package:arche/arche.dart';
import 'package:flutter/material.dart';

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

class ArcheLogger extends Subordinate<ArcheLogger> with ChangeNotifier {
  @override
  TypeProvider get provider => ArcheBus();

  late Translator<Loglevel, Color> colorTranslator;
  final List<Log> _logs = [];

  String Function(Log log)? formatter;
  bool visible = true;

  ArcheLogger() {
    translateColor();
  }

  Translator<Loglevel, Color> translateColor({
    Color info = Colors.green,
    Color warn = Colors.yellow,
    Color error = Colors.red,
    Color debug = Colors.blue,
  }) {
    colorTranslator = Translator<Loglevel, Color>(Loglevel.values)
        .translate(Loglevel.info, info)
        .translate(Loglevel.warn, warn)
        .translate(Loglevel.error, error)
        .translate(Loglevel.debug, debug)
        .defaultValue(info);
    return colorTranslator;
  }

  void log(Loglevel level, message) {
    var log = Log(DateTime.now(), message.toString(), level);
    if (visible) {
      debugWriteln(formatter != null ? formatter!(log) : log.toString());
    }
    _logs.add(log);
    notifyListeners();
  }

  void info(message) => log(Loglevel.info, message);
  void warn(message) => log(Loglevel.warn, message);
  void error(message) => log(Loglevel.error, message);
  void debug(message) => log(Loglevel.debug, message);

  List<Log> getLogs() {
    return _logs;
  }
}

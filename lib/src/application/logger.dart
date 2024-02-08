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
  final List<Log> _logs = [];
  bool visible = true;

  Translator<Loglevel, Color> colorTranslator =
      Translator<Loglevel, Color>(Loglevel.values)
          .translate(Loglevel.info, Colors.green)
          .translate(Loglevel.warn, Colors.yellow)
          .translate(Loglevel.error, Colors.red)
          .translate(Loglevel.debug, Colors.cyan)
          .defaultValue(Colors.green);

  String Function(Log log)? formatter;

  @override
  TypeProvider get provider => ArcheBus();

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

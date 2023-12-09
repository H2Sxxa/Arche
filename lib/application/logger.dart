import 'package:arche/arche.dart';

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

class ArcheLogger extends Subordinate {
  @override
  TypeProvider get provider => singleton.provideof(instance: ArcheBus());
  final List<Log> _logs = [];

  void log(Loglevel level, String message) {
    var log = Log(DateTime.now(), message, level);
    debugPrintln(log.toString());
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

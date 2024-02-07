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

class ArcheLogger extends Subordinate<ArcheLogger> with ChangeNotifier {
  @override
  TypeProvider get provider => ArcheBus();

  late Translator<Loglevel, Color> colorTranslator;
  final List<Log> _logs = [];

  String Function(Log log)? formatter;
  bool visible = true;

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

  void log(Loglevel level, message) {
    var log = Log(DateTime.now(), message.toString(), level);
    if (visible) {
      debugWrite(formatter != null ? formatter!(log) : log.toString());
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

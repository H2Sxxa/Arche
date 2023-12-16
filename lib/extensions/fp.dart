import 'package:arche/extensions/functions.dart';

extension FPBool on bool {
  R? then<R>(FunctionCallback<R> F) {
    if (this) {
      return F();
    }
    return null;
  }
}


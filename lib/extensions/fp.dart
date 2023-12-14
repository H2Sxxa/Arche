import 'package:arche/abc/typed.dart';

extension FPBool on bool {
  R? then<R>(FunctionCallback<R> F) {
    if (this) {
      return F();
    }
    return null;
  }
}


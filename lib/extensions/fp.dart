import 'package:arche/extensions/typedfuctions.dart';

extension FPBool on bool {
  R? then<R>(FunctionCallback<R> F) {
    if (this) {
      return F();
    }
    return null;
  }
}


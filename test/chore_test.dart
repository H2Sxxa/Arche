import 'package:arche/src/impl/cans.dart';
import 'package:arche/src/impl/debug_io.dart';
import 'package:test/test.dart';

void main() {
  test("Simple", () {
    var a = [2];
    a.last = 1;
    debugWrite(a);
  });

  test("Cans", () {
    var a = MutableCan();
    a.setValue(1);
    var b = MutableCan();
    b.setValue(10);
  });
}

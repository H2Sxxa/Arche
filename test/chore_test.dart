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
    var a = MutableCans();
    a.setValue(1);
    var b = MutableCans();
    b.setValue(10);
  });
}

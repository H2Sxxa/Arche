import 'package:arche/src/impl/cans.dart';
import 'package:arche/src/impl/debug.dart';
import 'package:test/test.dart';

class A {}

void main() {
  test("Simple", () {
    var a0 = A();
    var a1 = A();
    debugPrint("${a0.hashCode} ${a1.hashCode}");
  });

  test("Cans", () {
    var a = MutableCans();
    a.setValue(1);
    var b = MutableCans();
    b.setValue(10);
  });
}

import 'package:arche/arche.dart';
import 'package:arche/extensions/iter.dart';
import 'package:arche/src/impl/debug_io.dart';
import 'package:test/test.dart';

dynamic name() {}

void main() {
  test("Simple", () {
    var a = [2];
    a.last = 1;
    debugWriteln(a);
  });

  test("Iterator", () {
    var v = [1, 2, 3];
    var iter = v.iterator;
    debugWriteln("${iter.next()}.${iter.next()}.${iter.next()} ${iter.next()}");
  });

  test("Can Test", () {
    LazyCan can0 = const LazyCan(builder: name);

    print(can0.id);
  });
}
